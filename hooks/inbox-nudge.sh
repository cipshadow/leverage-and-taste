#!/usr/bin/env bash
# SessionStart hook: nudges when a hub-and-spoke context folder has untriaged
# files at its root. Root itself is the drop zone (drop new files straight in;
# a separate _inbox/ also works and is checked too). Fast: just find/stat on
# a few fixed paths.

# CONFIGURE: the hub-and-spoke folders to watch, as "path:label" pairs.
FOLDERS=(
  "$HOME/projects/health:health"
  "$HOME/projects/fin-advice:fin-advice"
)

# Core entrypoints every hub-and-spoke folder has, exempt from triage.
CORE_FILES=(CLAUDE.md README.md AGENTS.md CONTEXT.md active-context.md DECISIONS.md decisions.md SESSION_LOG.md .session-handoff.md)

NUDGES=()

mtime_of() {
  # BSD (macOS) stat first, GNU (Linux) stat as fallback.
  stat -f '%B' "$1" 2>/dev/null || stat -c '%Y' "$1" 2>/dev/null
}

is_exempt() {
  local base="$1" allowlist="$2"
  for core in "${CORE_FILES[@]}"; do
    [ "$base" = "$core" ] && return 0
  done
  [ -f "$allowlist" ] && grep -qxF "$base" "$allowlist" && return 0
  return 1
}

check_inbox() {
  local dir="$1" label="$2"
  local inbox="$dir/_inbox"
  [ -d "$inbox" ] || return 0

  local count
  count=$(find "$inbox" -maxdepth 1 -type f ! -name ".*" | wc -l | tr -d ' ')
  [ "$count" -eq 0 ] && return 0

  NUDGES+=("_inbox/ has $count file(s) waiting in $label/")
}

check_root() {
  local dir="$1" label="$2"
  [ -d "$dir" ] || return 0
  local allowlist="$dir/.claude/root-allowlist"

  local loose=0
  local oldest_epoch=""
  while IFS= read -r f; do
    local base
    base=$(basename "$f")
    if ! is_exempt "$base" "$allowlist"; then
      loose=$((loose + 1))
      local mtime
      mtime=$(mtime_of "$f")
      if [ -n "$mtime" ] && { [ -z "$oldest_epoch" ] || [ "$mtime" -lt "$oldest_epoch" ]; }; then
        oldest_epoch="$mtime"
      fi
    fi
  done < <(find "$dir" -maxdepth 1 -type f ! -name ".*")

  [ "$loose" -eq 0 ] && return 0

  local oldest_days="?"
  if [ -n "$oldest_epoch" ]; then
    oldest_days=$(( ( $(date +%s) - oldest_epoch ) / 86400 ))
  fi

  NUDGES+=("$label/ root has $loose untriaged file(s) waiting (oldest: ${oldest_days}d)")
}

for entry in "${FOLDERS[@]}"; do
  dir="${entry%%:*}"
  label="${entry##*:}"
  check_inbox "$dir" "$label"
  check_root "$dir" "$label"
done

[ ${#NUDGES[@]} -eq 0 ] && exit 0

MSG=$(printf '%s\n' "${NUDGES[@]}")
MSG="$MSG"$'\n'"Run /context-refresh to file them."

if command -v jq >/dev/null 2>&1; then
  jq -n --arg msg "$MSG" '{"systemMessage": $msg}'
else
  printf '%s\n' "$MSG" >&2
fi
exit 0
