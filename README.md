# Leverage and Taste — A Claude Code Setup

Automate the legwork, enhance your taste.

---

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) setup for product managers and knowledge workers: 26 slash commands, an operating-rules "constitution", and a session-continuity system that makes the 50th conversation more useful than the first.

Everything here is in daily use by its author — nothing aspirational, nothing invented for the repo. Assembled over months of real PM work (strategy docs, editorial reviews, meeting notes, feedback synthesis), drawing on Dan Shipper / Every's AI workflow principles and Claude Code community patterns.

Copy what's useful, ignore what isn't. MIT licensed.

## Philosophy

Your taste — the judgment about what to cut, what to push on, what's actually good vs. merely competent — is the thing worth protecting and developing. AI can do a lot of the legwork (research, formatting, first drafts, recaps), and it should. But the more you delegate, the more deliberate you need to be about staying in the driver's seat on the decisions that matter.

This setup does two things:

1. **Frees up your time** by automating repetitive knowledge work (session handoffs, feedback extraction, doc reviews, meeting notes).
2. **Keeps you sharp** with 22 operating rules — and an auditor command that checks whether you're following them — so you don't go passive: accepting the first draft, skipping the hard thinking, letting AI make choices you should be making.

## Quick start (5 minutes)

Prerequisites: Claude Code installed, `git`, and `jq` (used by one hook: `brew install jq`).

```bash
git clone https://github.com/cipshadow/leverage-and-taste.git
cd leverage-and-taste

# 1. Commands — available immediately as /name
cp commands/*.md ~/.claude/commands/

# 2. Session-continuity hooks
mkdir -p ~/.claude/hooks
cp hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# 3. Wire the hooks up: merge the "hooks" block from settings.example.json
#    into your ~/.claude/settings.json

# 4. Operating rules — read first, adapt, then merge into your own
cp templates/CLAUDE.md ~/.claude/CLAUDE.md
mkdir -p ~/.claude/rules
cp templates/rules/writing-style.md ~/.claude/rules/
```

Then configure two files (search for **CONFIGURE**):

1. `~/.claude/commands/go.md` — set your projects root and any aliases
2. `~/.claude/commands/style-review.md` — point it at your team's style guide (works with generic defaults until you do)

Not ready for the full install? Start with three commands and nothing else:

```bash
cp commands/go.md commands/ho.md commands/anti-sloppifier.md ~/.claude/commands/
```

## Key concepts (if you're new to Claude Code)

| Concept | What it means |
|---------|--------------|
| **Slash commands** | Reusable prompts you trigger with `/name` in Claude Code. Stored as markdown files in `~/.claude/commands/`. |
| **CLAUDE.md** | A file Claude Code reads automatically at the start of every session. Put rules, preferences, and context here. Lives at `~/.claude/CLAUDE.md` (global) or `<project>/CLAUDE.md` (per-project). |
| **Hooks** | Shell scripts Claude Code runs on events (session start, session stop). This setup uses two, for session continuity. |
| **SESSION_LOG.md** | A markdown file where `/ho` writes what happened each session. Next time you `/go`, Claude reads it and picks up where you left off. |

## The loop

The core of this setup is a working loop, not a pile of commands:

```
session starts  → hook injects your last handoff automatically
      ↓
   do work
      ↓
/anti-sloppifier → at checkpoints (~every 10 messages): audits the session
      ↓             for AI slop, decision abdication, thinking replacement
/ho             → session end: writes a structured SESSION_LOG entry
      ↓
session stops   → hook auto-snapshots a .session-handoff.md as backup
```

See [docs/the-loop.md](docs/the-loop.md) for how the pieces connect and why.

## The commands

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
| `/ai-spend` | Audits your Claude Code token efficiency: fixed context overhead, MCP tool costs, cache hit rate, heavy skills. |

### The editorial roundtable

Fifteen reviewers for anything you write. Run them individually, or let the conductors sequence them.

**Conductors:**

| Command | What it does |
|---------|-------------|
| `/every-review` | Full editorial workflow. Diagnoses what stage your draft is at, sequences the right reviewers in the right order, hands off to `/style-review` for final mechanics. |
| `/panel` | Convenes several reviewers at once, synthesizes their feedback into consensus findings and productive tensions. |
| `/debate` | Reviewers argue with each other across rounds until tensions resolve or reach acknowledged stalemate. |

