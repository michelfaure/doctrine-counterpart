#!/usr/bin/env bash
# Hook: PreToolUse, matcher: Bash
# Rejects a commit containing an explicit workaround marker without explicit assumption.
# Bypass: add [workaround-assumed] to the commit message.
#
# v0.3 reformulation: pattern narrowed to actual workaround vocabulary.
# v0.2 included "fix" and "temp" — empirically too broad (60% false positives
# on conventional-commits `fix:` prefix and template/tempdir collisions).
# Test against the author's last 50 commits before promoting to error.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# Only acts on git commit
# Unanchored (2026-07-20): chained `git add … && git commit …` is the agent's
# default form; the anchored ^git commit left this reminder inert on it.
if ! printf '%s' "$COMMAND" | grep -Eq '(^|[;&|[:space:]])git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+commit([[:space:]]|$)'; then
  exit 0
fi

# Explicit bypass
if echo "$COMMAND" | grep -q '\[workaround-assumed\]'; then
  exit 0
fi

# Workaround markers (v0.3 — narrowed, see header)
WORKAROUND_PATTERN='\b(workaround|hack|band-aid|bandaid|tempfix|kludge|quick.fix|quick-fix)\b'
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
