#!/usr/bin/env bash
# Hook: PreToolUse, matcher: mcp__supabase__execute_sql
# Rejects a bulk DELETE/UPDATE without an explicit fresh count probe marker.
# Bypass: add `-- count-fresh:YYYYMMDD-HHMM` as a SQL comment in the query.
#
# v0.7 — operational counterpart of R7 amendment "bulk re-count immediately
# before mutation". Counts older than ~30 minutes are stale on a live system
# (cron jobs, webhooks, concurrent writers). The hook does not measure
# staleness directly — it requires the human/agent to date their probe
# and own the timestamp.
#
# Empirical foundation:
# - 2026-05-12 rembrandt ADR-0060 — bulk count drift between probe and mutation.
# - 2026-05-16 rembrandt doublons-emargement — count 351→381 between first probe
#   and DELETE because cron re-ran once in between.
# - 2026-05-14 rembrandt drift bulk reprise prénoms — passage 1→16 contacts.

set -euo pipefail

INPUT=$(cat)
QUERY=$(echo "$INPUT" | jq -r '.tool_input.query // empty' 2>/dev/null || echo "")

# Nothing to do if no query
if [[ -z "$QUERY" ]]; then
  exit 0
fi

# Detect bulk DELETE or UPDATE patterns
# Bulk = not targeted by a single primary key (WHERE id = 'uuid' / WHERE id IN ('uuid1',...))
BULK_DELETE_PATTERN='\bDELETE[[:space:]]+FROM[[:space:]]+'
BULK_UPDATE_PATTERN='\bUPDATE[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]+SET[[:space:]]+'

IS_BULK_DELETE=0
IS_BULK_UPDATE=0

if echo "$QUERY" | grep -qiE "$BULK_DELETE_PATTERN"; then
  IS_BULK_DELETE=1
fi
if echo "$QUERY" | grep -qiE "$BULK_UPDATE_PATTERN"; then
  IS_BULK_UPDATE=1
fi

# Neither bulk DELETE nor bulk UPDATE → exit silently
if [[ "$IS_BULK_DELETE" -eq 0 && "$IS_BULK_UPDATE" -eq 0 ]]; then
  exit 0
fi

# Exempt: targeted by single primary key (UUID, integer id, etc.)
# Pattern: WHERE <col> = '<uuid>' or WHERE id = <integer>
SINGLE_TARGET_PATTERN="WHERE[[:space:]]+[a-zA-Z_]+[[:space:]]*=[[:space:]]*('[0-9a-fA-F-]+'|[0-9]+)"
if echo "$QUERY" | grep -qiE "$SINGLE_TARGET_PATTERN"; then
  # Verify it's not also a bulk pattern combined with single target on another col
  # (e.g. DELETE FROM x WHERE source IS NULL AND id = 1 — still single target)
  # Heuristic: if the WHERE has only one equality on uuid/id, treat as single target.
  exit 0
fi

# Check for fresh count marker
# Format: -- count-fresh:YYYYMMDD-HHMM
COUNT_FRESH_PATTERN='--[[:space:]]*count-fresh:[0-9]{8}-[0-9]{4}'

if echo "$QUERY" | grep -qE -- "$COUNT_FRESH_PATTERN"; then
  # Marker present — extract timestamp and verify <30 min old
  MARKER=$(echo "$QUERY" | grep -oE -- "$COUNT_FRESH_PATTERN" | head -1 | sed -E 's/--[[:space:]]*count-fresh://')
  # Parse YYYYMMDD-HHMM → epoch
  MARKER_DATE=$(echo "$MARKER" | cut -d- -f1)  # YYYYMMDD
  MARKER_TIME=$(echo "$MARKER" | cut -d- -f2)  # HHMM
  MARKER_EPOCH=$(date -j -f "%Y%m%d%H%M" "${MARKER_DATE}${MARKER_TIME}" "+%s" 2>/dev/null || echo "0")
  NOW_EPOCH=$(date "+%s")
  AGE_SEC=$((NOW_EPOCH - MARKER_EPOCH))

  if [[ "$MARKER_EPOCH" -eq 0 ]]; then
    cat <<EOF >&2
⚠ [Counterpart Doctrine v0.7 — R7] count-fresh marker present but malformed.
  Expected: -- count-fresh:YYYYMMDD-HHMM (e.g. -- count-fresh:20260520-1430)
  Got: $MARKER
EOF
    exit 2
  fi

  if [[ "$AGE_SEC" -gt 1800 ]]; then
    AGE_MIN=$((AGE_SEC / 60))
    cat <<EOF >&2
⚠ [Counterpart Doctrine v0.7 — R7] count-fresh marker is stale.
  Marker age: ${AGE_MIN} minutes (>30 min threshold).
  Re-run your count query and update the marker timestamp.
  Live systems (cron, webhooks, concurrent writers) invalidate counts silently.
EOF
    exit 2
  fi

  # Marker present, fresh → allow
  exit 0
fi

# No marker → block with guidance
OP="UPDATE"
[[ "$IS_BULK_DELETE" -eq 1 ]] && OP="DELETE"

cat <<EOF >&2
⚠ [Counterpart Doctrine v0.7 — R7] Bulk $OP without fresh count probe marker.

  R7 amendment v0.7: For bulk DELETE/UPDATE on a live system, re-run the
  count query immediately before the mutation. Counts older than ~30 minutes
  are stale (cron jobs, webhooks, concurrent writers).

  To proceed, add a count-fresh marker to your SQL:
    -- count-fresh:$(date "+%Y%m%d-%H%M")
    $OP FROM ... WHERE ...

  The marker certifies you ran the count probe within the last 30 minutes.
  The first probe scopes the work; the second probe (this one) is the gate.

  Empirical foundation: 2026-05-12 rembrandt ADR-0060 + 2026-05-16 emargement
  drift (351→381 between probes) + 2026-05-14 drift bulk reprise.
EOF

exit 2
