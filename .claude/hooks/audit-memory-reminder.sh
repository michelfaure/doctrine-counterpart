#!/usr/bin/env bash
# Hook: SessionStart
# Automatic reminder every 90 days to run the quarterly memory audit.
# Conforms to axis 7 — long-term auditability.

set -euo pipefail

MARKER_FILE="$HOME/.claude/doctrine-counterpart-audit-last"
NOW=$(date +%s)
THREE_MONTHS_SECONDS=$((90 * 24 * 3600))

if [[ -f "$MARKER_FILE" ]]; then
  LAST=$(cat "$MARKER_FILE" 2>/dev/null || echo 0)
else
  LAST=0
fi

ELAPSED=$((NOW - LAST))

if [[ $ELAPSED -gt $THREE_MONTHS_SECONDS ]]; then
  DAYS=$((ELAPSED / 86400))
  cat <<EOF >&2

📅 [Counterpart Doctrine — axis 7 / long-term auditability]

Last quarterly memory audit: $DAYS days ago (threshold: 90).

Memory that isn't audited rots silently. Suggested audit plan (1 h):
  1. Re-read MEMORY.md / memory index line by line
  2. For each entry: "is this still true?" → keep / requalify / delete
  3. Verify probes associated with documented drifts (are they still active?)
  4. Audit ADRs > 12 months: still valid / obsolete / contradicted
  5. Update MEMORY.md with removals and requalifications

To mark the audit as done:
  date +%s > $MARKER_FILE

To postpone (if really unavailable, max +30 days):
  echo \$(( \$(date +%s) - 60*24*3600 )) > $MARKER_FILE  # pushes to 30 days

EOF
fi

exit 0
