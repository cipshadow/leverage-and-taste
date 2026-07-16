#!/usr/bin/env bash
# SessionStart hook: injects the last SESSION_LOG entry + any .session-handoff.md as context.

LOGFILE=""
CONTEXT=""

DIR="$(pwd)"
while true; do
  if [ -f "$DIR/SESSION_LOG.md" ]; then
    LOGFILE="$DIR/SESSION_LOG.md"
    break
  fi
  [ "$DIR" = "$HOME" ] || [ "$DIR" = "/" ] && break
  DIR="$(dirname "$DIR")"
done

if [ -n "$LOGFILE" ]; then
  LAST_ENTRY=$(awk '/^### [0-9]{4}-[0-9]{2}-[0-9]{2}/{buf=""} {buf = buf (length(buf) ? "\n" : "") $0} END{print buf}' "$LOGFILE")
  if [ -n "$LAST_ENTRY" ]; then
    REL_PATH="${LOGFILE#$HOME/}"
    CONTEXT="## Last Session (from ~/$REL_PATH)"$'\n\n'"$LAST_ENTRY"
  fi
fi

HANDOFF_FILE="$(pwd)/.session-handoff.md"
if [ -f "$HANDOFF_FILE" ]; then
  HANDOFF_CONTENT=$(cat "$HANDOFF_FILE")
  if [ -n "$HANDOFF_CONTENT" ]; then
    if [ -n "$CONTEXT" ]; then
      CONTEXT="$CONTEXT"$'\n\n'"---"$'\n\n'"## Session Snapshot (.session-handoff.md)"$'\n\n'"$HANDOFF_CONTENT"
    else
      CONTEXT="## Session Snapshot (.session-handoff.md)"$'\n\n'"$HANDOFF_CONTENT"
    fi
  fi
fi

[ -z "$CONTEXT" ] && exit 0

jq -n \
  --arg ctx "$CONTEXT" \
  --arg msg "Session context injected (SESSION_LOG + .session-handoff.md)" \
  '{
    "hookSpecificOutput": {
      "hookEventName": "SessionStart",
      "additionalContext": $ctx
    },
    "systemMessage": $msg
  }'
