#!/usr/bin/env bash
# Hook: PreToolUse, matcher: Bash
# Scanne les fichiers staged pour secrets en clair (clés API, tokens, credentials).
# Bypass: ajouter [secret-ok] au message de commit (à utiliser uniquement si confirmé faux positif).

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# N'agit que sur git commit
if [[ ! "$COMMAND" =~ ^git[[:space:]]+commit ]]; then
  exit 0
fi

# Bypass explicite
if echo "$COMMAND" | grep -q '\[secret-ok\]'; then
  exit 0
fi

# Patterns de secrets (heuristiques — pas exhaustifs)
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
  '-----BEGIN[A-Z ]+PRIVATE KEY-----'          # Clés privées
  'glpat-[A-Za-z0-9_-]{20}'                    # GitLab PAT
)

# Récupère les fichiers staged
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
⚠ [Doctrine Counterpart — axe 7] Secret potentiel détecté dans les fichiers staged.

Détails :$(echo -e "$DETECTED_DETAILS")

Actions possibles :
  1. Si vrai secret : retirer du fichier, le mettre en variable d'environnement,
     puis 'git restore --staged <fichier>' avant de re-commiter
  2. Si faux positif confirmé : ajouter "[secret-ok]" au commit message
  3. Si valeur de test / fixture : préfixer "test_" ou "fake_" pour casser le pattern

Pourquoi : un secret committé même quelques minutes peut être indexé par GitHub Search
et exposé. Le solo n'a pas de PR reviewer pour rattraper l'erreur.
EOF
  exit 2
fi

exit 0
