# Keeping this repo in sync with a live setup

This repo mirrors a live `~/.claude/` setup, minus everything personal. Sync is deliberate, never automatic: every file passes through a sanitize step with human review, because an auto-copy would sooner or later republish something private. (It happened once: a personal workspace CLAUDE.md shipped in the repo's own history.)

## The ritual

1. Run `scripts/drift.sh` — it diffs each shipped file against its `~/.claude/` counterpart and lists what changed.
2. For each drifted file, review the diff and re-apply that file's sanitize rules (table below) before copying it in.
3. New files in `~/.claude/commands/` that aren't in the manifest are flagged as **undecided** — triage them: include, sanitize, or exclude.
4. Before committing, run the leak check:

```bash
grep -riE 'stripe|hubble|blurple|/Users/[a-z]+|<your-employer>|<your-projects>' commands/ templates/ hooks/ docs/ README.md AGENTS.md
```

Adapt the pattern list to your own employer, project names, and paths. Zero hits or no commit.

## The manifest

What ships, what gets sanitized, what never ships. This is the contract; update it when dispositions change.

### Ships as-is

The 15 editorial roundtable commands (`asshole`, `mom`, `hemingway`, `hitchcock`, `sorkin`, `sedaris`, `vonnegut`, `eli5`, `dev-edit`, `line-edit`, `guardrails`, `debate`, `panel`, `every-review`*, `sure`), plus `anti-sloppifier`, `feedback`, `slackify`, `one-pager`, `tidy`*, `templates/rules/writing-style.md`, and both hook scripts.
(*one-line genericization applied; see below.)

### Ships sanitized

| File | Sanitize rule |
|---|---|
| `go.md` | Personal projects root and project names → `**CONFIGURE:**` placeholder |
| `ho.md` | Personal paths and the owner's name → generic |
| `call-notes.md` | Personal paths → generic; meetings-connector fetch made optional |
| `ai-spend.md` | Internal billing-tool references removed; context-file list genericized |
| `prettier-slides.md` | Employer brand color and references → neutral accent |
| `every-review.md` | Publication-specific references → generic; mechanics pass points at `/style-review` |
| `style-review.md` | Full rewrite of an employer-internal style reviewer: skeleton kept, rules replaced with generic defaults + CONFIGURE slots |
| `tidy.md` | Personal example path → generic |
| `templates/CLAUDE.md` | Personal Learned Preferences (tool-specific one-offs) removed |
| `settings.example.json` | Permissive modes (`bypassPermissions`) and personal allow-list entries removed; pinned model removed |

### Never ships

`settings.local.json`, `diary.md`, `plans/`, `history.jsonl`, `sessions/`, `projects/`, any `SESSION_LOG.md` or `.session-handoff.md`, and `cv.md` (personal shortcut). Excluded by decision: `gdrive-scan.md`, `html-to-slides.md` (connector-dependent; the repo ships core-only), `BRAIN-EXTENSION-SETUP.md` (describes a system that was never built).
