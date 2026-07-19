#!/usr/bin/env bash
# memory-write-guard.sh — PreToolUse on Write|Edit|MultiEdit
# Counterpart Toolkit v0.8 — Artefact B, couples R18 (the doctrine is a data table).
#
# Enforces the MEMORY.md hygiene policy at WRITE-TIME instead of by an a-posteriori
# monthly audit. Incident 27/05/2026: the auto-memory wrote a 306-char index line
# 23 minutes after the 200-char threshold was declared in CLAUDE.md — the audit
# catches orphans, not format violations at the moment of writing. A declarative
# policy needs an executive guard.
#
# Policy (CLAUDE.md, 27/05/2026): MEMORY.md index <= 200 lines, each line <= 200 chars.
# Exit 0 = allow, exit 2 = block (stderr shown to Claude + user).
# Deliberate override: MEMORY_GUARD_BYPASS=1 (logged to stderr).

set -euo pipefail

MAX_LINES=200
MAX_LINE_CHARS=200

payload="$(cat)"

tool_name="$(printf '%s' "$payload" | jq -r '.tool_name // empty')"
file_path="$(printf '%s' "$payload" | jq -r '.tool_input.file_path // empty')"

# Guard only THE user-scope memory index MEMORY.md (not the topic files, not other repos).
case "$file_path" in
  MEMORY.md|*/MEMORY.md) : ;;   # root-level index (adopter default) or any */MEMORY.md path
  *) exit 0 ;;
esac

# Deliberate, logged bypass.
if [[ "${MEMORY_GUARD_BYPASS:-}" == "1" ]]; then
  echo "memory-write-guard: BYPASS active (MEMORY_GUARD_BYPASS=1) on $file_path" >&2
  exit 0
fi

# Text introduced by this op: Write .content | Edit .new_string | MultiEdit .edits[].new_string
new_text="$(printf '%s' "$payload" | jq -r '
  [
    .tool_input.content // empty,
    .tool_input.new_string // empty,
    ((.tool_input.edits // []) | map(.new_string) | join("\n"))
  ] | join("\n")
')"

# --- Check 1: per-line length (the 306-char incident) ---
# awk length counts bytes (accents may slightly over-count vs chars) — conservative by design.
longest="$(printf '%s\n' "$new_text" | awk 'length > max { max = length; line = $0 } END { print max "\t" line }')"
longest_len="${longest%%$'\t'*}"
longest_line="${longest#*$'\t'}"
if [[ "${longest_len:-0}" -gt "$MAX_LINE_CHARS" ]]; then
  {
    echo "BLOCKED: memory-write-guard — an index line exceeds ${MAX_LINE_CHARS} chars (${longest_len})."
    echo "Offending line: ${longest_line:0:120}…"
    echo ""
    echo "Policy (CLAUDE.md): each MEMORY.md index line <= ${MAX_LINE_CHARS} chars."
    echo "Compact the description or move the detail into the topic file."
    echo "Deliberate override: prefix the call with MEMORY_GUARD_BYPASS=1."
  } >&2
  exit 2
fi

# --- Check 2: projected total line count ---
# Line-count delta of an Edit = newline-count(new_string) - newline-count(old_string).
nl_count() { printf '%s' "$1" | tr -cd '\n' | wc -c | tr -d ' '; }

current=0
[[ -f "$file_path" ]] && current="$(awk 'END { print NR }' "$file_path")"

case "$tool_name" in
  Write)
    projected="$(awk 'END { print NR }' <<<"$new_text")"
    ;;
  Edit|MultiEdit)
    old_text="$(printf '%s' "$payload" | jq -r '
      [
        .tool_input.old_string // empty,
        ((.tool_input.edits // []) | map(.old_string) | join("\n"))
      ] | join("\n")
    ')"
    projected=$(( current + $(nl_count "$new_text") - $(nl_count "$old_text") ))
    ;;
  *)
    exit 0
    ;;
esac

# Block only when the op pushes the file OVER the limit AND makes it worse (grows the
# line count). Non-worsening ops — typo fixes (delta 0) and compactions (delta < 0) —
# are the path back to compliance and always pass, even while the file is still > limit.
if [[ "${projected:-0}" -gt "$MAX_LINES" && "${projected:-0}" -gt "${current:-0}" ]]; then
  {
    echo "BLOCKED: memory-write-guard — MEMORY.md would grow ${current} → ${projected} lines (limit ${MAX_LINES})."
    echo ""
    echo "Policy (CLAUDE.md): MEMORY.md index <= ${MAX_LINES} lines (system truncation threshold)."
    echo "Archive a closed/orphan entry or compact a description BEFORE adding."
    echo "This is R18 in action: the corpus must lose mass, not only grow."
    echo "(Non-growing edits — typo fixes, compactions — are allowed even while > limit.)"
    echo "Deliberate override: prefix the call with MEMORY_GUARD_BYPASS=1."
  } >&2
  exit 2
fi

exit 0
