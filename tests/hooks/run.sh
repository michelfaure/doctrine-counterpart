#!/usr/bin/env bash
# tests/hooks/run.sh — versioned test suite for the doctrine's hooks.
#
# Why this exists: three consecutive rounds of hook fixes (2026-07-19/20) were
# each validated by a throwaway manual probe, and each round shipped a new
# defect of the same class (an unanchored regex, a fail-open path, a pattern
# that never matched). Two of those probes — one the author's, one the external
# reviewer's — were themselves invalid. R17 applied to the enforcement layer:
# a hook is only covered for the command FORMS and the PATTERNS it asserts.
#
# Contract: one case per command form, one case per secret pattern, and a
# negative case per hook (a gate that never passes is as broken as one that
# never bites). Run before touching any hook: ./tests/hooks/run.sh

set -uo pipefail

HOOKS="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.claude/hooks" && pwd)"
PASS=0; FAIL=0
TMPROOT="$(mktemp -d)"
trap 'rm -rf "$TMPROOT"' EXIT

# fresh_repo <name> — a git repo with a staged secret unless $2 = clean
fresh_repo() {
  local d="$TMPROOT/$1"; mkdir -p "$d"; git -C "$d" init -q
  if [[ "${2:-secret}" == "clean" ]]; then
    printf 'const k = "not_a_secret"\n' > "$d/app.ts"
  else
    printf 'const k = "sk-ant-%s"\n' "AAAAAAAAAAAAAAAAAAAAAA" > "$d/app.ts"
  fi
  git -C "$d" add app.ts
  printf '%s' "$d"
}

# check <label> <expected_exit> <hook> <command> [cwd]
check() {
  local label="$1" want="$2" hook="$3" cmd="$4" cwd="${5:-$PWD}"
  local got
  got=$( cd "$cwd" && printf '{"tool_input":{"command":%s}}' "$(printf '%s' "$cmd" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')" \
         | "$HOOKS/$hook" >/dev/null 2>&1; echo $? )
  if [[ "$got" == "$want" ]]; then
    printf '  ok   %-58s (exit %s)\n' "$label" "$got"; PASS=$((PASS+1))
  else
    printf '  FAIL %-58s (exit %s, expected %s)\n' "$label" "$got" "$want"; FAIL=$((FAIL+1))
  fi
}

echo "== secret-scanner: command forms =="
R="$(fresh_repo form1)"
check "canonical  git commit"                    2 secret-scanner.sh "git commit -m x" "$R"
check "chained    git add -A && git commit"      2 secret-scanner.sh "git add -A && git commit -m x" "$R"
check "chained    cd <repo> && git commit"       2 secret-scanner.sh "cd $R && git commit -m x"
check "flag       git -C <repo> commit"          2 secret-scanner.sh "git -C $R commit -m x"
check "semicolon  cd <repo> ; git commit"        2 secret-scanner.sh "cd $R ; git commit -m x"
# The bypass introduced by the 19/07 fix: 'cd' inside the commit MESSAGE
check "message contains 'cd in build.sh'"        2 secret-scanner.sh "git add -A && git commit -m 'fix: cd in build.sh'" "$R"
check "message contains 'docs: cd usage'"        2 secret-scanner.sh "git add -A && git commit -m 'docs: cd usage'" "$R"
check "explicit bypass [secret-ok]"              0 secret-scanner.sh "git commit -m 'x [secret-ok]'" "$R"
check "not a commit (git status)"                0 secret-scanner.sh "git status" "$R"

echo "== secret-scanner: staged vs disk =="
R2="$(fresh_repo staged)"
printf 'const k = "cleaned"\n' > "$R2/app.ts"   # secret removed from disk, still in index
check "secret staged then cleaned from disk"     2 secret-scanner.sh "git commit -m x" "$R2"
RC="$(fresh_repo cleanrepo clean)"
check "NEGATIVE: clean index passes"             0 secret-scanner.sh "git add -A && git commit -m x" "$RC"

echo "== secret-scanner: one case per pattern =="
# Each pattern must actually bite. The PEM one silently never matched for months
# because grep read its leading dashes as options.
declare -a SAMPLES=(
  "openai|sk-AAAAAAAAAAAAAAAAAAAAAAAA"
  "anthropic|sk-ant-AAAAAAAAAAAAAAAAAAAAAA"
  "github-pat|ghp_AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  "aws-key|AKIAAAAAAAAAAAAAAAAA"
  "slack-bot|xoxb-1-1-1-AAAAAAAA"
  "jwt|eyJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA.eyJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA."
  "supabase-service-role|service_role: eyJ"
  "gitlab-pat|glpat-AAAAAAAAAAAAAAAAAAAA"
  "pem-private-key|-----BEGIN RSA PRIVATE KEY-----"
)
for s in "${SAMPLES[@]}"; do
  name="${s%%|*}"; val="${s#*|}"
  d="$TMPROOT/pat-$name"; mkdir -p "$d"; git -C "$d" init -q
  printf '%s\n' "$val" > "$d/secret.txt"; git -C "$d" add secret.txt
  check "pattern $name" 2 secret-scanner.sh "git commit -m x" "$d"
done

echo "== check-workaround-assumed: command forms =="
RW="$(fresh_repo wa clean)"
check "canonical  hack: message"                 2 check-workaround-assumed.sh "git commit -m 'hack: patch'" "$RW"
check "chained    cd <repo> && hack:"            2 check-workaround-assumed.sh "cd $RW && git commit -m 'hack: patch'"
check "chained    add -A && hack:"               2 check-workaround-assumed.sh "git add -A && git commit -m 'hack: patch'" "$RW"
check "assumed tag passes"                       0 check-workaround-assumed.sh "git commit -m 'hack: patch [workaround-assumed]'" "$RW"
check "NEGATIVE: ordinary message passes"        0 check-workaround-assumed.sh "git commit -m 'feat: add endpoint'" "$RW"

echo
if [[ $FAIL -eq 0 ]]; then
  echo "All $PASS hook assertions passed."
else
  echo "$FAIL FAILED, $PASS passed."
  exit 1
fi