**Craft reviewers:**

| Command | Lens |
|---------|------|
| `/dev-edit` | Big picture: argument, structure, stakes, payoff |
| `/line-edit` | Sentence- and word-level rigor |
| `/asshole` | The meanest, least charitable read. Challenges every claim. |
| `/mom` | Loving, supportive, not-quite-getting-it. Finds where you lost the general reader. |
| `/hemingway` | Cuts ruthlessly. Every adjective and adverb must justify itself. |
| `/hitchcock` | Suspense and tension. Where's the bomb under the table? |
| `/sorkin` | Pacing and momentum. Is there forward motion? |
| `/sedaris` | Finds the funny — moments minable for humor or self-deprecation. |
| `/vonnegut` | Applies Vonnegut's 8 rules for writing. |
| `/eli5` | Clarity check: jargon, hand-waving, skipped steps. |
| `/guardrails` | Scans for recurring failure patterns and second-order AI tells. |

**Mechanics:**

| Command | What it does |
|---------|-------------|
| `/style-review` | 4-pass review against a style guide: mechanical → consistency → voice/craft → paragraph/flow. Numbered table of fixes. Ships with generic defaults; point it at your team's guide. |

### Knowledge and meetings

| Command | What it does |
|---------|-------------|
| `/feedback` (`/fb`) | Structured feedback database. Paste a quote, thread, or doc → validated entries in one markdown table. Query with `search`, `themes`, `user`, `recent`, `stats`. |
| `/call-notes` | Transcript in (pasted or file path), structured notes out: decisions, action items, open questions. Cross-links to the projects it mentions. |

### Content production

| Command | What it does |
|---------|-------------|
| `/one-pager` | Create a product & engineering one-pager from a template, or review an existing one against a completeness rubric. |
| `/prettier-slides` | Polished single-file HTML slide decks in 6 visual styles, from a doc, URL, or pasted content. |
| `/slackify` | Makes text cleanly pastable into Slack (strips artificial line breaks, fixes formatting). |
| `/tidy` | Points at a folder: renames vague files, finds duplicates and accidental secrets, proposes fixes, executes only on approval. |

## The operating rules (templates/CLAUDE.md)

The constitution for how Claude behaves in your sessions. Claude Code reads it automatically at session start, so everything in it applies to every conversation without repeating yourself.

Three layers:

1. **AI-Use Discipline** — 22 principles for staying in the driver's seat. State your view first, the slop test, evidence vs. inference labels, the 10x delegation filter, proactive naivety checks, and more.
2. **Taste & Judgment Development** — 5 rules for developing (not losing) editorial judgment while using AI: articulate why every time you steer, never accept the first structure, own the finishing pass.
3. **Working preferences** — writing patterns to avoid, accuracy requirements (`[VERIFY]`/`[NEED]`/`[PLACEHOLDER]` markers), self-learning instructions.

You don't need all of it. The rules work individually. Start with 3-4 that address your biggest pain point with AI, then add more as you notice new failure modes. `/anti-sloppifier` is the enforcement arm: it audits your sessions against these rules.

## Optional integrations

None of the commands require MCP connectors — everything falls back to pasted text or local files. If you have connectors set up, some commands use them: `/feedback` can fetch Slack threads and docs, `/call-notes` can pull transcripts from a meetings tool, `/style-review` can fetch and edit cloud docs.

## File structure

```
.
├── README.md               # You are here
├── AGENTS.md               # Instructions for AI agents installing this setup
├── settings.example.json   # Hook wiring + conservative permissions
├── templates/
│   ├── CLAUDE.md           # The operating rules (adapt, then adopt)
│   └── rules/writing-style.md
├── commands/               # 26 slash commands (flat, 1:1 with ~/.claude/commands/)
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

- Dan Shipper / Every — AI workflow principles (articulate before delegating, the slop test) and the editorial-personas idea
- Claude Code community — session continuity approaches, command patterns

## License

MIT. Use however you want.
