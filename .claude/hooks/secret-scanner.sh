#!/usr/bin/env bash
# Hook: PreToolUse, matcher: Bash
# Scans staged files for plaintext secrets (API keys, tokens, credentials).
# Bypass: add [secret-ok] to the commit message (use only if confirmed false positive).

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# Only acts on git commit — UNANCHORED: agents emit chained commands
# (`git add -A && git commit …`, `cd X && git commit …`) as their default form;
# an anchored ^git commit left this gate inert on exactly that form
# (caught by an external review, 2026-07-20 — R17: a green test attests only
# what it asserts, and the synthetic tests had only asserted the canonical form).
if ! printf '%s' "$COMMAND" | grep -Eq '(^|[;&|[:space:]])git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+commit([[:space:]]|$)'; then
  exit 0
fi

# Locate the repo the commit targets (git -C <dir> | cd <dir> | PWD) — a chained
# `cd /elsewhere && git commit` must be scanned in /elsewhere, not in $PWD.
DIR=""
if [[ "$COMMAND" =~ git[[:space:]]+-C[[:space:]]+([^[:space:]]+) ]]; then
  DIR="${BASH_REMATCH[1]}"
elif [[ "$COMMAND" =~ cd[[:space:]]+([^[:space:]&;|]+) ]]; then
  DIR="${BASH_REMATCH[1]}"
fi
DIR="${DIR/#\~/$HOME}"
[[ -z "$DIR" ]] && DIR="$PWD"
git -C "$DIR" rev-parse --show-toplevel >/dev/null 2>&1 || exit 0

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
STAGED_FILES=$(git -C "$DIR" diff --cached --name-only 2>/dev/null || echo "")

if [[ -z "$STAGED_FILES" ]]; then
  exit 0
fi

DETECTED=0
DETECTED_DETAILS=""

while IFS= read -r FILE; do
  if [[ -z "$FILE" ]]; then
    continue
  fi

  # Skip binaires et lock files
  if [[ "$FILE" =~ \.(png|jpg|jpeg|gif|pdf|woff|ttf|eot|ico|zip|tar|gz)$ ]]; then
    continue
  fi
  if [[ "$FILE" =~ (package-lock\.json|yarn\.lock|pnpm-lock\.yaml|Cargo\.lock|poetry\.lock)$ ]]; then
    continue
  fi

  # Scan the STAGED content (`git show :file` = the index blob), never the file
  # on disk: what the commit records is the index — a secret staged then cleaned
  # from the working tree would pass a disk grep and land in history anyway
  # (caught by the same external review, 2026-07-20).
  CONTENT="$(git -C "$DIR" show ":$FILE" 2>/dev/null || true)"
  [[ -z "$CONTENT" ]] && continue

  for PATTERN in "${PATTERNS[@]}"; do
    if printf '%s' "$CONTENT" | grep -qE "$PATTERN"; then
      MATCH=$(printf '%s' "$CONTENT" | grep -nE "$PATTERN" | head -1)
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
