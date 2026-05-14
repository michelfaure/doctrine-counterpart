#!/usr/bin/env bash
# verify-install.sh — Counterpart Doctrine v0.3
#
# Verify that the doctrine is materially installed in the target project.
# Compare source (this repo) against deployed (target project + ~/.claude/).
# Exit 0 = OK, exit 1 = drift detected.
#
# Application of axis 1 (material verification) to the install itself:
# the install.sh `✓` is not a proof; this script produces independent evidence.
#
# Usage: ./verify-install.sh [path/to/project]
#        (if omitted: uses the pwd at invocation time)

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-$(pwd)}"
TARGET="$(cd "$TARGET" && pwd)"

if [[ ! -d "$TARGET" ]]; then
  echo "❌ Target directory does not exist: $TARGET"
  exit 1
fi

echo ""
echo "  Counterpart Doctrine v0.3 — verify install"
echo "  Source : $SOURCE_DIR"
echo "  Target : $TARGET"
echo ""

DRIFTS=0

# --- 1. CLAUDE.md ---
echo "→ CLAUDE.md"
if [[ ! -f "$TARGET/CLAUDE.md" ]]; then
  echo "  ❌ missing"
  DRIFTS=$((DRIFTS + 1))
elif grep -q "Counterpart Doctrine v0.3" "$TARGET/CLAUDE.md"; then
  echo "  ✓ contains v0.3 marker"
elif grep -q "Counterpart Doctrine" "$TARGET/CLAUDE.md"; then
  echo "  ⚠ contains Counterpart marker but not v0.3 (older version, manual merge expected)"
else
  echo "  ⚠ exists but no Counterpart Doctrine marker — manual merge presumed"
fi

# --- 2. Skills ---
echo ""
echo "→ Skills (9 expected in v0.3)"
SOURCE_SKILLS=$(find "$SOURCE_DIR/.claude/skills" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
TARGET_SKILLS=$(find "$TARGET/.claude/skills" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
echo "  source: $SOURCE_SKILLS skills"
echo "  target: $TARGET_SKILLS skills"

for skill_dir in "$SOURCE_DIR/.claude/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  target_skill="$TARGET/.claude/skills/$skill_name/SKILL.md"
  if [[ ! -f "$target_skill" ]]; then
    echo "  ❌ missing skill: $skill_name"
    DRIFTS=$((DRIFTS + 1))
  fi
done

# --- 3. Agent ---
echo ""
echo "→ Agent challenger"
if [[ -f "$TARGET/.claude/agents/agent-challenger.md" ]]; then
  echo "  ✓ installed"
else
  echo "  ❌ missing: .claude/agents/agent-challenger.md"
  DRIFTS=$((DRIFTS + 1))
fi

# --- 4. Hooks ---
echo ""
echo "→ Hooks (4 expected in v0.3)"
EXPECTED_HOOKS=("deploy-safeguard.sh" "secret-scanner.sh" "audit-memory-reminder.sh" "check-workaround-assumed.sh")
HOOKS_DIR_TARGET="$TARGET/.claude/hooks"

for hook in "${EXPECTED_HOOKS[@]}"; do
  if [[ -f "$HOOKS_DIR_TARGET/$hook" ]]; then
    if [[ -x "$HOOKS_DIR_TARGET/$hook" ]]; then
      echo "  ✓ $hook (installed and executable)"
    else
      echo "  ⚠ $hook (installed but NOT executable — run: chmod +x $HOOKS_DIR_TARGET/$hook)"
      DRIFTS=$((DRIFTS + 1))
    fi
  else
    echo "  ⊘ $hook (not installed — hooks were declined at install)"
  fi
done

# Check settings.json hooks section
if [[ -f "$TARGET/.claude/settings.json" ]]; then
  if grep -q '"hooks"' "$TARGET/.claude/settings.json"; then
    echo "  ✓ settings.json references hooks"
  else
    echo "  ⚠ settings.json present but no 'hooks' block — hooks installed but not activated"
  fi
else
  echo "  ⚠ no .claude/settings.json — hooks present but not activated"
fi

# --- 5. doctrine.md (manifesto) ---
echo ""
echo "→ doctrine.md (manifesto)"
if [[ -f "$TARGET/docs/doctrine.md" ]]; then
  if grep -q "Counterpart Doctrine — v0.3" "$TARGET/docs/doctrine.md"; then
    echo "  ✓ v0.3 installed in docs/"
  else
    echo "  ⚠ exists but not v0.3 — older version"
  fi
else
  echo "  ⊘ docs/doctrine.md not installed (optional step)"
fi

# --- 6. Drift between source and target on installed files ---
echo ""
echo "→ Drift check (source vs target on shared files)"
DRIFT_FILES=0
for skill_dir in "$SOURCE_DIR/.claude/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  source_skill="$skill_dir/SKILL.md"
  target_skill="$TARGET/.claude/skills/$skill_name/SKILL.md"
  if [[ -f "$source_skill" && -f "$target_skill" ]]; then
    if ! diff -q "$source_skill" "$target_skill" > /dev/null 2>&1; then
      echo "  ⚠ drift on skill $skill_name (local customisation expected — see README 'Living vs Published')"
      DRIFT_FILES=$((DRIFT_FILES + 1))
    fi
  fi
done

if [[ $DRIFT_FILES -eq 0 ]]; then
  echo "  ✓ no drift on skills (target matches source)"
fi

# --- Verdict ---
echo ""
echo "=================================================="
if [[ $DRIFTS -eq 0 ]]; then
  echo "  ✓ Install OK ($DRIFTS critical drift)"
  echo "  $DRIFT_FILES local customisations on skills (expected if living tier)"
  exit 0
else
  echo "  ❌ Install incomplete ($DRIFTS critical drift detected)"
  echo ""
  echo "  Re-run install:  $SOURCE_DIR/install.sh $TARGET"
  echo "  Or fix manually following the messages above."
  exit 1
fi
