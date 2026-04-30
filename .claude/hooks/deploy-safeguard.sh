#!/usr/bin/env bash
# Hook: PreToolUse, matcher: Bash
# Bloque tout push vers main si le dernier commit ne contient pas [deploy-ok].
# Force une re-vérification consciente avant déploiement.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# N'agit que sur push vers main / master / production
if [[ ! "$COMMAND" =~ git[[:space:]]+push.*\b(main|master|production|prod)\b ]]; then
  exit 0
fi

# Force-push interdit sans tag explicite supplémentaire
if echo "$COMMAND" | grep -qE '\b(--force|-f)\b' && ! echo "$COMMAND" | grep -q '\[force-ok\]'; then
  cat <<EOF >&2
⚠ [Doctrine Counterpart — axe 4] Force-push vers branche de prod détecté.

  Force-push réécrit l'historique partagé. Pour bypasser :
    - tag "[force-ok]" dans la commande
    - ou utiliser --force-with-lease (plus sûr)
EOF
  exit 2
fi

# Vérifier que le dernier commit contient [deploy-ok]
LAST_MSG=$(git log -1 --pretty=%B 2>/dev/null || echo "")

if [[ ! "$LAST_MSG" =~ \[deploy-ok\] ]]; then
  cat <<EOF >&2
⚠ [Doctrine Counterpart — axe 4] Push vers branche de prod bloqué.

  Le dernier commit ne contient pas [deploy-ok].
  Cela force une re-vérification consciente avant déploiement :
    - build vert ?
    - migration testée ?
    - rollback prévu si échec ?

  Ajouter "[deploy-ok]" au commit message si tu confirmes (git commit --amend
  ou nouveau commit). Tag visible dans git log = traçabilité du go/no-go.
EOF
  exit 2
fi

exit 0
