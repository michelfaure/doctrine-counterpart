#!/usr/bin/env bash
# R15 meta-hook — Autonomous-chain counter (Counterpart Toolkit v0.7)
#
# Purpose
#   R15 (added v0.6) enforces commit cadence WITHIN a long autonomous session
#   (one commit per material artifact, no end-of-session batch). R15 amended
#   v0.7 acknowledges that the rule holds when the human invokes triggers and
#   silently fails when autonomy takes over. This hook is the meta-complement:
#   it counts consecutive Agent invocations without a human prompt in between
#   and warns once the threshold is crossed, suggesting a self-critique skill
#   (falsify-before-fix or close-session).
#
# Wiring (in ~/.claude/settings.json):
#   PostToolUse  matcher "Agent"      → r15-autonomous-counter.sh increment
#   UserPromptSubmit (no matcher)     → r15-autonomous-counter.sh reset
#
# Behavior
#   increment  read state, +1, persist; if count >= THRESHOLD warn on stderr.
#              Exit 0 always (PostToolUse runs after the tool — no blocking).
#   reset      set count to 0, persist. Exit 0.
#
# State
#   ~/.claude/state/r15-autonomous-counter.json
#   {
#     "count": <int>,
#     "last_invocation_ts": <iso8601>,
#     "last_reset_ts": <iso8601>,
#     "threshold_warnings_issued": <int>
#   }
#
# Tested matériellement on 2026-05-21 (M7 baseline showed 4 runs > 5 over 30d
# on Rembrandt, longest = 92 — the empirical evidence that justified this hook).

set -euo pipefail

STATE_DIR="$HOME/.claude/state"
STATE_FILE="$STATE_DIR/r15-autonomous-counter.json"
THRESHOLD="${R15_THRESHOLD:-5}"

mkdir -p "$STATE_DIR"

mode="${1:-increment}"

case "$mode" in
  increment)
    python3 - <<PYEOF
import json, os, sys, datetime
state_file = "$STATE_FILE"
threshold = $THRESHOLD

now = datetime.datetime.now().isoformat(timespec='seconds')
if os.path.exists(state_file):
    try:
        with open(state_file) as f:
            state = json.load(f)
    except Exception:
        state = {}
else:
    state = {}

count = int(state.get("count", 0)) + 1
state["count"] = count
state["last_invocation_ts"] = now
state.setdefault("threshold_warnings_issued", 0)

if count >= threshold:
    state["threshold_warnings_issued"] = state.get("threshold_warnings_issued", 0) + 1
    msg_block = f"""[R15 meta-hook] AUTONOMY THRESHOLD CROSSED — {count} consecutive Agent invocations without a UserPromptSubmit reset.

R15 (Counterpart Toolkit v0.7) requires a self-critique here:
  → Invoke the /falsify-before-fix skill to challenge the trajectory's hypothesis
  → OR invoke /close-session to write a session log capturing what was decided

Continuing past {threshold} autonomous invocations without one of these is a
silent R15 violation. The threshold counter persists across tool calls until
the next UserPromptSubmit resets it.

State: {state_file}
"""
    print(msg_block, file=sys.stderr)

with open(state_file, "w") as f:
    json.dump(state, f, indent=2)
PYEOF
    ;;

  reset)
    python3 - <<PYEOF
import json, os, datetime
state_file = "$STATE_FILE"

now = datetime.datetime.now().isoformat(timespec='seconds')
if os.path.exists(state_file):
    try:
        with open(state_file) as f:
            state = json.load(f)
    except Exception:
        state = {}
else:
    state = {}

# Preserve cumulative counters across resets, only reset the rolling count.
prev_count = state.get("count", 0)
state["count"] = 0
state["last_reset_ts"] = now
state["last_chain_length"] = prev_count
state.setdefault("total_resets", 0)
state["total_resets"] += 1

with open(state_file, "w") as f:
    json.dump(state, f, indent=2)
PYEOF
    ;;

  status)
    # Manual debug / introspection mode (not wired in settings.json by default)
    if [[ -f "$STATE_FILE" ]]; then
      cat "$STATE_FILE"
    else
      echo '{"count": 0, "note": "state file not yet created"}'
    fi
    ;;

  *)
    echo "Usage: r15-autonomous-counter.sh {increment|reset|status}" >&2
    exit 1
    ;;
esac

exit 0
