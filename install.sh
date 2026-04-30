#!/usr/bin/env bash
# Installation interactive de la Doctrine Counterpart dans un projet cible.
# Usage : ./install.sh [chemin/vers/projet]
#         (si non précisé : utilise le pwd au moment de l'invocation)

set -euo pipefail

# Détection du répertoire source (où se trouve ce script)
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cible
TARGET="${1:-$(pwd)}"
TARGET="$(cd "$TARGET" && pwd)"

echo ""
echo "=================================================="
echo "  Doctrine Counterpart v0.2 — installation"
echo "=================================================="
echo ""
echo "Source : $SOURCE_DIR"
echo "Cible  : $TARGET"
echo ""

if [[ ! -d "$TARGET" ]]; then
  echo "❌ Répertoire cible n'existe pas : $TARGET"
  exit 1
fi

# --- 1. CLAUDE.md ---
echo "→ Étape 1/5 : CLAUDE.md (règles opérantes)"
if [[ -f "$TARGET/CLAUDE.md" ]]; then
  echo "  Un CLAUDE.md existe déjà dans $TARGET."
  read -r -p "  [m]erge manuel après / [a]ppend doctrine à la fin / [s]kip / [o]verwrite ? [m] " choice
  choice="${choice:-m}"
  case "$choice" in
    a)
      echo "" >> "$TARGET/CLAUDE.md"
      echo "" >> "$TARGET/CLAUDE.md"
      echo "<!-- ===== Doctrine Counterpart v0.2 (append) ===== -->" >> "$TARGET/CLAUDE.md"
      cat "$SOURCE_DIR/CLAUDE.md" >> "$TARGET/CLAUDE.md"
      echo "  ✓ Doctrine ajoutée à la fin de CLAUDE.md existant"
      ;;
    o)
      cp "$SOURCE_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
      echo "  ✓ CLAUDE.md écrasé"
      ;;
    s)
      echo "  ⊘ skip"
      ;;
    *)
      cp "$SOURCE_DIR/CLAUDE.md" "$TARGET/CLAUDE.md.doctrine-counterpart"
      echo "  ✓ Posé à côté : $TARGET/CLAUDE.md.doctrine-counterpart (à fusionner manuellement)"
      ;;
  esac
else
  cp "$SOURCE_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
  echo "  ✓ CLAUDE.md installé"
fi

# --- 2. .claude/ (skills + agents) ---
echo ""
echo "→ Étape 2/5 : .claude/skills + .claude/agents"
mkdir -p "$TARGET/.claude/skills"
mkdir -p "$TARGET/.claude/agents"

# Skills
for skill_dir in "$SOURCE_DIR/.claude/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  if [[ -d "$TARGET/.claude/skills/$skill_name" ]]; then
    echo "  ⊘ skip $skill_name (existe déjà)"
  else
    cp -r "$skill_dir" "$TARGET/.claude/skills/"
    echo "  ✓ skill $skill_name installé"
  fi
done

# Agents
for agent_file in "$SOURCE_DIR/.claude/agents"/*.md; do
  agent_name=$(basename "$agent_file")
  if [[ -f "$TARGET/.claude/agents/$agent_name" ]]; then
    echo "  ⊘ skip agent $agent_name (existe déjà)"
  else
    cp "$agent_file" "$TARGET/.claude/agents/"
    echo "  ✓ agent $agent_name installé"
  fi
done

# --- 3. doctrine.md (manifeste lisible) ---
echo ""
echo "→ Étape 3/5 : doctrine.md (manifeste, lecture humaine)"
read -r -p "  Copier doctrine.md dans $TARGET/docs/doctrine.md ? [Y/n] " choice
choice="${choice:-Y}"
if [[ "$choice" =~ ^[Yy]$ ]]; then
  mkdir -p "$TARGET/docs"
  cp "$SOURCE_DIR/doctrine.md" "$TARGET/docs/doctrine.md"
  echo "  ✓ doctrine.md placé dans docs/"
else
  echo "  ⊘ skip"
fi

# --- 4. Hooks (optionnels) ---
echo ""
echo "→ Étape 4/5 : Hooks (enforcement matériel — optionnel mais recommandé)"
echo "  Les hooks bloquent commit/push si invariants violés. Bypass explicite documenté."
echo "  Liste : check-palliatif-assumed, deploy-safeguard, secret-scanner, audit-memoire-rappel"
read -r -p "  Activer les hooks ? [y/N] " choice
choice="${choice:-N}"
if [[ "$choice" =~ ^[Yy]$ ]]; then
  mkdir -p "$TARGET/.claude/hooks"

  # Copier les scripts
  for hook_file in "$SOURCE_DIR/.claude/hooks"/*.sh; do
    hook_name=$(basename "$hook_file")
    cp "$hook_file" "$TARGET/.claude/hooks/$hook_name"
    chmod +x "$TARGET/.claude/hooks/$hook_name"
    echo "  ✓ hook $hook_name installé et rendu exécutable"
  done

  # Settings.json
  if [[ -f "$TARGET/.claude/settings.json" ]]; then
    echo "  ⚠ Un .claude/settings.json existe déjà."
    echo "    Le template Doctrine est posé à côté : .claude/settings.json.doctrine-counterpart"
    echo "    À fusionner manuellement (le bloc 'hooks' notamment)."
    cp "$SOURCE_DIR/.claude/settings.json.template" "$TARGET/.claude/settings.json.doctrine-counterpart"
  else
    cp "$SOURCE_DIR/.claude/settings.json.template" "$TARGET/.claude/settings.json"
    echo "  ✓ settings.json créé avec hooks activés"
  fi

  # Vérification jq disponible
  if ! command -v jq >/dev/null 2>&1; then
    echo ""
    echo "  ⚠ 'jq' n'est pas installé sur ce système. Les hooks en ont besoin."
    echo "    macOS : brew install jq"
    echo "    Linux : sudo apt install jq  /  sudo dnf install jq"
  fi
else
  echo "  ⊘ Hooks non activés (peuvent être activés plus tard via settings.json.template)"
fi

# --- 5. Récap ---
echo ""
echo "=================================================="
echo "  Installation terminée"
echo "=================================================="
echo ""
echo "Prochaines étapes :"
echo ""
echo "  1. Ouvrir Claude Code dans $TARGET"
echo "  2. Le CLAUDE.md sera lu automatiquement à chaque session"
echo "  3. Les skills s'auto-invoquent sur leurs triggers (cf. description dans frontmatter)"
echo "  4. L'agent challenger s'invoque manuellement :"
echo "     'Lance l'agent-challenger sur cette reco avant de figer.'"
echo ""
echo "  Pour relire le manifeste : $TARGET/docs/doctrine.md"
echo ""
echo "Test demandé (si tu testes pour quelqu'un d'autre) :"
echo "  Après 2-3 semaines d'usage, répondre aux 3 questions du README :"
echo "  (a) qu'as-tu chargé / utilisé ?"
echo "  (b) qu'est-ce qui a changé concrètement ?"
echo "  (c) quels axes peux-tu nommer sans relire ?"
echo ""
