#!/usr/bin/env bash
# Hook: PreToolUse, matcher: Bash
# Scans staged files for plaintext secrets (API keys, tokens, credentials).
# Bypass: add [secret-ok] to the commit message (use only if confirmed false positive).

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# Only acts on git commit
if [[ ! "$COMMAND" =~ ^git[[:space:]]+commit ]]; then
  exit 0
fi

# Bypass explicite
if echo "$COMMAND" | grep -q '\[secret-ok\]'; then
  exit 0
fi

# Secret patterns (heuristics — not exhaustive)
declare -a PATTERNS=(
  'sk-[A-Za-z0-9]{20,}'                        # OpenAI / Anthropic
  'sk-ant-[A-Za-z0-9_-]{20,}'                  # Anthropic explicite
  'ghp_[A-Za-z0-9]{36}'                        # GitHub PAT classic
  'github_pat_[A-Za-z0-9_]{82}'                # GitHub PAT fine-grained
  'AKIA[0-9A-Z]{16}'                           # AWS access key
  'aws_secret_access_key.*=.*[A-Za-z0-9/+]{40}'  # AWS secret
  'xoxb-[0-9]+-[0-9]+-[0-9]+-[A-Za-z0-9]+'     # Slack bot token
  'xoxp-[0-9]+-[0-9]+-[0-9]+-[A-Za-z0-9]+'     # Slack user token
  'eyJ[A-Za-z0-9_-]{30,}\.eyJ[A-Za-z0-9_-]{30,}\.'  # JWT (heuristique)
  'service_role.{0,10}eyJ'                     # Supabase service role JWT
  '-----BEGIN[A-Z ]+PRIVATE KEY-----'          # Private keys
  'glpat-[A-Za-z0-9_-]{20}'                    # GitLab PAT
)

# Get staged files
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null || echo "")

if [[ -z "$STAGED_FILES" ]]; then
  exit 0
fi

DETECTED=0
DETECTED_DETAILS=""

while IFS= read -r FILE; do
  if [[ -z "$FILE" ]] || [[ ! -f "$FILE" ]]; then
    continue
  fi

  # Skip binaires et lock files
  if [[ "$FILE" =~ \.(png|jpg|jpeg|gif|pdf|woff|ttf|eot|ico|zip|tar|gz)$ ]]; then
    continue
  fi
  if [[ "$FILE" =~ (package-lock\.json|yarn\.lock|pnpm-lock\.yaml|Cargo\.lock|poetry\.lock)$ ]]; then
    continue
  fi

  for PATTERN in "${PATTERNS[@]}"; do
    if grep -qE "$PATTERN" "$FILE" 2>/dev/null; then
      MATCH=$(grep -nE "$PATTERN" "$FILE" 2>/dev/null | head -1)
      DETECTED=1
      DETECTED_DETAILS+="\n  - $FILE: $MATCH"
    fi
  done
done <<< "$STAGED_FILES"

if [[ $DETECTED -eq 1 ]]; then
  cat <<EOF >&2
⚠ [Counterpart Doctrine — axis 7] Potential secret detected in staged files.

Details:$(echo -e "$DETECTED_DETAILS")

Possible actions:
  1. If real secret: remove from file, move to environment variable,
     then 'git restore --staged <file>' before re-committing
  2. If confirmed false positive: add "[secret-ok]" to the commit message
  3. If test value / fixture: prefix with "test_" or "fake_" to break the pattern

Why: a secret committed even for a few minutes can be indexed by GitHub Search
and exposed. The solo has no PR reviewer to catch the mistake.
EOF
  exit 2
fi

exit 0
