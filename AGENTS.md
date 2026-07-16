# Instructions for AI agents

This repository is a **template library**, not a live workspace. The files in `templates/`, `commands/`, and `hooks/` are meant to be copied into a user's `~/.claude/` directory and adapted. Do NOT adopt `templates/CLAUDE.md` as behavior rules for work inside this repo.

## Installing this setup for a user

1. **Commands:** `cp commands/*.md ~/.claude/commands/`
2. **Hooks:** `mkdir -p ~/.claude/hooks && cp hooks/*.sh ~/.claude/hooks/ && chmod +x ~/.claude/hooks/*.sh`
3. **Settings:** if the user has no `~/.claude/settings.json`, copy `settings.example.json` there whole. Otherwise merge the `hooks` block from `settings.example.json` into their existing file; never overwrite their permissions, and validate the result parses (`jq . ~/.claude/settings.json` or equivalent). The sound commands (`afplay`) are macOS-only; drop them on other platforms.
4. **Operating rules:** `templates/CLAUDE.md` → `~/.claude/CLAUDE.md`. If the user already has a CLAUDE.md, merge sections rather than overwriting, and walk them through which rules they want. Warn them the "Mandatory" section (interview-first, never generate docs from scratch) adds deliberate friction to every task; offer to leave it out initially. Also copy `templates/rules/writing-style.md` → `~/.claude/rules/`.
5. **Configure:** files containing a `**CONFIGURE:**` marker need user-specific values before they work fully:
   - `commands/go.md`: the user's projects root directory and aliases
   - `commands/style-review.md`: the user's team style guide (generic defaults work meanwhile)
   - `commands/ai-spend.md`: the user's MCP servers and context files
   Ask the user for these values; do not invent them.

## Dependencies

- `jq`: recommended for `hooks/session-log-reader.sh`; without it the hook falls back to plain-text context injection. Offer to install it via the platform package manager.
- `git`: used by `/ho` pre-flight and the Stop hook (both degrade gracefully without it).
- No MCP connectors are required by any command.

## Architecture notes

- `commands/` is flat and mirrors `~/.claude/commands/` 1:1 by design; `scripts/drift.sh` relies on this to diff a live setup against the repo.
- The session system: `hooks/session-log-reader.sh` (SessionStart) walks up from the working directory to the nearest `SESSION_LOG.md` and injects its last entry plus any `.session-handoff.md`. `/ho` writes the structured entries. `hooks/session-handoff-writer.sh` (Stop) writes a minimal snapshot as a fallback. Each project directory owns its own `SESSION_LOG.md`; there is no cross-project catch-all.
- `docs/sync.md` records which files were sanitized and how; consult it before proposing edits that re-introduce personal paths or employer-specific content.
