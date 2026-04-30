#!/usr/bin/env bash
# Hook: PreToolUse, matcher: Bash
# Blocks any push to main if the last commit does not contain [deploy-ok].
# Forces conscious re-verification before deployment.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# Only acts on push to main / master / production
if [[ ! "$COMMAND" =~ git[[:space:]]+push.*\b(main|master|production|prod)\b ]]; then
  exit 0
fi

# Force-push forbidden without additional explicit tag
if echo "$COMMAND" | grep -qE '\b(--force|-f)\b' && ! echo "$COMMAND" | grep -q '\[force-ok\]'; then
  cat <<EOF >&2
⚠ [Counterpart Doctrine — axis 4] Force-push to production branch detected.

  Force-push rewrites shared history. To bypass:
    - tag "[force-ok]" in the command
    - or use --force-with-lease (safer)
EOF
  exit 2
fi

# Verify the last commit contains [deploy-ok]
LAST_MSG=$(git log -1 --pretty=%B 2>/dev/null || echo "")

if [[ ! "$LAST_MSG" =~ \[deploy-ok\] ]]; then
  cat <<EOF >&2
⚠ [Counterpart Doctrine — axis 4] Push to production branch blocked.

  The last commit does not contain [deploy-ok].
  This forces conscious re-verification before deployment:
    - build green?
    - migration tested?
    - rollback planned in case of failure?

  Add "[deploy-ok]" to the commit message if you confirm (git commit --amend
  or new commit). Tag visible in git log = traceability of the go/no-go.
EOF
  exit 2
fi

exit 0
