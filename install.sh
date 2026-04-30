#!/usr/bin/env bash
# Interactive install of the Counterpart Doctrine into a target project.
# Usage: ./install.sh [path/to/project]
#        (if omitted: uses the pwd at invocation time)

set -euo pipefail

# Detect source directory (where this script lives)
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target
TARGET="${1:-$(pwd)}"
TARGET="$(cd "$TARGET" && pwd)"

echo ""
echo "=================================================="
echo "  Counterpart Doctrine v0.2 — install"
echo "=================================================="
echo ""
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET"
echo ""

if [[ ! -d "$TARGET" ]]; then
  echo "❌ Target directory does not exist: $TARGET"
  exit 1
fi

# --- 1. CLAUDE.md ---
echo "→ Step 1/5: CLAUDE.md (operational rules)"
if [[ -f "$TARGET/CLAUDE.md" ]]; then
  echo "  A CLAUDE.md already exists in $TARGET."
  read -r -p "  [m]anual merge after / [a]ppend doctrine to end / [s]kip / [o]verwrite? [m] " choice
  choice="${choice:-m}"
  case "$choice" in
    a)
      echo "" >> "$TARGET/CLAUDE.md"
      echo "" >> "$TARGET/CLAUDE.md"
      echo "<!-- ===== Counterpart Doctrine v0.2 (append) ===== -->" >> "$TARGET/CLAUDE.md"
      cat "$SOURCE_DIR/CLAUDE.md" >> "$TARGET/CLAUDE.md"
      echo "  ✓ Doctrine appended to existing CLAUDE.md"
      ;;
    o)
      cp "$SOURCE_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
      echo "  ✓ CLAUDE.md overwritten"
      ;;
    s)
      echo "  ⊘ skip"
      ;;
    *)
      cp "$SOURCE_DIR/CLAUDE.md" "$TARGET/CLAUDE.md.doctrine-counterpart"
      echo "  ✓ Placed alongside: $TARGET/CLAUDE.md.doctrine-counterpart (merge manually)"
      ;;
  esac
else
  cp "$SOURCE_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
  echo "  ✓ CLAUDE.md installed"
fi

# --- 2. .claude/ (skills + agents) ---
echo ""
echo "→ Step 2/5: .claude/skills + .claude/agents"
mkdir -p "$TARGET/.claude/skills"
mkdir -p "$TARGET/.claude/agents"

# Skills
for skill_dir in "$SOURCE_DIR/.claude/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  if [[ -d "$TARGET/.claude/skills/$skill_name" ]]; then
    echo "  ⊘ skip $skill_name (already exists)"
  else
    cp -r "$skill_dir" "$TARGET/.claude/skills/"
    echo "  ✓ skill $skill_name installed"
  fi
done

# Agents
for agent_file in "$SOURCE_DIR/.claude/agents"/*.md; do
  agent_name=$(basename "$agent_file")
  if [[ -f "$TARGET/.claude/agents/$agent_name" ]]; then
    echo "  ⊘ skip agent $agent_name (already exists)"
  else
    cp "$agent_file" "$TARGET/.claude/agents/"
    echo "  ✓ agent $agent_name installed"
  fi
done

# --- 3. doctrine.md (readable manifesto) ---
echo ""
echo "→ Step 3/5: doctrine.md (manifesto, human reading)"
read -r -p "  Copy doctrine.md to $TARGET/docs/doctrine.md? [Y/n] " choice
choice="${choice:-Y}"
if [[ "$choice" =~ ^[Yy]$ ]]; then
  mkdir -p "$TARGET/docs"
  cp "$SOURCE_DIR/doctrine.md" "$TARGET/docs/doctrine.md"
  echo "  ✓ doctrine.md placed in docs/"
else
  echo "  ⊘ skip"
fi

# --- 4. Hooks (optional) ---
echo ""
echo "→ Step 4/5: Hooks (material enforcement — optional but recommended)"
echo "  Hooks block commit/push if invariants are violated. Explicit bypass documented."
echo "  List: check-workaround-assumed, deploy-safeguard, secret-scanner, audit-memory-reminder"
read -r -p "  Activate hooks? [y/N] " choice
choice="${choice:-N}"
if [[ "$choice" =~ ^[Yy]$ ]]; then
  mkdir -p "$TARGET/.claude/hooks"

  # Copy scripts
  for hook_file in "$SOURCE_DIR/.claude/hooks"/*.sh; do
    hook_name=$(basename "$hook_file")
    cp "$hook_file" "$TARGET/.claude/hooks/$hook_name"
    chmod +x "$TARGET/.claude/hooks/$hook_name"
    echo "  ✓ hook $hook_name installed and made executable"
  done

  # Settings.json
  if [[ -f "$TARGET/.claude/settings.json" ]]; then
    echo "  ⚠ A .claude/settings.json already exists."
    echo "    Doctrine template placed alongside: .claude/settings.json.doctrine-counterpart"
    echo "    Merge manually (the 'hooks' block in particular)."
    cp "$SOURCE_DIR/.claude/settings.json.template" "$TARGET/.claude/settings.json.doctrine-counterpart"
  else
    cp "$SOURCE_DIR/.claude/settings.json.template" "$TARGET/.claude/settings.json"
    echo "  ✓ settings.json created with hooks activated"
  fi

  # Check jq available
  if ! command -v jq >/dev/null 2>&1; then
    echo ""
    echo "  ⚠ 'jq' is not installed on this system. Hooks need it."
    echo "    macOS: brew install jq"
    echo "    Linux: sudo apt install jq  /  sudo dnf install jq"
  fi
else
  echo "  ⊘ Hooks not activated (can be activated later via settings.json.template)"
fi

# --- 5. Recap ---
echo ""
echo "=================================================="
echo "  Install complete"
echo "=================================================="
echo ""
echo "Next steps:"
echo ""
echo "  1. Open Claude Code in $TARGET"
echo "  2. CLAUDE.md will be read automatically each session"
echo "  3. Skills auto-invoke on triggers (see description in frontmatter)"
echo "  4. The challenger agent invokes manually:"
echo "     'Run agent-challenger on this rec before locking.'"
echo ""
echo "  To reread the manifesto: $TARGET/docs/doctrine.md"
echo ""
echo "Test request (if testing for someone else):"
echo "  After 2-3 weeks of use, answer the 3 questions in the README:"
echo "  (a) what did you load / use?"
echo "  (b) what concretely changed?"
echo "  (c) which axes can you name without rereading?"
echo ""
