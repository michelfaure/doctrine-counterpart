#!/usr/bin/env bash
# public-repo-identity-guard.sh — PreToolUse on Bash (Counterpart Doctrine)
# Born from three identity-leak incidents in a single day (2026-07-17): a chained
# scan-and-push that pushed before the scan output was read; a redaction script
# that crashed before writing while `;` sequencing let the commit+push proceed
# under a "redacted" message; a real→pseudo mapping line sitting public for a
# month in an archived file. Class: any leak scan that depends on human/agent
# SEQUENCING will eventually be skipped — the gate must run ON the push itself.
#
# Role: when a `git push` targets a repo that has a PUBLIC remote (a pattern you
# configure), scan the outgoing commits' blobs + the HEAD tree + the outgoing
# commit messages against a private identity blocklist. Any match → BLOCK
# (exit 2). Bypass: `[identity-ok]` in the command — after READING the matches,
# never blind.
#
# Configuration (both files PRIVATE — never commit them):
#   ~/.claude/private/public-remote-pattern.txt
#       one ERE (first non-comment line) matching your public remotes,
#       e.g.:  github\.com[:/]your-handle/
#   ~/.claude/private/identity-blocklist.txt      (chmod 600)
#       one ERE per line: real names, internal project names, client
#       identifiers, private emails — every token that must never reach a
#       public repo. EXTEND IT with every new real→pseudo mapping you create.
#   Env overrides: IDENTITY_GUARD_REMOTE_PATTERN, IDENTITY_GUARD_BLOCKLIST.
#
# Posture: NOT CONFIGURED (no remote pattern) → inactive, exit 0 — an opt-in
# gate. CONFIGURED + public push + blocklist unreadable → FAIL-CLOSED (blocked):
# this is a security gate (deploy-safeguard idiom), not a fail-open reminder.
#
# Known blind spot (assumed): identifiers ABSENT from the blocklist — arbitrary
# client names, fresh slugs. Complementary layers stay mandatory: STRUCTURAL
# redaction of slugs/exports before publishing (dates + counts, not sed-by-name),
# and post-push verification on a fresh clone of ALL refs — `git ls-remote` is
# the authority; tags retain the old history through a filter-repo rewrite.

set -euo pipefail

BLOCKLIST="${IDENTITY_GUARD_BLOCKLIST:-$HOME/.claude/private/identity-blocklist.txt}"
PATTERN_FILE="$HOME/.claude/private/public-remote-pattern.txt"
PUBLIC_REMOTE_PATTERN="${IDENTITY_GUARD_REMOTE_PATTERN:-}"
if [[ -z "$PUBLIC_REMOTE_PATTERN" ]]; then
  [[ -r "$PATTERN_FILE" ]] || exit 0   # not configured → inactive
  PUBLIC_REMOTE_PATTERN="$(grep -v '^#' "$PATTERN_FILE" | grep -v '^[[:space:]]*$' | head -1)"
  [[ -z "$PUBLIC_REMOTE_PATTERN" ]] && exit 0
fi

payload="$(cat)"
cmd="$(printf '%s' "$payload" | jq -r '.tool_input.command // empty')"
[[ -z "$cmd" ]] && exit 0

# Explicit bypass — legitimate only after reading the matches.
printf '%s' "$cmd" | grep -qF -- '[identity-ok]' && exit 0

# 1) Is this a push?
printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:]])git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+push([[:space:]]|$)' || exit 0

# 2) Locate the repo (git -C <dir> | cd <dir> | PWD)
dir=""
# `cd` matched ONLY at a command boundary: unanchored, it also reads the commit
# message (`-m "fix: cd in build.sh"`), captures a bogus path and disarms the gate.
CD_AT_BOUNDARY='(^|&&|;|\|)[[:space:]]*cd[[:space:]]+([^[:space:]&;|]+)'
if [[ "$cmd" =~ git[[:space:]]+-C[[:space:]]+([^[:space:]]+) ]]; then
  dir="${BASH_REMATCH[1]}"
