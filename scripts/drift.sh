#!/usr/bin/env bash
# drift.sh: read-only report of drift between a live ~/.claude setup and this repo.
# Exits 0 if everything is in sync, 1 if anything drifted or is undecided.
# Never copies anything; sync is manual by design (see docs/sync.md).

set -u

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DRIFT=0

compare() {
  local live="$1" repo="$2" label="$3"
  if [ ! -f "$live" ]; then
    echo "MISSING LIVE   $label (no $live)"
    DRIFT=1
  elif ! diff -q "$live" "$repo" >/dev/null 2>&1; then
    echo "DRIFTED        $label"
    DRIFT=1
  fi
}

echo "Live setup: $CLAUDE_DIR"
echo "Repo:       $REPO_DIR"
echo

# Commands: every command shipped in the repo vs its live counterpart.
# Sanitized files (see docs/sync.md) are EXPECTED to differ; the report
# shows drift, and you judge whether it's the documented sanitize delta or new content.
for repo_file in "$REPO_DIR"/commands/*.md; do
  name="$(basename "$repo_file")"
  live_file="$CLAUDE_DIR/commands/$name"
  # style-review.md is a rewrite of internal-prose-review.md in the live setup
  [ "$name" = "style-review.md" ] && live_file="$CLAUDE_DIR/commands/internal-prose-review.md"
  compare "$live_file" "$repo_file" "commands/$name"
done

# Hooks and rules
compare "$CLAUDE_DIR/hooks/session-log-reader.sh" "$REPO_DIR/hooks/session-log-reader.sh" "hooks/session-log-reader.sh"
compare "$CLAUDE_DIR/hooks/session-handoff-writer.sh" "$REPO_DIR/hooks/session-handoff-writer.sh" "hooks/session-handoff-writer.sh"
compare "$CLAUDE_DIR/rules/writing-style.md" "$REPO_DIR/templates/rules/writing-style.md" "templates/rules/writing-style.md"
compare "$CLAUDE_DIR/CLAUDE.md" "$REPO_DIR/templates/CLAUDE.md" "templates/CLAUDE.md"

# New live commands not in the manifest: need triage
echo
for live_file in "$CLAUDE_DIR"/commands/*.md; do
  name="$(basename "$live_file")"
  case "$name" in
    internal-prose-review.md) continue ;;  # ships as style-review.md
    # Excluded by decision, see "Never ships" in docs/sync.md
    cv.md|gdrive-scan.md|html-to-slides.md|README.md|BRAIN-EXTENSION-SETUP.md) continue ;;
    # Third-party (Every's editorial skills): never published here
    every-review.md|panel.md|debate.md|dev-edit.md|line-edit.md|asshole.md|mom.md) continue ;;
    hemingway.md|hitchcock.md|sorkin.md|sedaris.md|vonnegut.md|eli5.md|guardrails.md) continue ;;
  esac
  if [ ! -f "$REPO_DIR/commands/$name" ]; then
    echo "UNDECIDED      $name (in live setup, not in repo; triage: include / sanitize / exclude)"
    DRIFT=1
  fi
done

echo
if [ "$DRIFT" -eq 0 ]; then
  echo "In sync."
else
  echo "Drift found. Review each item against docs/sync.md before copying anything."
fi
exit "$DRIFT"
