---
description: Summarize all work done since the last recap across calendar, local files, git, and session logs. Validates with the user before saving.
user-invocable: true
model: sonnet
---

# /my-week — Weekly Work Recap

Summarize all work done since the last recap. After validation, save to `WORK_LOG.md`.

---

## Accuracy Rules (apply throughout)

1. **Only report what sources explicitly confirm.** Never infer or embellish.
2. **Never invent meetings, attendees, or outcomes.**
3. **Dates must be verified** from their source.
4. **Mark uncertainty** with `[?]` rather than guessing.
5. **No inflation.** "Touched a doc" is not "authored a strategy paper."

---

## Phase 1: Setup

### Step 1: Determine the recap period

1. Read `.my-week-last-run` to get the last run date. If missing, default to 7 days ago.
2. Period: `[last_run_date + 1 day]` through today.
3. Confirm with user: "Covering [start] to [today]. Change the range?"

Wait for confirmation.

### Step 2: Accept additional input

Ask: "Anything specific you want me to capture that might not show up in automated scans? (e.g., a conversation, a decision, something shipped) Or type 'skip'."

---

## Phase 2: Data Gathering

Fire ALL of the following simultaneously. Do not present results yet.

### Calendar events
Fetch events for the period. Skip: self-holds (lunch, focus time, busy blocks), routine syncs/standups, declined events. Include: ad-hoc topic meetings, external calls, reviews.

### Local file changes
```bash
find ~/Desktop/vibes -type f -name "*.md" -newer <start-date-reference> \
  ! -path "*/node_modules/*" ! -path "*/.git/*" \
  ! -name "WORK_LOG.md" ! -name ".my-week-last-run" | sort
```
For each: note path, modification date, read first 50 lines to understand content.

### Git activity
For each project with a git repo:
```bash
git log --oneline --after="<start-date>" --author="$(git config user.name)"
```

### Session logs
Find all SESSION_LOG.md files:
```bash
find ~/Desktop/vibes -name "SESSION_LOG.md" | sort
```
Read the last ~200 lines of each. Extract entries within the recap period.

### Claude Code usage (from session logs)
For each session entry, extract:
- What task was delegated to Claude Code
- Which project
- Output/artifact produced
- Estimated time saved (rough: "~30 min", "~2 hrs")

---

## Phase 3: Validation Checkpoint

### Step 3a: Present raw findings

**Do NOT write any markdown output yet.** Present as:

```
I found [N] items across [M] projects:

**[Project A]** (X items)
1. [verb] [thing] ([source: Calendar/Git/Session log/File change]) [date]
2. ...

**Uncategorized** (X items)
N. [thing] ([source]) [date] — [?] not sure which project

**Claude Code usage** (X sessions)
- [date] [project] — [task] → [artifact] (~[time saved])

---
Anything wrong? Items to remove? Things I missed?
```

### Step 3b: Wait for user response

Do NOT proceed until the user confirms, corrects, or removes items.

---

## Phase 4: Write the output

Only after confirmation.

### Format

```markdown
## [Start date] — [End date]

### Summary

[Outcome-focused bullets grouped by project. First person. 3-5 bullets per project.]

### Contributions log

#### [Project Name]
- **Meetings:** Meeting title (Day; attendees) · Another (Day; attendees)
- **Docs:** Doc Name ([link](url))
- **Git:** [commits/PRs with links]
- **Local writing:** [file] — [what was written/updated]

#### Claude Code usage

| Date | Project | Task delegated | Output / Artifact | Est. time saved |
|------|---------|----------------|-------------------|-----------------|
| ... | ... | ... | ... | ... |

#### By the Numbers
- X local files created/updated
- X commits across Y repos
- X meetings attended
- X Claude Code sessions · ~X hrs saved
```

---

## Phase 5: Save

1. Write to `WEEKLY_RECAP_DRAFT.md` (overwritten each run)
2. Append to `WORK_LOG.md` (permanent record; replace if same date range exists)
3. Write today's date to `.my-week-last-run`

---

## Phase 6: Wrap-up

```
Done. Saved to WORK_LOG.md covering [dates].
```
