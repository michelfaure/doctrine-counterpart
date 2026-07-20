#!/usr/bin/env bash
# tests/hooks/lib.sh — shared harness for the hook suites.
#
# Two payload shapes exist in Claude Code, and a suite that only builds one of
# them silently caps its own coverage: every Write/Edit-matched hook was
# structurally untestable while the harness emitted `.tool_input.command` only
# (external review, 2026-07-20). Hence check_cmd / check_write / check_sql.
#
# The payload is piped from a VARIABLE, never interpolated into `bash -c`: the
# first draft of this harness did the latter and reported five phantom failures
# the moment a test command contained an apostrophe (`-m 'fix: …'`). A test
# harness is falsifiable like everything else — when a case reddens, isolate the
# harness before touching the code under test.

PASS=0; FAIL=0

_json() { printf '%s' "$1" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'; }

_report() { # <label> <got> <want>
  if [[ "$2" == "$3" ]]; then
    printf '  ok   %-56s (exit %s)\n' "$1" "$2"; PASS=$((PASS+1))
  else
    printf '  FAIL %-56s (exit %s, expected %s)\n' "$1" "$2" "$3"; FAIL=$((FAIL+1))
  fi
}

_run() { # <hook> <payload> <cwd> [env assignments…]
  local hook="$1" payload="$2" cwd="$3"; shift 3
  ( cd "$cwd" && printf '%s' "$payload" | env "$@" "$HOOKS/$hook" >/dev/null 2>&1 )
  echo $?
}

# Bash-matched hooks (PreToolUse, .tool_input.command)
# check_cmd <label> <want> <hook> <command> [cwd] [env…]
check_cmd() {
  local label="$1" want="$2" hook="$3" cmd="$4"; shift 4
  local cwd="${1:-$PWD}"; [[ $# -gt 0 ]] && shift
  local payload; payload="$(printf '{"tool_input":{"command":%s}}' "$(_json "$cmd")")"
  _report "$label" "$(_run "$hook" "$payload" "$cwd" "$@")" "$want"
}

# Write/Edit/MultiEdit-matched hooks (file_path + written text)
# check_write <label> <want> <hook> <file_path> <content> [tool] [env…]
check_write() {
  local label="$1" want="$2" hook="$3" fp="$4" content="$5"; shift 5
  local tool="${1:-Write}"; [[ $# -gt 0 ]] && shift
  local key payload
  case "$tool" in Edit) key="new_string" ;; *) key="content" ;; esac
  payload="$(printf '{"tool_name":%s,"tool_input":{"file_path":%s,%s:%s}}' \
      "$(_json "$tool")" "$(_json "$fp")" "$(_json "$key")" "$(_json "$content")")"
  _report "$label" "$(_run "$hook" "$payload" "$PWD" "$@")" "$want"
}

# MCP-matched hooks (.tool_input.query)
# check_sql <label> <want> <hook> <query>
check_sql() {
  local label="$1" want="$2" hook="$3" q="$4"
  local payload; payload="$(printf '{"tool_input":{"query":%s}}' "$(_json "$q")")"
  _report "$label" "$(_run "$hook" "$payload" "$PWD")" "$want"
}

summary() {
  echo
  if [[ $FAIL -eq 0 ]]; then echo "All $PASS hook assertions passed."; return 0
  else echo "$FAIL FAILED, $PASS passed."; return 1; fi
}

# NOTE — two tiers, two suites, one harness.
# This library is shared by:
#   - tests/hooks/run.sh        (published tier, in this repo, run by CI)
#   - a user-scope living suite (the author's own hooks, never published)
# The published suite cannot attest the living one: on the author's machine the
# two diverge substantially (different matchers, stack-specific patterns, and
# two living-only hooks). If you adopt this toolkit and customise your hooks,
# copy run.sh, point HOOKS_DIR at your own directory, and keep your suite where
# your hooks live. A suite that tests the artefact you publish says nothing
# about the enforcement you run.
