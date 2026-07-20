#!/usr/bin/env bash
# verify-install.sh — Counterpart Doctrine
# Version-agnostic since v0.10: expected version, hook list and skill count are
# DERIVED from the source repo at run time, never hardcoded — a checker that
# carries a stale cache of what it checks is the exact R6 drift it exists to catch.
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

# Derive the expected version markers from the SOURCE (authority), never hardcode.
TOOLKIT_MARKER="$(grep -m1 -oE 'Counterpart Toolkit — v[0-9.]+' "$SOURCE_DIR/CLAUDE.md" 2>/dev/null || echo 'Counterpart Toolkit')"
MANIFESTO_MARKER="$(grep -m1 -oE 'Manifesto v[0-9.]+' "$SOURCE_DIR/manifesto.md" 2>/dev/null || echo 'Manifesto')"

echo ""
echo "  Counterpart Doctrine — verify install (source version: ${TOOLKIT_MARKER#Counterpart Toolkit — })"
echo "  Source : $SOURCE_DIR"
echo "  Target : $TARGET"
echo ""

DRIFTS=0

# --- 1. CLAUDE.md ---
echo "→ CLAUDE.md"
if [[ ! -f "$TARGET/CLAUDE.md" ]]; then
  echo "  ❌ missing"
  DRIFTS=$((DRIFTS + 1))
elif grep -qF "$TOOLKIT_MARKER" "$TARGET/CLAUDE.md"; then
  echo "  ✓ contains current marker ($TOOLKIT_MARKER)"
elif grep -q "Counterpart" "$TARGET/CLAUDE.md"; then
  echo "  ⚠ contains Counterpart marker but not the source version ($TOOLKIT_MARKER) — older install or manual merge"
else
  echo "  ⚠ exists but no Counterpart Doctrine marker — manual merge presumed"
fi

# --- 2. Skills ---
echo ""
echo "→ Skills (expected count derived from source)"
# Skills deliberately not installed by default — the SAME list install.sh reads.
# Without this shared source the two scripts contradicted each other: the
# installer skipped a skill and the verifier still counted it as missing,
# failing every install with exit 1 (caught by CI on its first run, 20/07/2026).
NOT_INSTALLED="$SOURCE_DIR/.claude/skills/.not-installed"
is_exempt() { [[ -f "$NOT_INSTALLED" ]] && grep -qxF "$1" "$NOT_INSTALLED"; }

SOURCE_SKILLS=$(find "$SOURCE_DIR/.claude/skills" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
TARGET_SKILLS=$(find "$TARGET/.claude/skills" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
EXEMPT_COUNT=0
[[ -f "$NOT_INSTALLED" ]] && EXEMPT_COUNT=$(grep -cvE '^\s*(#|$)' "$NOT_INSTALLED" || true)
echo "  source: $SOURCE_SKILLS skills ($EXEMPT_COUNT not installed by default)"
echo "  target: $TARGET_SKILLS skills"

for skill_dir in "$SOURCE_DIR/.claude/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  is_exempt "$skill_name" && { echo "  ⊘ $skill_name (not installed by default)"; continue; }
  target_skill="$TARGET/.claude/skills/$skill_name/SKILL.md"
  if [[ ! -f "$target_skill" ]]; then
    echo "  ❌ missing skill: $skill_name"
    DRIFTS=$((DRIFTS + 1))
  fi
done

# --- 2bis. Frontmatter YAML parse (material check) ---
# A SKILL.md present but with broken frontmatter is not loaded by the official
# Anthropic skills mechanism. The presence check above is not sufficient — the
# frontmatter must parse and expose `name` + `description`. Added v0.7.1 after
# the audit revealed that the existing presence check missed broken YAML.
echo ""
echo "→ Skills frontmatter (yaml.safe_load + required keys)"
if command -v python3 >/dev/null 2>&1 && python3 -c "import yaml" >/dev/null 2>&1; then
  YAML_RC=0
  TARGET_SKILLS_DIR="$TARGET/.claude/skills" python3 <<'PYEOF' || YAML_RC=$?
import yaml, re, os, sys, glob
target_dir = os.environ.get('TARGET_SKILLS_DIR', '')
if not os.path.isdir(target_dir):
    print(f"  ⊘ {target_dir} not found — skipped")
    sys.exit(0)
broken = []
ok_count = 0
for f in sorted(glob.glob(os.path.join(target_dir, '*/SKILL.md'))):
    skill_name = os.path.basename(os.path.dirname(f))
    with open(f) as fh:
        content = fh.read()
    m = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
    if not m:
        broken.append((skill_name, 'no --- delimiters'))
        continue
    try:
        parsed = yaml.safe_load(m.group(1))
        if not isinstance(parsed, dict):
            broken.append((skill_name, f'frontmatter is {type(parsed).__name__}, not dict'))
        elif 'name' not in parsed or 'description' not in parsed:
            broken.append((skill_name, f'missing required keys (has: {list(parsed.keys())})'))
        else:
            ok_count += 1
    except yaml.YAMLError as e:
        broken.append((skill_name, str(e).split('\n')[0][:80]))
for name, err in broken:
    print(f"  ❌ {name}: {err}")
print(f"  ✓ {ok_count} skill(s) parse cleanly" if ok_count else "")
sys.exit(1 if broken else 0)
PYEOF
  if [[ $YAML_RC -ne 0 ]]; then
    DRIFTS=$((DRIFTS + 1))
  fi
else
  echo "  ⊘ python3+PyYAML not available — frontmatter parse skipped (install: pip install pyyaml)"
fi

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
EXPECTED_HOOKS=()
while IFS= read -r h; do EXPECTED_HOOKS+=("$(basename "$h")"); done < <(find "$SOURCE_DIR/.claude/hooks" -maxdepth 1 -name "*.sh" | sort)
echo "→ Hooks (${#EXPECTED_HOOKS[@]} expected — list derived from source)"
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

# --- 5. manifesto.md (long-form theory) ---
echo ""
echo "→ manifesto.md (long-form theory)"
if [[ -f "$TARGET/docs/manifesto.md" ]]; then
  if grep -qF "$MANIFESTO_MARKER" "$TARGET/docs/manifesto.md"; then
    echo "  ✓ current version installed in docs/ ($MANIFESTO_MARKER)"
  else
    echo "  ⚠ exists but not the source version ($MANIFESTO_MARKER) — older copy, re-run install"
  fi
elif [[ -f "$TARGET/docs/doctrine.md" ]]; then
  echo "  ⚠ docs/doctrine.md present (pre-v0.4.1 layout). Renamed to manifesto.md in v0.4.1."
else
  echo "  ⊘ docs/manifesto.md not installed (optional step)"
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
