#!/usr/bin/env bash
# Install the Counterpart Doctrine into a target project.
#
# Usage:
#   ./install.sh                          # interactive, target = pwd
#   ./install.sh [path/to/project]        # interactive, target = path
#   ./install.sh --yes                    # non-interactive (defaults Y), target = pwd
#   ./install.sh --yes [path/to/project]  # non-interactive, target = path
#
# One-line install from a clone (non-interactive):
#   git clone https://github.com/michelfaure/doctrine-counterpart.git && cd doctrine-counterpart && ./install.sh --yes /path/to/your/project

set -euo pipefail

# Parse --yes / -y flag (non-interactive, all prompts default to Y)
AUTO_YES=0
ARGS=()
for arg in "$@"; do
  case "$arg" in
    --yes|-y) AUTO_YES=1 ;;
    *) ARGS+=("$arg") ;;
  esac
done

# Helper: prompt, or return Y if --yes
ask() {
  if [[ "$AUTO_YES" -eq 1 ]]; then
    echo "Y"
  else
    local reply
    read -r -p "$1" reply
    echo "${reply:-Y}"
  fi
}

# Detect source directory (where this script lives)
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target (first non-flag arg, or pwd)
TARGET="${ARGS[0]:-$(pwd)}"
TARGET="$(cd "$TARGET" && pwd)"

echo ""
echo "=================================================="
echo "  Counterpart Doctrine v0.10 — install (toolkit + manifesto)"
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
echo "→ Step 1/6: CLAUDE.md (toolkit — 19 operational rules)"
if [[ -f "$TARGET/CLAUDE.md" ]]; then
  echo "  A CLAUDE.md already exists in $TARGET."
  if [[ "$AUTO_YES" -eq 1 ]]; then
    choice="m"  # safe default: place alongside, manual merge
  else
    read -r -p "  [m]anual merge after / [a]ppend doctrine to end / [s]kip / [o]verwrite? [m] " choice
    choice="${choice:-m}"
  fi
  case "$choice" in
    a)
      echo "" >> "$TARGET/CLAUDE.md"
      echo "" >> "$TARGET/CLAUDE.md"
      echo "<!-- ===== Counterpart Toolkit v0.10 (append) ===== -->" >> "$TARGET/CLAUDE.md"
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
echo "→ Step 2/6: .claude/skills + .claude/agents"
mkdir -p "$TARGET/.claude/skills"
mkdir -p "$TARGET/.claude/agents"

# Skills
for skill_dir in "$SOURCE_DIR/.claude/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  target_skill_dir="$TARGET/.claude/skills/$skill_name"
  if [[ -d "$target_skill_dir" ]]; then
    echo "  ⊘ skip $skill_name (already exists)"
  else
    # Copy the entire skill directory (not its contents).
    # Trailing slash on source matters: keep it stripped so cp -r creates the subdir.
    cp -r "${skill_dir%/}" "$target_skill_dir"
    if [[ -f "$target_skill_dir/SKILL.md" ]]; then
      echo "  ✓ skill $skill_name installed"
    else
      echo "  ❌ skill $skill_name FAILED (SKILL.md missing in target)"
    fi
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

# --- 3. manifesto.md (readable long-form theory) ---
echo ""
echo "→ Step 3/6: manifesto.md (long-form theory, OPTIONAL human reading)"
choice=$(ask "  Copy manifesto.md to $TARGET/docs/manifesto.md? [Y/n] ")
if [[ "$choice" =~ ^[Yy]$ ]]; then
  mkdir -p "$TARGET/docs"
  cp "$SOURCE_DIR/manifesto.md" "$TARGET/docs/manifesto.md"
  echo "  ✓ manifesto.md placed in docs/"
else
  echo "  ⊘ skip"
fi

# --- 4. Hooks (recommended by default since v0.3) ---
echo ""
echo "→ Step 4/6: Hooks (material enforcement — recommended)"
echo "  Hooks block/warn if invariants are violated. Explicit bypass documented per hook:"
echo "    - deploy-safeguard           : pushes to main require [deploy-ok]"
echo "    - secret-scanner             : commits with literal secrets blocked"
echo "    - audit-memory-reminder      : quarterly memory audit reminder (SessionStart, non-blocking)"
echo "    - check-workaround-assumed   : workaround commits without [workaround-assumed] tag blocked"
echo "    - r15-autonomous-counter     : counts autonomous agent chains (R15)"
echo "    - r15-commit-gate            : blocks git commit past autonomy threshold, bypass [autonomy-ack]"
echo "    - pre-merge-review-reminder  : R19 review-gate on business-hot merges, bypass [review-ok]"
echo "    - memory-write-guard         : R18 MEMORY.md format guard at write-time"
echo "    - pre-bulk-mutation-count-staleness : R7 bulk re-count gate, bypass -- count-fresh:..."
echo ""
echo "  Default in v0.10 (unchanged since v0.3): Y. The doctrine's value relies on these guards."
echo "  Decline only if you have an incompatible setup."
choice=$(ask "  Activate hooks? [Y/n] ")
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

# --- 5. Verify install ---
echo ""
echo "→ Step 5/6: Verify install (axis 1 — material verification)"
if [[ -x "$SOURCE_DIR/verify-install.sh" ]]; then
  "$SOURCE_DIR/verify-install.sh" "$TARGET"
else
  echo "  ⊘ verify-install.sh not found or not executable. Skipped."
fi

# --- 6. Recap ---
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
echo "  To reread the manifesto: $TARGET/docs/manifesto.md"
echo "  To re-verify install:    $SOURCE_DIR/verify-install.sh $TARGET"
echo ""
echo "Test request (if testing for someone else):"
echo "  After 2-3 weeks of use, answer the 4 questions in the README:"
echo "  (a) what did you load / use?"
echo "  (b) what concretely changed?"
echo "  (c) which of the 19 rules can you name without rereading?"
echo "  (d) which rule is missing for your stack? (next-cycle candidates)"
echo ""
