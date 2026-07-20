#!/usr/bin/env bash
# tests/hooks/mutate.sh — proves the hook suite BITES.
#
# R17's corollary, applied to the enforcement layer's own net: a green suite
# attests only what it asserts. The external reviewer demonstrated the gap by
# neutralising two hooks entirely — the suite stayed green, because it only
# covered the two hooks that round of review had touched.
#
# What this does:
#   1. GENERIC — replace each gating hook with a stub that always exits 0, run
#      the suite, and require it to redden. A hook whose neutralisation leaves
#      the suite green has no blocking assertion, i.e. is not covered.
#   2. HISTORICAL — re-introduce the exact defects shipped on 2026-07-19/20 and
#      require the suite to redden. Guards against a silent regression to a
#      state that already reached production once.
#
# Exemptions (non-gating by construction, no block/pass pair to assert):
#   r15-autonomous-counter.sh (bookkeeping), audit-memory-reminder.sh (reminder).
#
# Usage: ./tests/hooks/mutate.sh

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS="$(cd "$HERE/../../.claude/hooks" && pwd)"
BACKUP="$(mktemp -d)"; trap 'restore_all; rm -rf "$BACKUP"' EXIT

EXEMPT="r15-autonomous-counter.sh audit-memory-reminder.sh"
OK=0; BAD=0

restore_all() { for f in "$BACKUP"/*.sh; do [[ -e "$f" ]] && cp "$f" "$HOOKS/$(basename "$f")"; done; }
save()   { cp "$HOOKS/$1" "$BACKUP/$1"; }
revert() { cp "$BACKUP/$1" "$HOOKS/$1"; }

suite_reddens() { ! "$HERE/run.sh" >/dev/null 2>&1; }

verdict() { # <label> <reddened:0|1>
  if [[ "$2" == "1" ]]; then printf '  ok   %-52s suite reddens\n' "$1"; OK=$((OK+1))
  else printf '  MISS %-52s suite STAYS GREEN → uncovered\n' "$1"; BAD=$((BAD+1)); fi
}

echo "== baseline =="
if "$HERE/run.sh" >/dev/null 2>&1; then echo "  ok   suite green before mutating"
else echo "  ABORT: suite is already red — fix it before mutation-testing."; exit 1; fi

echo "== generic: neutralise each gating hook =="
for path in "$HOOKS"/*.sh; do
  h="$(basename "$path")"
  case " $EXEMPT " in *" $h "*) printf '  --   %-52s exempt (non-gating)\n' "$h"; continue ;; esac
  save "$h"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$HOOKS/$h"; chmod +x "$HOOKS/$h"
  if suite_reddens; then verdict "$h neutralised" 1; else verdict "$h neutralised" 0; fi
  revert "$h"
done

echo "== historical: defects that actually shipped =="
mutate_file() { # <hook> <python-replace-old> <python-replace-new>
  save "$1"
  OLD="$2" NEW="$3" python3 - "$HOOKS/$1" <<'PY'
import os,sys
p=sys.argv[1]; s=open(p).read(); old=os.environ["OLD"]; new=os.environ["NEW"]
if old not in s: sys.exit(9)
open(p,"w").write(s.replace(old,new))
PY
}

# 1. Anchored trigger — left the scanner inert on the agent's dominant form.
if mutate_file secret-scanner.sh \
  'if ! printf '"'"'%s'"'"' "$COMMAND" | grep -Eq '"'"'(^|[;&|[:space:]])git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+commit([[:space:]]|$)'"'"'; then' \
  'if [[ ! "$COMMAND" =~ ^git[[:space:]]+commit ]]; then'; then
  if suite_reddens; then verdict "anchored ^git commit (19/07)" 1; else verdict "anchored ^git commit (19/07)" 0; fi
else printf '  SKIP anchored trigger (pattern not found — hook rewritten?)\n'; fi
revert secret-scanner.sh

# 2. grep without `--` — the PEM pattern silently never matched.
if mutate_file secret-scanner.sh 'grep -qE -- "$PATTERN"' 'grep -qE "$PATTERN"'; then
  if suite_reddens; then verdict "grep without -- (PEM dead)" 1; else verdict "grep without -- (PEM dead)" 0; fi
else printf '  SKIP grep -- (pattern not found)\n'; fi
revert secret-scanner.sh

# 3. Disk scan instead of index — a secret staged then cleaned slipped through.
if mutate_file secret-scanner.sh 'CONTENT="$(git -C "$DIR" show ":$FILE" 2>/dev/null || true)"' 'CONTENT="$(cat "$FILE" 2>/dev/null || true)"'; then
  if suite_reddens; then verdict "disk scan instead of index (19/07)" 1; else verdict "disk scan instead of index (19/07)" 0; fi
else printf '  SKIP disk scan (pattern not found)\n'; fi
revert secret-scanner.sh

# 4. Unanchored `cd` + fail-open — the bypass the previous fix introduced.
#    NOTE: either defect alone is closed by the other (defence in depth), so the
#    historical state requires BOTH — which is exactly why only a mutation back
#    to the real shipped state attests coverage.
save secret-scanner.sh
OLD1='elif [[ "$COMMAND" =~ $CD_AT_BOUNDARY ]]; then
  DIR="${BASH_REMATCH[2]}"'
NEW1='elif [[ "$COMMAND" =~ cd[[:space:]]+([^[:space:]&;|]+) ]]; then
  DIR="${BASH_REMATCH[1]}"'
OLD2='if [[ -z "$DIR" ]] || ! git -C "$DIR" rev-parse --show-toplevel >/dev/null 2>&1; then
  DIR="$PWD"
fi'
NEW2='[[ -z "$DIR" ]] && DIR="$PWD"'
OLD1="$OLD1" NEW1="$NEW1" OLD2="$OLD2" NEW2="$NEW2" python3 - "$HOOKS/secret-scanner.sh" <<'PY'
import os,sys
p=sys.argv[1]; s=open(p).read(); e=os.environ
if e["OLD1"] not in s or e["OLD2"] not in s: sys.exit(9)
open(p,"w").write(s.replace(e["OLD1"],e["NEW1"]).replace(e["OLD2"],e["NEW2"]))
PY
if [[ $? -eq 0 ]]; then
  if suite_reddens; then verdict "unanchored cd + fail-open (20/07)" 1; else verdict "unanchored cd + fail-open (20/07)" 0; fi
else printf '  SKIP unanchored cd + fail-open (patterns not found)\n'; fi
revert secret-scanner.sh

restore_all
echo
"$HERE/run.sh" >/dev/null 2>&1 && echo "hooks restored, suite green again." || { echo "RESTORE FAILED — check $HOOKS"; exit 1; }
if [[ $BAD -eq 0 ]]; then echo "Mutation testing: $OK/$OK mutations detected."; exit 0
else echo "Mutation testing: $BAD mutation(s) UNDETECTED — coverage gap."; exit 1; fi
