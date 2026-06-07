# System Design — How All the Pieces Fit Together

## The Three Layers

```
┌─────────────────────────────────────────────────────┐
│                    WIKI LAYER                         │
│   Domain knowledge. Reusable across all projects.    │
│   wiki/ with confidence tags, cross-references,      │
│   source citations. Maintained by /wiki commands.    │
└─────────────────────┬───────────────────────────────┘
                      │ knowledge flows UP
┌─────────────────────┴───────────────────────────────┐
│                   PROJECT LAYER                       │
│   Per-project working memory.                        │
│   projects/<name>/SESSION_LOG.md + CONTEXT.md        │
│   + MEETINGS.md + any project-specific files         │
└─────────────────────┬───────────────────────────────┘
                      │ evidence flows DOWN
┌─────────────────────┴───────────────────────────────┐
│                  EVIDENCE PIPELINE                    │
│   /my-week → WORK_LOG.md                            │
│   /my-month → CONTRIBUTIONS_LOG.md                  │
│   [optional: /my-review → review evidence]          │
└─────────────────────────────────────────────────────┘
```

## Session Continuity System

```
Session N ends:
  ├── /ho writes rich entry to SESSION_LOG.md
  ├── Stop hook auto-saves .session-handoff.md (fallback)
  └── /coach writes diary entry to diary/

Session N+1 starts:
  └── SessionStart hook reads SESSION_LOG.md + .session-handoff.md
      → Injects last entry as context automatically
```

**Key insight:** The hooks provide a safety net. Even if you forget to run /ho, the Stop hook captures git state. The Start hook always loads the last session.

## Evidence Pipeline

```
Weekly:  /my-week scans calendar + git + files + sessions
         → validates with user → saves to WORK_LOG.md

Monthly: /my-month reads WORK_LOG.md
         → deduplicates + aggregates → CONTRIBUTIONS_LOG.md

Review:  Read CONTRIBUTIONS_LOG.md
         → map to capability dimensions → review evidence
```

## Feedback Loop

```
User gives feedback → /fb extracts structured entry
                    → saves to feedback/FEEDBACK.md
                    → queryable via /fb search|themes|stats
```

## Knowledge Compound Loop

```
New source arrives → /wiki ingest → creates/updates pages
                                   → adds cross-references
                                   → flags contradictions

Session produces knowledge → /ho triggers auto-ingest
                           → scans for new domain facts
                           → updates wiki if found

Weekly recap → /my-week triggers:
              ├── wiki auto-ingest (new knowledge)
              ├── competitor-watch (competitive intel)
              └── feedback scan (user signals)
```

## Folder Structure

```
~/brain-extension/              # Main workspace (or wherever you keep it)
├── CLAUDE.md                   # AI operating rules
├── SESSION_LOG.md              # Cross-project session history
├── WORK_LOG.md                 # Weekly contributions (/my-week output)
├── CONTRIBUTIONS_LOG.md        # Monthly aggregate (/my-month output)
├── .my-week-last-run           # Marker file: last /my-week date
├── .zoom-sync-state.md         # Marker: synced Zoom meeting IDs
├── .session-handoff.md         # Auto-saved by Stop hook
│
├── projects/
│   ├── project-a/
│   │   ├── SESSION_LOG.md      # Project-specific session history
│   │   ├── CONTEXT.md          # What matters now (updated each session)
│   │   └── MEETINGS.md         # Links to relevant meeting notes
│   └── project-b/
│       └── ...
│
├── meetings/                   # Central meeting notes (all projects)
│   ├── 2026-06-01-weekly-sync.md
│   └── 2026-06-03-design-review.md
│
├── feedback/
│   └── FEEDBACK.md             # Structured feedback table
│
├── diary/                      # AI-use coaching entries (/coach output)
│   ├── 2026-06-01.md
│   └── 2026-06-07.md
│
└── wiki/                       # Domain knowledge base
    ├── CLAUDE.md               # Wiki schema (from wiki-schema/)
    ├── index.md                # Page catalog
    ├── log.md                  # Chronological record
    ├── _sources-registry.md    # Source tracking
    ├── concepts/
    ├── products/
    ├── market/
    ├── strategy/
    ├── technical/
    ├── operations/
    ├── research/
    ├── raw/                    # Immutable source material
    │   └── assets/
    └── outputs/                # Generated reports
```

## Routing Rules

Session logs route by TOPIC, not working directory:

| If the session was about... | Update this log |
|----------------------------|-----------------|
| Project A | `projects/project-a/SESSION_LOG.md` |
| Project B | `projects/project-b/SESSION_LOG.md` |
| Cross-project or tooling | Root `SESSION_LOG.md` |

If a session spans multiple projects, update each relevant log with what pertains to it.

## Hook Configuration

In `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [{
      "hooks": [{
        "type": "command",
        "command": "~/.claude/hooks/session-log-reader.sh"
      }]
    }],
    "Stop": [{
      "hooks": [
        { "type": "command", "command": "afplay -v 0.5 /System/Library/Sounds/Submarine.aiff" },
        { "type": "command", "command": "~/.claude/hooks/session-handoff-writer.sh" }
      ]
    }],
    "Notification": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "afplay -v 0.5 /System/Library/Sounds/Blow.aiff"
      }]
    }]
  }
}
```

## Skill Dependency Graph

```
/ho (session end)
 ├── pre-flight checks (git, temp files, open loops)
 ├── writes SESSION_LOG.md entry
 ├── triggers /coach (AI-use self-audit)
 └── triggers wiki auto-ingest (if new domain knowledge)

/my-week (weekly recap)
 ├── gathers: calendar + git + files + sessions
 ├── validates with user
 ├── saves WORK_LOG.md
 ├── triggers wiki auto-ingest
 ├── triggers /competitor-watch
 └── triggers /fb scan (feedback extraction)

/my-month (monthly aggregate)
 ├── reads WORK_LOG.md
 ├── deduplicates and synthesizes
 └── saves CONTRIBUTIONS_LOG.md

/sure (confidence check)
 ├── spawns fresh agent for cold review
 ├── waits for user input
 ├── executes approved improvements
 └── reassesses honestly

/go (project switch)
 └── loads SESSION_LOG + CONTEXT.md in parallel
```

## Key Design Principles

1. **Route by topic, not directory.** Working directory is irrelevant; what matters is what you worked on.

2. **Hooks as safety net.** The Stop hook always fires, so session context survives even without explicit handoff.

3. **Validate before writing.** Every skill that writes permanent data (feedback, wiki, work log) presents findings and waits for approval first.

4. **Knowledge compounds.** Wiki, feedback, work logs all persist. Each session adds to the base rather than starting fresh.

5. **Pipeline architecture.** Raw weekly data → deduplicated monthly → quarterly evidence. Each layer serves a different purpose.

6. **Separation of concerns.** Wiki = domain knowledge. Projects = operational state. Diary = AI-use reflection. Feedback = user signals. They don't mix.

7. **Start janky, polish later.** New workflows start as simple markdown files with manual triggers. Only automate after confirmed use.
