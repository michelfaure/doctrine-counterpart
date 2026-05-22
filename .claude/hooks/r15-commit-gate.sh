#!/usr/bin/env bash
# R15 commit gate — PreToolUse on Bash (Counterpart Toolkit v0.7.2)
#
# Purpose
#   V2 of the R15 enforcement, complementing r15-autonomous-counter.sh.
#   The V1 counter writes a stderr warning at count >= THRESHOLD but does not
#   block — autonomous commits past the threshold are still possible. V1 was
#   intentionally a stderr-only nudge, deployed 2026-05-21. V2 closes the
#   loop: any `git commit` at or above the threshold is BLOCKED unless the
#   command carries the literal `[autonomy-ack]` bypass marker.
#
# Wiring (in ~/.claude/settings.json):
#   PreToolUse  matcher "Bash"  →  r15-commit-gate.sh  (alongside
#                                  deploy-safeguard.sh and check-workaround-assumed.sh)
#
# Behavior
#   exit 0   if the command is not `git commit`, OR count < THRESHOLD, OR the
#            bypass marker `[autonomy-ack]` is present, OR the state file
#            does not exist yet (no counter installed).
#   exit 2   if the command IS `git commit`, count >= THRESHOLD, and no
#            bypass marker — Claude Code surfaces the stderr block to user.
#
# Bypass mechanisms (matching deploy-safeguard.sh convention)
#   Trailing comment:    git commit -m "..." # [autonomy-ack]
#   Inline marker:       git commit -m "[autonomy-ack] message"
#   Env override:        R15_THRESHOLD=10 git commit -m "..."  (raises N for one call)
#
# Design rationale
#   The two-hook split keeps single responsibility: the counter increments
#   only (PostToolUse Agent), the reset only happens via UserPromptSubmit,
#   and the gate only blocks at the right tool boundary (PreToolUse Bash on
#   git commit). Three independent hooks. The state file is the only shared
#   contract — JSON, easy to inspect, easy to clear.
#
# Tested matériellement on 2026-05-22 alongside V1.

set -euo pipefail

STATE_FILE="$HOME/.claude/state/r15-autonomous-counter.json"
THRESHOLD="${R15_THRESHOLD:-5}"

payload="$(cat)"
cmd="$(printf '%s' "$payload" | jq -r '.tool_input.command // empty')"

# Empty command (defensive) — not our business
[[ -z "$cmd" ]] && exit 0

# Not a `git commit` invocation — not our business
if ! printf '%s' "$cmd" | grep -qE 'git[[:space:]]+commit([[:space:]]|$)'; then
  exit 0
fi

# Explicit bypass marker present anywhere in the command
if printf '%s' "$cmd" | grep -qF -- '[autonomy-ack]'; then
  exit 0
fi

# Counter state file absent — counter not deployed, do not gate
if [[ ! -f "$STATE_FILE" ]]; then
  exit 0
fi

# Read current count
COUNT=$(python3 -c "
import json, sys
try:
    print(json.load(open('$STATE_FILE')).get('count', 0))
except Exception:
    print(0)
")

# Under threshold — pass through
if [[ "$COUNT" -lt "$THRESHOLD" ]]; then
  exit 0
fi

# At or above threshold — block
{
  echo "BLOCKED: R15 commit gate — $COUNT consecutive Agent invocations without a UserPromptSubmit reset (threshold=$THRESHOLD)."
  echo ""
  echo "Command attempted: $cmd"
  echo ""
  echo "The doctrine (Counterpart Toolkit v0.7.2 R15 V2-gating) blocks autonomous"
  echo "commits past the threshold. Three ways forward:"
  echo ""
  echo "  1. Invoke /falsify-before-fix to challenge the trajectory's hypothesis,"
  echo "     OR /close-session to produce a session log. Either resets the counter"
  echo "     via UserPromptSubmit when you reply."
  echo ""
  echo "  2. If you've reviewed the chain and explicitly take responsibility for"
  echo "     the autonomous trajectory, add '[autonomy-ack]' to the commit command"
  echo "     (trailing comment is the canonical form, matching deploy-safeguard):"
  echo "       git commit -m \"...\" # [autonomy-ack]"
  echo ""
  echo "  3. To raise the threshold for THIS session only (e.g. planned long autonomous"
  echo "     work), export R15_THRESHOLD=10 (or higher) before retrying."
  echo ""
  echo "Counter state: $STATE_FILE"
} >&2

exit 2
