#!/usr/bin/env bash
# Deploy safeguard hook — PreToolUse on Bash
# Exit 0 = allow, exit 2 = block (stderr shown to Claude + user)
# Blocks dangerous commands unless the literal string '[deploy-ok]' appears
# anywhere in the command (trailing comment, token, etc).
# Reads JSON payload from stdin: .tool_input.command

set -euo pipefail

payload="$(cat)"
cmd="$(printf '%s' "$payload" | jq -r '.tool_input.command // empty')"

[[ -z "$cmd" ]] && exit 0

# Explicit bypass marker
if printf '%s' "$cmd" | grep -qF -- '[deploy-ok]'; then
  exit 0
fi

# Pattern table: label|extended-regex
# Target shell command strings; matches meant to be conservative (better false
# positive than false negative, bypass is one token).
patterns=(
  "git push to main/master|git[[:space:]]+push([[:space:]]+[^;&|]+)?[[:space:]](origin[[:space:]]+)?(main|master)([[:space:]]|$|:)"
  "git push --force|git[[:space:]]+push([[:space:]]+[^;&|]+)?[[:space:]](-f|--force|--force-with-lease)([[:space:]]|$)"
  "vercel --prod|vercel([[:space:]]+[a-z]+)?([[:space:]]+[^;&|]+)?[[:space:]]--prod([[:space:]]|$)"
  "supabase db push|supabase[[:space:]]+db[[:space:]]+push"
  "git reset --hard main|git[[:space:]]+reset[[:space:]]+--hard[[:space:]]+([^;&|]+[[:space:]])?(main|master|origin/main|origin/master)([[:space:]]|$)"
  "rm -rf rembrandt|rm[[:space:]]+(-[a-zA-Z]*r[a-zA-Z]*f[a-zA-Z]*|-[a-zA-Z]*f[a-zA-Z]*r[a-zA-Z]*)[[:space:]]+[^;&|]*rembrandt"
)

for entry in "${patterns[@]}"; do
  label="${entry%%|*}"
  regex="${entry#*|}"
  if printf '%s' "$cmd" | grep -E -q -e "$regex"; then
    {
      echo "BLOCKED: deploy-safeguard matched '$label'"
      echo "Command: $cmd"
      echo ""
      echo "Add '[deploy-ok]' in the command to bypass (e.g. trailing comment)."
      echo "Example: git push origin main  # [deploy-ok]"
    } >&2
    exit 2
  fi
done

exit 0
