---
description: End-of-session handoff. Runs a pre-flight checklist, then writes a structured entry to the relevant SESSION_LOG so the next session starts with full context.
model: sonnet
user-invocable: true
---

## Pre-Handoff Checklist

Run these checks silently. **Only report items that need action.** Omit any check that comes back clean.

**1. Temp files with useful content**
```bash
ls /tmp/*.md /tmp/*.txt 2>/dev/null
```
For any found, check if they contain session output. If so, offer to save to a permanent location.

**2. Open loops**
Review this session's conversation for any explicit "next steps", "TODO", "pending", or unresolved decisions. List them — they'll go into the Pending section of the log entry.

**Reporting rule:** If all checks are clean, say "Pre-flight clean." and move on. Do not list individual checks that passed. Only surface items requiring action.

---

## Step 1: Determine which SESSION_LOG(s) to update

Every real project directory owns its own `SESSION_LOG.md` at its root
(e.g. `newsletter/SESSION_LOG.md`, `home-finance/SESSION_LOG.md`).
This matches the SessionStart hook
(`~/.claude/hooks/session-log-reader.sh`), which walks up from `$PWD` looking
for the nearest `SESSION_LOG.md` — there is no cross-project catch-all file.

1. Walk up from the current working directory to find the nearest
   `SESSION_LOG.md`. If found, that's the log to update.
2. If none exists yet for this project, create one at the project root
   (the same directory as its `.git/`, or the directory you were invoked
   from if there's no repo) — see the format in Step 2 and use the same
   header pattern as any sibling project's `SESSION_LOG.md` for reference.

If the session spanned multiple project directories, update each one's own
log with only the content relevant to that project.

## Step 2: Write the handoff entry

Append to the bottom of each relevant SESSION_LOG using this format:

```markdown
### YYYY-MM-DD — [Short title summarizing the session]

**Goal:** [What this session set out to accomplish]

**What we did:**
- [Concrete actions taken, with links to artifacts created/modified]
- [Decisions made: state the decision, alternatives, and why]

**Key decisions & trade-offs:**
- [Decision]: [What we chose] over [alternatives]. **Why:** [reasoning]
- [Only include if non-obvious decisions were made this session]

**Pending:**
- [Unfinished work, open loops, blocked items — omit section entirely if clean]

**Files involved:**
- [Key files created or modified, with paths and links]

**How to continue:** [Specific instruction for a fresh Claude instance to pick up where we left off]
```

**Learnings extraction:** Before writing the entry, ask yourself: "What did we learn this session that's reusable?" If there's a pattern, technique, insight, or decision rationale that would help future sessions, include a `**Learned:**` section with 1-3 bullet points. If nothing novel was learned, skip the section. These are candidates for memory files or CLAUDE.md updates.

**Research hoarding:** If the session produced research, analysis, or exploration outputs, ensure they're saved to the relevant project folder (not just /tmp or conversation context). Research compounds; don't let it evaporate.

**Brevity rule:** Omit any section that would just say "None" or "N/A". If there are no key decisions, skip that section. If nothing is pending, skip Pending. The entry should be as short as it can be while remaining useful 3 months later.

**Exclusion rule:** Do NOT include /anti-sloppifier (AI-use self-audit) findings, feedback, or coaching observations in the session log. Those live separately in `~/.claude/diary.md`. The session log captures *work done*, not *how AI was used*.

**Overwrite rule:** If an entry for today's date already exists (matching `### YYYY-MM-DD`), replace it entirely rather than appending a duplicate.

**Newest-last:** Entries go at the bottom of the file.

## Step 2b: Update CONTEXT.md

If a CONTEXT.md exists in the project directory, update sections that changed. If none exists, skip.

## Step 3: Confirm

Tell the user in 2-3 lines max:
- Which log(s) were updated
- Any action items from pre-flight (or nothing if clean)
- One-line "how to continue"

## Step 4: Run /anti-sloppifier

After the handoff entry is written, run the `/anti-sloppifier` skill. Display its output in the chat, but do NOT save findings to the session log — they go to `~/.claude/diary.md` per the anti-sloppifier skill's own instructions.

## Step 5: Done

Session stays open. The user closes manually.
