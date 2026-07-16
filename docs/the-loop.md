# The loop

Claude Code forgets everything between sessions. The session system in this repo makes context persist, so each session starts where the last one ended instead of from zero. It has four pieces that form one loop.

## The pieces

**1. SessionStart hook: `hooks/session-log-reader.sh`**

When a session starts, this hook walks up from your working directory to the nearest `SESSION_LOG.md` and injects its most recent entry as context. It also injects `.session-handoff.md` if one exists. You start every session already caught up, without pasting anything.

Uses `jq` if installed (for Claude Code's structured hook protocol); without it, falls back to plain-text output, which SessionStart hooks also inject.

**2. `/ho`: the deliberate handoff**

At session end, `/ho` runs a pre-flight check for loose ends (temp files worth saving, open TODOs), then appends a structured entry to the project's `SESSION_LOG.md`: goal, what was done, decisions with reasoning, pending items, and a "how to continue" instruction written for a fresh Claude instance. It finishes by chaining `/anti-sloppifier`.

**3. Stop hook: `hooks/session-handoff-writer.sh`**

Claude Code fires the Stop event whenever Claude finishes responding, not just when you quit. Each time, this hook auto-writes a minimal `.session-handoff.md` snapshot (date, directory, git branch, recent commits, uncommitted changes), skipping if one was written in the last minute. It's the safety net for sessions that end without a `/ho`: you lose the narrative but keep the state.

**4. `/anti-sloppifier`: the discipline audit**

Runs at natural checkpoints (a decision made, a doc produced, roughly every 10 messages) and always as part of `/ho`. It audits the session against the operating rules in `templates/CLAUDE.md`: did AI anchor your thinking, did you abdicate a decision, did slop get through? Findings go to `~/.claude/diary.md`, deliberately separate from the session log: the log records *work done*, the diary records *how AI was used*.

Each audit also rolls up into `~/.claude/diary-trends.md`, a long-term dashboard: recurring signals ranked by count, a ledger of prescribed habits and whether you actually practiced them, and monthly decision-agency tallies. The diary answers "what happened this session"; the trends file answers "what keeps happening," which is where AI-use discipline is actually won or lost.

## The loop in practice

```
claude                          # session starts in a project directory
  → hook injects the last SESSION_LOG entry + snapshot

/go someproject                 # or switch projects explicitly:
  → cd + last log entry + CONTEXT.md, then "What are we working on?"

  ... work ...

/anti-sloppifier                # at a checkpoint: audit, diary entry

/ho                             # session end:
  → pre-flight → SESSION_LOG entry → /anti-sloppifier

# session stops
  → hook snapshots .session-handoff.md
```

## Conventions that make it work

Honest adoption cost first: the loop assumes each project lives in its own directory (ideally all under one projects root, which is what `/go` scans). If your work is scattered across a desktop of loose files, adopting the loop means adopting that structure too. In practice it looks like this:

```
~/projects/
├── health/
│   ├── SESSION_LOG.md       # the diary
│   ├── CONTEXT.md           # the profile
│   └── ...
├── fin-advice/
│   ├── SESSION_LOG.md
│   ├── CONTEXT.md
│   └── ...
└── ...
```

- **One `SESSION_LOG.md` per project directory**, at its root. No cross-project catch-all file; the SessionStart hook finds the right log by walking up from wherever you are.
- **`CONTEXT.md` is optional but useful**: a per-project file with the stable facts (what the project is, key links, current goal, constraints). You create it once; `/go` reads it alongside the log, and `/ho` refreshes it when things change. The log is the diary, CONTEXT.md is the profile.
- **Entries are newest-last** and dated `### YYYY-MM-DD`. A second `/ho` on the same day replaces that day's entry instead of duplicating it.
- **Add `SESSION_LOG.md` and `.session-handoff.md` to `.gitignore`** in repos where session history shouldn't be published (this repo does).
- **The log stays work-only.** Audit findings, coaching observations, and AI-use feedback go to the diary, never the log.

## Why not memory features?

Hooks plus markdown files are inspectable, editable, and portable. You can read exactly what next session will see, correct it, or delete it. The log doubles as a record for weekly reviews and performance write-ups. And it works the same on every machine and Claude Code version.
