#!/usr/bin/env bash
# Hook: PreToolUse, matcher: Bash
# Rejects a commit containing a workaround marker without explicit assumption.
# Bypass: add [workaround-assumed] to the commit message.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# Only acts on git commit
if [[ ! "$COMMAND" =~ ^git[[:space:]]+commit ]]; then
  exit 0
fi

# Explicit bypass
if echo "$COMMAND" | grep -q '\[workaround-assumed\]'; then
  exit 0
fi

# Workaround markers
WORKAROUND_PATTERN='\b(fix|hack|workaround|quick fix|quick-fix|band-aid|bandaid|temp|tempfix|kludge)\b'
ASSUMPTION_PATTERN='(workaround|temporary|to investigate|TODO root cause|TODO ROOT|cf\.? ADR|see ADR|tech debt|tech-debt)'

if echo "$COMMAND" | grep -qiE "$WORKAROUND_PATTERN"; then
  if ! echo "$COMMAND" | grep -qiE "$ASSUMPTION_PATTERN"; then
    cat <<EOF >&2
⚠ [Counterpart Doctrine — axis 5] Commit message contains a workaround marker
  (fix/hack/workaround/...) without explicit assumption.

  Add to the message:
    - "workaround:", "TODO root cause:", "cf. ADR-NNNN", or
    - tag "[workaround-assumed]" to bypass this hook

  Why: a silent workaround returns wearing a different mask in 6 months.
  An assumed workaround remains auditable.
EOF
    exit 2  # Code 2 = block, message shown to Claude
  fi
fi

exit 0
