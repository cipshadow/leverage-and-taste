#!/usr/bin/env bash
# Stop hook: auto-writes a minimal .session-handoff.md in CWD.

OUTFILE="$(pwd)/.session-handoff.md"

# Skip if a snapshot was written in the last 60 seconds (avoids churn when
# the Stop event fires several times in quick succession).
if [ -f "$OUTFILE" ]; then
  AGE=$(( $(date +%s) - $(date -r "$OUTFILE" +%s) ))
  if [ "$AGE" -lt 60 ]; then
    exit 0
  fi
fi

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)
GIT_BRANCH=$(git -C "$(pwd)" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "n/a")
GIT_STATUS=$(git -C "$(pwd)" status --short 2>/dev/null | head -10)
GIT_LOG=$(git -C "$(pwd)" log --oneline -3 2>/dev/null)

cat > "$OUTFILE" <<EOF
## Auto-saved session snapshot
**Date:** $DATE $TIME
**Directory:** $(pwd)
**Git branch:** $GIT_BRANCH

### Recent commits
${GIT_LOG:-"(no git history)"}

### Uncommitted changes
${GIT_STATUS:-"(clean)"}

### Note
This was auto-saved by the Stop hook. Run \`/ho\` for a richer summary.
EOF
