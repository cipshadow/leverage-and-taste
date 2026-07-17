# Leverage and Taste: A Claude Code Setup

Automate the legwork, enhance your taste.

---

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) setup for product managers and knowledge workers: 14 slash commands, an operating-rules "constitution", and a session-continuity system that makes the 50th conversation more useful than the first.

Everything here is in daily use by its author: nothing aspirational, nothing invented for the repo. Assembled over months of real PM work (strategy docs, editorial reviews, meeting notes, feedback synthesis), drawing on Dan Shipper / Every's AI workflow principles and Claude Code community patterns.

Copy what's useful, ignore what isn't. MIT licensed.

## Philosophy

Your taste (the judgment about what to cut, what to push on, what's actually good vs. merely competent) is the thing worth protecting and developing. AI can do a lot of the legwork (research, formatting, first drafts, recaps), and it should. But the more you delegate, the more deliberate you need to be about staying in the driver's seat on the decisions that matter.

This setup does two things:

1. **Frees up your time** by automating repetitive knowledge work (session handoffs, feedback extraction, doc reviews, meeting notes).
2. **Keeps you sharp** with 22 operating rules (and an auditor command that checks whether you're following them) so you don't go passive: accepting the first draft, skipping the hard thinking, letting AI make choices you should be making.

## Quick start

Prerequisites: [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and working, plus `git`.

### The easy way (recommended)

Let Claude do its own installation. Clone the repo, open Claude Code inside it, and say:

```bash
git clone https://github.com/cipshadow/leverage-and-taste.git
cd leverage-and-taste
claude
```

> Install this setup for me, following AGENTS.md. Ask me for anything you need.

Claude handles the fiddly parts (merging the hooks into your settings without breaking them, merging the operating rules into any CLAUDE.md you already have, adapting for your platform) and asks you for the values marked **CONFIGURE**. Once it's done, run `/get-started` for a two-minute guided tour of the three layers and all 14 commands, ending with an offer to try one live.

### The manual way

```bash
# 1. Commands: available immediately as /name
cp commands/*.md ~/.claude/commands/

# 2. Session-continuity hooks
mkdir -p ~/.claude/hooks
cp hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
```

3. **Wire the hooks up.** If you have no `~/.claude/settings.json` yet: `cp settings.example.json ~/.claude/settings.json` and you're done. If you already have one, merge the `hooks` block from `settings.example.json` into it; if hand-editing JSON isn't your thing, this is exactly what the easy way above is for. Notes: the `afplay` sound lines are macOS-only, delete them on Linux/Windows; installing `jq` (`brew install jq` on macOS, `apt install jq` on Linux) gets you cleaner context injection, but the hook works without it.

4. **Operating rules.** If you have no `~/.claude/CLAUDE.md` yet:

```bash
cp templates/CLAUDE.md ~/.claude/CLAUDE.md
mkdir -p ~/.claude/rules
cp templates/rules/writing-style.md ~/.claude/rules/
```

If you already have a CLAUDE.md, don't overwrite it; open both files and copy over the sections you want. Either way, read the "operating rules" section below first: the constitution is opinionated, and you'll want to know what you just signed up for.

5. **Configure two files** (search for **CONFIGURE**): `~/.claude/commands/go.md` (your projects root and aliases) and `~/.claude/commands/style-review.md` (your team's style guide; generic defaults work until then).

Not ready for the full install? Start with three commands and nothing else:

```bash
cp commands/go.md commands/ho.md commands/anti-sloppifier.md ~/.claude/commands/
```

## Key concepts (if you're new to Claude Code)

| Concept            | What it means                                                                                                                                                                                   |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Slash commands** | Reusable prompts you trigger with `/name` in Claude Code. Stored as markdown files in `~/.claude/commands/`.                                                                                    |
| **CLAUDE.md**      | A file Claude Code reads automatically at the start of every session. Put rules, preferences, and context here. Lives at `~/.claude/CLAUDE.md` (global) or `<project>/CLAUDE.md` (per-project). |
| **Hooks**          | Shell scripts Claude Code runs on events (session start, session stop). This setup uses two, for session continuity.                                                                            |
| **SESSION_LOG.md** | A markdown file where `/ho` (stands for 'handoff') writes what happened each session. Next time you `/go`, Claude reads it and picks up where you left off.                                     |

## The loop

The core of this setup is a working loop, not a pile of commands:

```
session starts  → hook injects your last handoff automatically
      ↓
   do work
      ↓
/anti-sloppifier → at checkpoints (~every 10 messages): audits the session
      ↓             for AI slop, decision outsourcing
/ho             → session end: writes a structured SESSION_LOG entry
      ↓
session stops   → hook auto-snapshots a .session-handoff.md as backup
```

The loop assumes each project owns a directory under one projects root. As a real example, the author's workspace is organized like this:

```
~/projects/
├── health/                  # each project owns its own context
│   ├── SESSION_LOG.md       # the diary: what happened, session by session
│   ├── CONTEXT.md           # the profile: stable facts, links, current goal
│   └── ...                  # the actual work files
├── fin-advice/
│   ├── SESSION_LOG.md
│   ├── CONTEXT.md
│   └── ...
└── ...
```

See [docs/the-loop.md](docs/the-loop.md) for how the pieces connect and why.

## The commands

### Getting started

| Command | What it does |
|---------|-------------|
| `/get-started` | Two-minute guided tour: the three layers, all 14 commands, ends with an offer to try one live. Run once right after installing. |

### Session continuity

| Command | What it does |
|---------|-------------|
| `/go <project>` | Switch to a project and load its full context (last SESSION_LOG entry + CONTEXT.md) in one step. |
| `/ho` | End session: pre-flight checks for loose ends, writes a structured SESSION_LOG entry, chains `/anti-sloppifier`. |

### AI discipline

| Command | What it does |
|---------|-------------|
| `/anti-sloppifier` | Audits the session for AI slop, decision abdication, and thinking replacement. Scores your habits, saves a diary entry. The enforcement arm of the operating rules. |
| `/sure` | Confidence check with a human checkpoint. Assesses work honestly, waits for your input, then improves and reassesses. |
| `/ai-spend` | Audits your Claude Code token efficiency: fixed context overhead, MCP tool costs, cache hit rate, heavy skills. Reads Claude Code's local state files, so it may need tweaks as Claude Code versions change. |

### Writing review

| Command | What it does |
|---------|-------------|
| `/style-review` | 4-pass review against a style guide: mechanical → consistency → voice/craft → paragraph/flow. Numbered table of fixes. Ships with generic defaults; point it at your team's guide. |

This pairs well with Every's editorial reviewer skills (hemingway, dev-edit, panel, and friends); an earlier version of this setup shipped alongside them. They're Every's work, so get them from Every rather than here.

### Knowledge and meetings

| Command | What it does |
|---------|-------------|
| `/feedback` | Structured feedback database. Paste a quote, thread, or doc → validated entries in one markdown table. Query with `search`, `themes`, `user`, `recent`, `stats`. (Prefer typing `/fb`? Rename the file to `fb.md`: the filename is the command name.) |
| `/call-notes` | Transcript in (pasted or file path), structured notes out: decisions, action items, open questions. Cross-links to the projects it mentions. |

### Content production

| Command            | What it does                                                                                                                 |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| `/one-pager`       | Create a product & engineering one-pager from a template, or review an existing one against a completeness rubric.           |
| `/pretty-slides`   | Polished single-file HTML slide decks in 6 visual styles, from a doc, URL, or pasted content.                                |
| `/slackify`        | Makes text cleanly pastable into Slack (strips artificial line breaks, fixes formatting).                                    |
| `/tidy`            | Points at a folder: renames vague files, finds duplicates and accidental secrets, proposes fixes, executes only on approval. |
| `/context-refresh` | Weekly upkeep for a hub-and-spoke context folder (`CLAUDE.md` + `context-map.md` + a root or `_inbox/` drop zone + `INDEX.md` files). Runs `/tidy`'s scan, files anything untriaged, repairs every cross-reference a rename broke, and flags stale or conflicting docs for a human call. Pairs with the `inbox-nudge.sh` hook, which nudges at session start when a watched folder's root has untriaged files. |

## The operating rules (templates/CLAUDE.md)

The constitution for how Claude behaves in your sessions. Claude Code reads it automatically at session start, so everything in it applies to every conversation without repeating yourself.

Three layers:

1. **AI-Use Discipline**: 22 principles for staying in the driver's seat. State your view first, the slop test, evidence vs. inference labels, the 10x delegation filter, proactive naivety checks, and more.
2. **Taste & Judgment Development**: 5 rules for developing (not losing) editorial judgment while using AI: articulate why every time you steer, never accept the first structure, own the finishing pass.
3. **Working preferences**: writing patterns to avoid, accuracy requirements (`[VERIFY]`/`[NEED]`/`[PLACEHOLDER]` markers), self-learning instructions.

**Fair warning: as shipped, it's maximal.** The "Mandatory" section makes Claude interview you (5+ questions) before any task with assumptions, and forbids generating docs from scratch. That's deliberate friction (it's the point of the setup), but if you adopt the whole file without reading it, you'll wonder why Claude suddenly answers everything with questions. You don't need all of it. The rules work individually. Start with 3-4 that address your biggest pain point with AI, then add more as you notice new failure modes. `/anti-sloppifier` is the enforcement arm: it audits your sessions against these rules.

## Optional integrations

None of the commands require MCP connectors; everything falls back to pasted text or local files. If you have connectors set up, some commands use them: `/feedback` can fetch Slack threads and docs, `/call-notes` can pull transcripts from a meetings tool, `/style-review` can fetch and edit cloud docs.

## File structure

```
.
├── README.md               # You are here
├── AGENTS.md               # Instructions for AI agents installing this setup
├── settings.example.json   # Hook wiring + a minimal read-only allow-list
├── templates/
│   ├── CLAUDE.md           # The operating rules (adapt, then adopt)
│   └── rules/writing-style.md
├── commands/               # 14 slash commands (flat, 1:1 with ~/.claude/commands/)
├── hooks/
│   ├── session-log-reader.sh    # SessionStart: injects last handoff as context
│   └── session-handoff-writer.sh # Stop: auto-snapshots session state
├── docs/
│   ├── the-loop.md         # How the session system connects
│   └── sync.md             # How this repo stays in sync with a live setup
└── scripts/drift.sh        # Diff your live ~/.claude against this repo
```

## Adapting for your use

- Files marked **CONFIGURE** need your values before use: `go.md` (projects root), `style-review.md` (style guide), `ai-spend.md` (your MCP servers and context files).
- All commands are self-contained markdown files; edit them freely.
- Per the constitution's own rule 17: when a command gets something wrong, fix the command file, not just the output. The setup should compound.

## Credits and influences

- Thanks to the Claude Code community and to Every.to/Dan Shipper for his content and inspiration over the years!

## License

MIT. Use however you want.
