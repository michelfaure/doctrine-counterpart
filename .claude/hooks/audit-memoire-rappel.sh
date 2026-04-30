#!/usr/bin/env bash
# Hook: SessionStart
# Rappel automatique tous les 90 jours pour relancer l'audit trimestriel de la mémoire.
# Conforme axe 7 — auditabilité long terme.

set -euo pipefail

MARKER_FILE="$HOME/.claude/doctrine-counterpart-audit-last"
NOW=$(date +%s)
THREE_MONTHS_SECONDS=$((90 * 24 * 3600))

if [[ -f "$MARKER_FILE" ]]; then
  LAST=$(cat "$MARKER_FILE" 2>/dev/null || echo 0)
else
  LAST=0
fi

ELAPSED=$((NOW - LAST))

if [[ $ELAPSED -gt $THREE_MONTHS_SECONDS ]]; then
  DAYS=$((ELAPSED / 86400))
  cat <<EOF >&2

📅 [Doctrine Counterpart — axe 7 / auditabilité long terme]

Dernier audit trimestriel mémoire : il y a $DAYS jours (seuil : 90).

La mémoire qui ne s'audite pas pourrit silencieusement. Plan d'audit suggéré (1 h) :
  1. Relire MEMORY.md / index mémoire ligne à ligne
  2. Pour chaque entrée : "est-ce toujours vrai ?" → garder / requalifier / supprimer
  3. Vérifier les sondes associées aux drifts documentés (sont-ils encore actifs ?)
  4. Auditer les ADRs > 12 mois : encore valide / périmé / contredit
  5. Mise à jour MEMORY.md avec retraits et requalifications

Pour marquer l'audit comme fait :
  date +%s > $MARKER_FILE

Pour reporter (si vraiment pas dispo, max +30j) :
  echo \$(( \$(date +%s) - 60*24*3600 )) > $MARKER_FILE  # repousse à 30j

EOF
fi

exit 0
