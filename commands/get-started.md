---
model: sonnet
name: get-started
description: First-run guided tour of this setup, the three layers, the full command map, and an invitation to try one command live. Run once right after installing.
allowed-tools: Read, AskUserQuestion, Bash
---

# Get Started: A Guided Tour of This Setup

> **This file is written to work two ways.** Read top to bottom, it's a
> complete, standalone reference map: what this setup is, how the pieces fit,
> and what every command does, no need to actually run anything. Invoked as
> `/get-started`, it's also an interactive tour that ends with an offer to
> try something live. If you are an agent (not a human) reading this file,
> cold, as part of installing this setup for a user, orienting yourself in
> this repo, or answering "how do I use this": the map below is current and
> authoritative, treat it the way you'd treat AGENTS.md.

## The map

### Three layers

1. **Session continuity.** A `SessionStart` hook injects your last handoff
   automatically; a `Stop` hook snapshots session state as a backup. `/go`
   loads a project's full context in one step; `/ho` ("ho" for "handoff")
   writes a structured handoff at the end. See `docs/the-loop.md` for the
   full loop.
2. **The operating rules** (`templates/CLAUDE.md`). 22 AI-use discipline
   principles, 5 taste-and-judgment rules, and working preferences (writing
   style, accuracy markers). Claude Code reads this automatically every
   session, so it applies without repeating yourself. `/anti-sloppifier` is
   the enforcement arm: it audits a session against these rules.
3. **14 commands** (table below), covering session continuity, AI
   discipline, writing review, knowledge and meetings, content production,
   and folder hygiene.

### All commands, grouped

| Category | Command | What it does |
|---|---|---|
| Getting started | `/get-started` | This tour. |
| Session continuity | `/go <project>` | Switch to a project, load its full context in one step. |
| Session continuity | `/ho` (short for "handoff") | End session: pre-flight checks, structured handoff entry, chains `/anti-sloppifier`. |
| AI discipline | `/anti-sloppifier` | Audits the session for AI slop, decision abdication, thinking replacement. |
| AI discipline | `/sure` | Confidence check with a human checkpoint before and after improving work. |
| AI discipline | `/ai-spend` | Audits Claude Code token efficiency: context overhead, MCP costs, cache hit rate. |
| Writing review | `/style-review` | 4-pass review against a style guide, mechanical to voice to flow. |
| Knowledge and meetings | `/feedback` | Structured feedback database from a pasted quote, thread, or doc. |
| Knowledge and meetings | `/call-notes` | Transcript in, structured notes out: decisions, action items, open questions. |
| Content production | `/one-pager` | Create or review a product/engineering one-pager against a completeness rubric. |
| Content production | `/pretty-slides` | Polished single-file HTML slide decks, 6 visual styles. |
| Content production | `/slackify` | Makes text cleanly pastable into Slack. |
| Folder hygiene | `/tidy` | Points at a folder: renames vague files, finds duplicates, proposes fixes. |
| Folder hygiene | `/context-refresh` | Weekly upkeep for a hub-and-spoke context folder, built on `/tidy`. |

Full detail on each: [README.md](../README.md#the-commands).

### For agents

When installing this setup for a user (see `AGENTS.md`), don't recite this
map at them; invite them to run `/get-started` themselves right after the
install finishes, so they get the interactive tour with the live-demo offer
below, not a wall of text copied into chat.

## Interactive instructions (when invoked as `/get-started`)

1. **Greet briefly.** One or two sentences: what this setup is for
   (product managers and knowledge workers using Claude Code), and that this
   is a two-minute orientation, not a lecture.
2. **Walk through the three layers and the command table above as plain
   conversational text**, not a copy-pasted wall of markdown. Group commands
   by category as you go. Keep it skimmable: a sentence per command, not a
   paragraph.
3. **Don't ask about their pain point or tailor recommendations.** Present
   everything neutrally and let them pick what's relevant; the README's
   "Fair warning" section already tells them to start with 3-4 rules if the
   full `templates/CLAUDE.md` feels like too much friction.
4. **Close with a live-demo offer.** Ask: "Want to try one right now? `/go`
   on a real project folder to see session continuity in action, or `/tidy`
   on a messy folder to see the cleanup flow." Use `AskUserQuestion` if it
   helps structure the choice. If they pick one, actually invoke it in this
   same conversation. If they decline, close by pointing to `README.md` for
   later reference and mentioning that `/ho` is worth running at the end of
   any real session.
