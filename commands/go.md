---
description: Switch to a project directory and load its full context. Use at the start of a session to pick up where you left off.
argument-hint: <project name or alias>
user-invocable: true
model: sonnet
---

Switch to a project directory and load its full context.

**Argument:** $ARGUMENTS (project name or alias)

## Project Directory Map

Maintain a table mapping short names/aliases to directory paths. Example:

| Name / Alias | Directory |
|-------------|-----------|
| `digitalshelf`, `ds` | `~/Desktop/vibes/digitalshelf/` |
| `tubefilter`, `tf` | `~/Desktop/vibes/tubefilter/` |
| `moonwatcher`, `mw` | `~/Desktop/vibes/moonwatcher/` |
| `vibes` | `~/Desktop/vibes/` |
| `brain`, `home` | `~/brain-extension/` |

**CONFIGURE:** Update the table above with your actual projects.

## Steps

### 1. If no argument provided, list available projects
Print the table above and ask which project to switch to. Stop here.

### 2. Match the argument to a project
Match `$ARGUMENTS` against the Name/Alias column (case-insensitive). If no match, **fall back to directory discovery**:
1. `~/Desktop/vibes/$ARGUMENTS/`
2. `~/projects/$ARGUMENTS/`

If either exists, use that directory. Only if all lookups fail, suggest the closest match.

### 3. Change directory and load context in ONE step
Use Bash to `cd` into the directory AND extract the last session entry in a single command:
```bash
cd <dir> && tail -n 80 SESSION_LOG.md 2>/dev/null; echo "---EOF_SESSION---"
```
Then, in the SAME parallel call, read `CONTEXT.md` and `CLAUDE.md` using the Read tool (skip silently if missing).

**Do NOT:**
- Run Glob or ls to discover files
- Read SESSION_LOG.md with the Read tool (use the tail output above)
- Make sequential tool calls when parallel is possible

### 4. Print a summary

```
## [Project Name]
**Directory:** [path]
**Last session:** [date from SESSION_LOG]
**Goal:** [goal from last handoff]
**Pending:** [pending items from last handoff]
**How to continue:** [continuation instructions from last handoff]
```

Then ask: "What are we working on?"
