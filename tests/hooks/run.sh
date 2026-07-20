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
# CONTRACT (verified by tests/hooks/mutate.sh and by CI, not merely stated here):
#   - every hook in .claude/hooks/ has at least one blocking case and one
#     passing case, OR an explicit documented exemption below;
#   - one case per command form for the command-matched gates;
#   - one case per secret pattern for the scanner.
# A contract stated in a header and not met is the ghost-probe class R18 hunts.
#
# Run before touching any hook:  ./tests/hooks/run.sh

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Overridable so the same harness can be pointed at another tier (the living
# user-scope hooks have their own suite): HOOKS_DIR=~/.claude/hooks ./run.sh
HOOKS="${HOOKS_DIR:-$(cd "$HERE/../../.claude/hooks" && pwd)}"
export HOOKS
# shellcheck source=lib.sh
source "$HERE/lib.sh"

TMPROOT="$(mktemp -d)"; trap 'rm -rf "$TMPROOT"' EXIT
export HOME_STATE="$TMPROOT/state"; mkdir -p "$HOME_STATE"

fresh_repo() { # <name> [clean]
  local d="$TMPROOT/$1"; mkdir -p "$d"; git -C "$d" init -q
  if [[ "${2:-secret}" == "clean" ]]; then printf 'const k = "not_a_secret"\n' > "$d/app.ts"
  else printf 'const k = "sk-ant-%s"\n' "AAAAAAAAAAAAAAAAAAAAAA" > "$d/app.ts"; fi
  git -C "$d" add app.ts; printf '%s' "$d"
}

echo "== secret-scanner: command forms =="
R="$(fresh_repo form1)"
check_cmd "canonical  git commit"               2 secret-scanner.sh "git commit -m x" "$R"
check_cmd "chained    git add -A && git commit" 2 secret-scanner.sh "git add -A && git commit -m x" "$R"
check_cmd "chained    cd <repo> && git commit"  2 secret-scanner.sh "cd $R && git commit -m x"
check_cmd "flag       git -C <repo> commit"     2 secret-scanner.sh "git -C $R commit -m x"
check_cmd "semicolon  cd <repo> ; git commit"   2 secret-scanner.sh "cd $R ; git commit -m x"
check_cmd "'cd' inside the commit MESSAGE"      2 secret-scanner.sh "git add -A && git commit -m 'fix: cd in build.sh'" "$R"
check_cmd "'cd usage' inside the message"       2 secret-scanner.sh "git add -A && git commit -m 'docs: cd usage'" "$R"
check_cmd "bypass [secret-ok] passes"           0 secret-scanner.sh "git commit -m 'x [secret-ok]'" "$R"
check_cmd "NEGATIVE: not a commit"              0 secret-scanner.sh "git status" "$R"

echo "== secret-scanner: staged vs disk =="
R2="$(fresh_repo staged)"; printf 'const k = "cleaned"\n' > "$R2/app.ts"
check_cmd "secret staged then cleaned on disk"  2 secret-scanner.sh "git commit -m x" "$R2"
RC="$(fresh_repo cleanrepo clean)"
check_cmd "NEGATIVE: clean index passes"        0 secret-scanner.sh "git add -A && git commit -m x" "$RC"

echo "== secret-scanner: one case per pattern =="
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
  name="${s%%|*}"; val="${s#*|}"; d="$TMPROOT/pat-$name"
  mkdir -p "$d"; git -C "$d" init -q; printf '%s\n' "$val" > "$d/secret.txt"; git -C "$d" add secret.txt
  check_cmd "pattern $name" 2 secret-scanner.sh "git commit -m x" "$d"
done

echo "== check-workaround-assumed =="
RW="$(fresh_repo wa clean)"
check_cmd "canonical  hack: message"            2 check-workaround-assumed.sh "git commit -m 'hack: patch'" "$RW"
check_cmd "chained    cd <repo> && hack:"       2 check-workaround-assumed.sh "cd $RW && git commit -m 'hack: patch'"
check_cmd "chained    add -A && hack:"          2 check-workaround-assumed.sh "git add -A && git commit -m 'hack: patch'" "$RW"
check_cmd "assumed tag passes"                  0 check-workaround-assumed.sh "git commit -m 'hack: patch [workaround-assumed]'" "$RW"
check_cmd "NEGATIVE: ordinary message"          0 check-workaround-assumed.sh "git commit -m 'feat: add endpoint'" "$RW"

echo "== deploy-safeguard (one case per blocked pattern) =="
check_cmd "git push origin main"                2 deploy-safeguard.sh "git push origin main"
check_cmd "chained  cd x && git push main"      2 deploy-safeguard.sh "cd /tmp && git push origin main"
check_cmd "git push --force"                    2 deploy-safeguard.sh "git push --force origin feature"
check_cmd "vercel --prod"                       2 deploy-safeguard.sh "vercel deploy --prod"
check_cmd "supabase db push"                    2 deploy-safeguard.sh "supabase db push"
check_cmd "git reset --hard main"               2 deploy-safeguard.sh "git reset --hard origin/main"
check_cmd "bypass [deploy-ok] passes"           0 deploy-safeguard.sh "git push origin main  # [deploy-ok]"
check_cmd "NEGATIVE: push to a feature branch"  0 deploy-safeguard.sh "git push origin feat/x"
check_cmd "NEGATIVE: ordinary command"          0 deploy-safeguard.sh "ls -la"

echo "== pre-merge-review-reminder (R19 business temperature) =="
RM="$TMPROOT/merge"; mkdir -p "$RM"; git -C "$RM" init -q -b main
printf 'x\n' > "$RM/readme.md"; git -C "$RM" add -A; git -C "$RM" -c user.email=t@t -c user.name=t commit -qm base
git -C "$RM" checkout -q -b feat
printf 'create or replace function f() returns void as $$ begin end; $$ language plpgsql security definer;\n' > "$RM/mig.sql"
git -C "$RM" add -A; git -C "$RM" -c user.email=t@t -c user.name=t commit -qm hot
check_cmd "hot diff (.sql + SECURITY DEFINER)"  2 pre-merge-review-reminder.sh "git merge feat" "$RM"
check_cmd "bypass [review-ok] passes"           0 pre-merge-review-reminder.sh "git merge feat  # [review-ok]" "$RM"
RM2="$TMPROOT/merge-cold"; mkdir -p "$RM2"; git -C "$RM2" init -q -b main
printf 'x\n' > "$RM2/readme.md"; git -C "$RM2" add -A; git -C "$RM2" -c user.email=t@t -c user.name=t commit -qm base
git -C "$RM2" checkout -q -b feat; printf 'doc\n' >> "$RM2/readme.md"
git -C "$RM2" add -A; git -C "$RM2" -c user.email=t@t -c user.name=t commit -qm cold
check_cmd "NEGATIVE: cold diff (docs only)"     0 pre-merge-review-reminder.sh "git merge feat" "$RM2"
check_cmd "NEGATIVE: not a merge command"       0 pre-merge-review-reminder.sh "git status" "$RM"

echo "== public-repo-identity-guard =="
# Opt-in gate: inactive without a configured remote pattern; fail-closed with one.
BL="$TMPROOT/blocklist.txt"; printf 'jane[- ]?doe\nacme-internal\n' > "$BL"
RI="$TMPROOT/idg"; mkdir -p "$RI"; git -C "$RI" init -q
git -C "$RI" remote add origin "https://github.com/testhandle/pub.git"
printf 'contact: Jane Doe\n' > "$RI/leak.md"; git -C "$RI" add -A
git -C "$RI" -c user.email=t@t -c user.name=t commit -qm leak
check_cmd "NEGATIVE: not configured → inactive" 0 public-repo-identity-guard.sh "git push origin main" "$RI"
check_cmd "public push carrying a blocked token" 2 public-repo-identity-guard.sh "git push origin main" "$RI" \
  "IDENTITY_GUARD_REMOTE_PATTERN=github\.com[:/]testhandle/" "IDENTITY_GUARD_BLOCKLIST=$BL"
check_cmd "chained commit&&push (working tree)"  2 public-repo-identity-guard.sh "git add -A && git commit -m x && git push origin main" "$RI" \
  "IDENTITY_GUARD_REMOTE_PATTERN=github\.com[:/]testhandle/" "IDENTITY_GUARD_BLOCKLIST=$BL"
check_cmd "fail-closed: blocklist unreadable"    2 public-repo-identity-guard.sh "git push origin main" "$RI" \
  "IDENTITY_GUARD_REMOTE_PATTERN=github\.com[:/]testhandle/" "IDENTITY_GUARD_BLOCKLIST=$TMPROOT/nope.txt"
check_cmd "bypass [identity-ok] passes"          0 public-repo-identity-guard.sh "git push origin main  # [identity-ok]" "$RI" \
  "IDENTITY_GUARD_REMOTE_PATTERN=github\.com[:/]testhandle/" "IDENTITY_GUARD_BLOCKLIST=$BL"
RI2="$TMPROOT/idg-clean"; mkdir -p "$RI2"; git -C "$RI2" init -q
git -C "$RI2" remote add origin "https://github.com/testhandle/pub.git"
printf 'nothing sensitive\n' > "$RI2/ok.md"; git -C "$RI2" add -A
git -C "$RI2" -c user.email=t@t -c user.name=t commit -qm ok
check_cmd "NEGATIVE: clean public push passes"   0 public-repo-identity-guard.sh "git push origin main" "$RI2" \
  "IDENTITY_GUARD_REMOTE_PATTERN=github\.com[:/]testhandle/" "IDENTITY_GUARD_BLOCKLIST=$BL"

echo "== memory-write-guard (Write/Edit payloads) =="
LONG="$(printf 'a%.0s' $(seq 1 250))"
check_write "line over the char limit"          2 memory-write-guard.sh "/x/memory/MEMORY.md" "- [a](a.md) — $LONG"
check_write "root-level MEMORY.md is guarded"   2 memory-write-guard.sh "/x/MEMORY.md" "- [a](a.md) — $LONG"
check_write "Edit payload (new_string)"         2 memory-write-guard.sh "/x/memory/MEMORY.md" "- [a](a.md) — $LONG" "Edit"
check_write "NEGATIVE: short line passes"       0 memory-write-guard.sh "/x/memory/MEMORY.md" "- [a](a.md) — hook court"
check_write "NEGATIVE: another file untouched"  0 memory-write-guard.sh "/x/notes.md" "- [a](a.md) — $LONG"
check_write "deliberate bypass passes"          0 memory-write-guard.sh "/x/memory/MEMORY.md" "- [a](a.md) — $LONG" "Write" "MEMORY_GUARD_BYPASS=1"

echo "== pre-bulk-mutation-count-staleness (MCP payloads) =="
check_sql "bulk UPDATE without fresh count"     2 pre-bulk-mutation-count-staleness.sh "UPDATE inscriptions SET statut = 'x' WHERE source IS NULL"
check_sql "bulk DELETE without fresh count"     2 pre-bulk-mutation-count-staleness.sh "DELETE FROM inscriptions WHERE source IS NULL"
check_sql "NEGATIVE: single-row UPDATE by id"   0 pre-bulk-mutation-count-staleness.sh "UPDATE inscriptions SET statut = 'x' WHERE id = 42"
check_sql "NEGATIVE: plain SELECT"              0 pre-bulk-mutation-count-staleness.sh "SELECT count(*) FROM inscriptions"

echo "== r15-commit-gate (stateful) =="
STATE_DIR="$TMPROOT/home/.claude/state"; mkdir -p "$STATE_DIR"
printf '{"count": 9}' > "$STATE_DIR/r15-autonomous-counter.json"
RG="$(fresh_repo r15 clean)"
check_cmd "commit above threshold blocks"       2 r15-commit-gate.sh "git commit -m x" "$RG" "HOME=$TMPROOT/home"
check_cmd "bypass [autonomy-ack] passes"        0 r15-commit-gate.sh "git commit -m 'x # [autonomy-ack]'" "$RG" "HOME=$TMPROOT/home"
check_cmd "R15_THRESHOLD override passes"       0 r15-commit-gate.sh "git commit -m x" "$RG" "HOME=$TMPROOT/home" "R15_THRESHOLD=99"
printf '{"count": 0}' > "$STATE_DIR/r15-autonomous-counter.json"
check_cmd "NEGATIVE: below threshold passes"    0 r15-commit-gate.sh "git commit -m x" "$RG" "HOME=$TMPROOT/home"
check_cmd "NEGATIVE: not a commit"              0 r15-commit-gate.sh "git status" "$RG" "HOME=$TMPROOT/home"

# ---------------------------------------------------------------------------
# Documented exemptions (the contract above allows these, and only these):
#   - r15-autonomous-counter.sh : PostToolUse/UserPromptSubmit bookkeeping, argv
#     driven, never blocks (exit 0 by design). Its blocking half IS r15-commit-gate,
#     covered above.
#   - audit-memory-reminder.sh  : SessionStart reminder, no payload, never blocks.
# Both are non-gating by construction — there is no block/pass pair to assert.
# ---------------------------------------------------------------------------

summary