elif [[ "$cmd" =~ $CD_AT_BOUNDARY ]]; then
  dir="${BASH_REMATCH[2]}"
fi
dir="${dir/#\~/$HOME}"
# An unresolvable path falls back to $PWD instead of exiting: a security gate
# must not disarm because a directory could not be parsed (class propagated from
# secret-scanner, 2026-07-20 — the instance was fixed there a round earlier).
if [[ -z "$dir" ]] || ! git -C "$dir" rev-parse --show-toplevel >/dev/null 2>&1; then
  dir="$PWD"
fi
git -C "$dir" rev-parse --show-toplevel >/dev/null 2>&1 || exit 0

# 3) Does the repo have a PUBLIC remote? Otherwise out of scope.
git -C "$dir" remote -v 2>/dev/null | grep -Eq "$PUBLIC_REMOTE_PATTERN" || exit 0

# 4) Fail-closed: no readable blocklist, no public push.
if [[ ! -r "$BLOCKLIST" ]]; then
  {
    echo "BLOCKED identity-guard — blocklist unreadable ($BLOCKLIST)."
    echo "Pushing to a PUBLIC repo without the identity gate is forbidden (fail-closed)."
    echo "Restore the blocklist, or bypass consciously with '[identity-ok]'."
  } >&2
  exit 2
fi
pattern="$(grep -v '^#' "$BLOCKLIST" | grep -v '^[[:space:]]*$' | paste -sd'|' -)"
[[ -z "$pattern" ]] && exit 0

# 5) Scan: outgoing commits' blobs (vs upstream when known) + HEAD tree
#    + outgoing commit messages. || true: a rev without hits must not kill the scan.
hits=""
upstream="$(git -C "$dir" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || true)"
if [[ -n "$upstream" ]]; then
  while IFS= read -r rev; do
    h="$(git -C "$dir" grep -iE -c "$pattern" "$rev" 2>/dev/null | head -5 || true)"
    [[ -n "$h" ]] && hits+="commit $rev :"$'\n'"$h"$'\n'
  done < <(git -C "$dir" rev-list "$upstream"..HEAD 2>/dev/null || true)
  msg_hits="$(git -C "$dir" log "$upstream"..HEAD --format=%B 2>/dev/null | grep -iE "$pattern" | head -3 || true)"
  [[ -n "$msg_hits" ]] && hits+="commit messages:"$'\n'"$msg_hits"$'\n'
fi
head_hits="$(git -C "$dir" grep -iE -c "$pattern" HEAD 2>/dev/null | head -8 || true)"
[[ -n "$head_hits" ]] && hits+="HEAD tree:"$'\n'"$head_hits"$'\n'

# 6) Chained commit&&push blind spot (caught on a live bite, 2026-07-19): a
#    PreToolUse hook runs BEFORE the command executes — a `git commit && git push`
#    chain is scanned at the PRE-commit HEAD, so the offending commit's content
#    escapes the scan. If the command also creates a commit/add, scan the
#    WORKING TREE (tracked files) as well.
if printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:]])git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+(commit|add)([[:space:]]|$)'; then
  wt_hits="$(git -C "$dir" grep -iE --untracked -c "$pattern" -- . 2>/dev/null | head -8 || true)"
  [[ -n "$wt_hits" ]] && hits+="working tree (chained commit before push):"$'\n'"$wt_hits"$'\n'
fi

[[ -z "$hits" ]] && exit 0

{
  echo "BLOCKED identity-guard — real identifiers detected before a PUBLIC push."
  echo "Command: $cmd"
  echo ""
  printf '%s\n' "$hits" | head -20
  echo ""
  echo "→ Scrub the content (cast pseudonyms / structural redaction), recommit, re-push."
  echo "→ False positive READ and verified: re-run with '[identity-ok]'."
  echo "→ Reminder: final verification happens on ORIGIN, via a fresh clone, ALL refs."
} >&2
exit 2
