#!/usr/bin/env bash
# Pre-merge code-review reminder — PreToolUse on Bash
# Exit 0 = allow, exit 2 = soft-block (stderr shown to Claude + user).
#
# Rôle : quand une commande de MERGE (`git merge`, `gh pr merge`) est sur le point
# de tourner ET que le diff de la branche courante touche une SURFACE À RISQUE
# (paiement/Stripe, TVA/fiscal, cron, migrations, RLS/policies, auth), rappeler de
# passer `/code-review` d'abord. Bypass : `[review-ok]` (après LECTURE du diff).
#
# v0.10 (17/07/2026) : clause `actions.ts` RETIRÉE du regex (température métier,
# pas nom de fichier — 0/3 morsure sur froid) ; scan de contenu SECURITY DEFINER
# ajouté (clause privilèges R19 : la review lit le code, pas les GRANT par défaut).
#
# Design (challenger 04/07/2026) :
# - Déclenché UNIQUEMENT sur surface à risque → parcimonie (zéro friction sur un
#   merge de doc/copy/fix trivial).
# - Un hook ne PEUT PAS lancer /code-review (slash-command) ; il ne fait que
#   rappeler+soft-block. La revue reste un geste humain/agent.
# - Fail-OPEN : si le repo/diff est indéterminable, on laisse passer (c'est un
#   rappel de qualité, pas un gate de sécurité — ne jamais bloquer le vrai travail
#   sur une confusion du hook).
# Idiome copié sur deploy-safeguard.sh (stdin JSON, token bypass, exit 2).

set -euo pipefail

payload="$(cat)"
cmd="$(printf '%s' "$payload" | jq -r '.tool_input.command // empty')"

[[ -z "$cmd" ]] && exit 0

# Bypass explicite
if printf '%s' "$cmd" | grep -qF -- '[review-ok]'; then
  exit 0
fi

# 1) Est-ce une commande de merge ? (sinon rien à faire)
merge_regex='(git([[:space:]]+-C[[:space:]]+[^[:space:]]+|[[:space:]]+--?[^[:space:]]+)*[[:space:]]+merge([[:space:]]|$))|(gh[[:space:]]+pr[[:space:]]+merge)'
printf '%s' "$cmd" | grep -E -q -e "$merge_regex" || exit 0

# 2) Localiser le repo : `git -C <dir>`, sinon `cd <dir> &&`, sinon $PWD
dir=""
if [[ "$cmd" =~ git[[:space:]]+-C[[:space:]]+([^[:space:]]+) ]]; then
  dir="${BASH_REMATCH[1]}"
elif [[ "$cmd" =~ cd[[:space:]]+([^[:space:]&;|]+) ]]; then
  dir="${BASH_REMATCH[1]}"
fi
dir="${dir/#\~/$HOME}"
[[ -z "$dir" ]] && dir="$PWD"

# Repo git ? sinon fail-open
git -C "$dir" rev-parse --show-toplevel >/dev/null 2>&1 || exit 0

# 3) Branche de base
base=""
for b in main master; do
  if git -C "$dir" show-ref --verify --quiet "refs/heads/$b"; then base="$b"; break; fi
done
[[ -z "$base" ]] && exit 0

# 4) Fichiers que la branche courante ajoute vs base
changed="$(git -C "$dir" diff --name-only "$base"...HEAD 2>/dev/null || true)"
[[ -z "$changed" ]] && exit 0

# 5) Surface à risque ? (température métier — v0.10 : actions.ts retiré, 0/3 froid)
risk_regex='stripe|encaissement|paiement|payment|/api/cron/|supabase/migrations/|(^|/)migrations/|\.sql$|(^|/)rls|_rls|polic(y|ies)|/auth/|auth\.ts|(^|/)lib/auth|fiscal|(^|/)tva|_tva|tva_'
matched="$(printf '%s\n' "$changed" | grep -Ei -e "$risk_regex" || true)"

# 5bis) Clause privilèges R19 (v0.10) : SECURITY DEFINER dans le CONTENU du diff —
# la review lit le code, les GRANT par défaut (EXECUTE=PUBLIC) n'y sont pas.
secdef="$(git -C "$dir" diff "$base"...HEAD 2>/dev/null | grep -ciE 'security[[:space:]]+definer' || true)"

[[ -z "$matched" && "${secdef:-0}" -eq 0 ]] && exit 0

{
  echo "RAPPEL code-review — ce merge touche une surface à RISQUE."
  echo "Commande : $cmd"
  echo ""
  if [[ -n "$matched" ]]; then
    echo "Fichiers concernés (diff $base...HEAD) :"
    printf '%s\n' "$matched" | sed 's/^/  - /'
    echo ""
  fi
  if [[ "${secdef:-0}" -gt 0 ]]; then
    echo "⚠ SECURITY DEFINER détecté dans le diff ($secdef occurrence(s))."
    echo "  Clause privilèges R19 : sonde has_function_privilege('anon'|'authenticated', …)"
    echo "  DANS LE MÊME MESSAGE que le deploy (EXECUTE=PUBLIC par défaut ;"
    echo "  DROP+CREATE re-grante via default privileges même après un REVOKE)."
    echo ""
  fi
  echo "→ Passe '/code-review' sur le diff AVANT de merger."
  echo "→ Une fois relu (ou si tu juges le diff froid), rejoue avec '[review-ok]'."
  echo "   ex: gh pr merge 324 --squash  # [review-ok]"
} >&2
exit 2
