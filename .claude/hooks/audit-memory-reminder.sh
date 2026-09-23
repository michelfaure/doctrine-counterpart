#!/usr/bin/env bash
# Hook: SessionStart
# Automatic reminder every 90 days to run the quarterly falsification audit (R18(c)).
# v0.12: R13's calendar memory audits were retired; the one periodic mechanism
# the norm keeps is R18(c). Same marker file, retargeted message.

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

Last R18(c) falsification audit: $DAYS days ago (threshold: 90).

A corpus that only grows is a whitelist that lengthens until it lies. Audit plan:
  1. Read the practice journal + session logs since the last audit, in full
  2. Per live rule: contradictions (searched explicitly), signs of death,
     confirmations — each dated
  3. Per class recommitted after being named: does a mechanism now forbid it?
  4. Screen each retirement and addition adversarially before deciding
  5. Record births AND deaths in the ledger (mortality metric)

To mark the audit as done:
  date +%s > $MARKER_FILE

To postpone (if really unavailable, max +30 days):
  echo \$(( \$(date +%s) - 60*24*3600 )) > $MARKER_FILE  # pushes to 30 days

EOF
fi

exit 0
