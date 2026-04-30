#!/usr/bin/env bash
# Hook: PreToolUse, matcher: Bash
# Refuse un commit qui contient un marqueur de rustine sans assomption explicite.
# Bypass : ajouter [rustine-assumee] au message de commit.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# N'agit que sur git commit
if [[ ! "$COMMAND" =~ ^git[[:space:]]+commit ]]; then
  exit 0
fi

# Bypass explicite
if echo "$COMMAND" | grep -q '\[rustine-assumee\]'; then
  exit 0
fi

# Marqueurs de rustine
RUSTINE_PATTERN='\b(fix|hack|workaround|quick fix|quick-fix|patch rapide|temp|tempfix)\b'
ASSUMPTION_PATTERN='(palliatif|temporaire|à creuser|TODO cause racine|TODO ROOT|cf\.? ADR|see ADR)'

if echo "$COMMAND" | grep -qiE "$RUSTINE_PATTERN"; then
  if ! echo "$COMMAND" | grep -qiE "$ASSUMPTION_PATTERN"; then
    cat <<EOF >&2
⚠ [Doctrine Counterpart — axe 5] Commit message contient un marqueur de rustine
  (fix/hack/workaround/...) sans assomption explicite.

  Ajouter au message :
    - "palliatif:", "TODO cause racine:", "cf. ADR-NNNN", ou
    - tag "[rustine-assumee]" pour bypasser ce hook

  Pourquoi : un palliatif silencieux revient avec un visage différent dans 6 mois.
  Un palliatif assumé reste auditable.
EOF
    exit 2  # Code 2 = block, message affiché à Claude
  fi
fi

exit 0
