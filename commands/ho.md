---
description: End-of-session handoff. Runs a pre-flight checklist, then writes a structured entry to the relevant SESSION_LOG so the next session starts with full context.
model: sonnet
user-invocable: true
---

## Pre-Handoff Checklist

Run these checks silently. **Only report items that need action.** Omit any check that comes back clean.

**1. Uncommitted work**

Check git status in project directories:
```bash
git status --short 2>/dev/null
```
If there are uncommitted changes, list them and ask: "Commit before closing?"

**2. Temp files with useful content**
```bash
ls /tmp/*.md /tmp/*.txt 2>/dev/null
```
For any found, check if they contain session output. If so, offer to save to a permanent location.

**3. Open loops**
Review this session's conversation for any explicit "next steps", "TODO", "pending", or unresolved decisions. List them for the Pending section.

**Reporting rule:** If all checks are clean, say "Pre-flight clean." and move on. Do not list individual checks that passed.

---

## Step 1: Determine which SESSION_LOG(s) to update

Based on what was worked on this session, route to the correct log. If a project has its own `SESSION_LOG.md`, use that. Otherwise use the root-level log.

If the session spanned multiple topics, write to each relevant log (with only the content relevant to that project).

## Step 2: Write the handoff entry

Append to the bottom of each relevant SESSION_LOG:

```markdown
### YYYY-MM-DD — [Short title summarizing the session]

**Goal:** [What this session set out to accomplish]

**What we did:**
- [Concrete actions taken, with links to artifacts created/modified]
- [Decisions made: state the decision, alternatives, and why]

**Key decisions & trade-offs:**
- [Decision]: [What we chose] over [alternatives]. **Why:** [reasoning]
- [Only include if non-obvious decisions were made this session]

**Learned:**
- [Reusable pattern, technique, or insight — skip section if nothing novel]

**Pending:**
- [Unfinished work, open loops, blocked items — omit section entirely if clean]

**Files involved:**
- [Key files created or modified, with paths]

**How to continue:** [Specific instruction for a fresh Claude instance to pick up where we left off]
```

**Rules:**
- Omit any section that would just say "None" or "N/A"
- Entries go at the bottom (newest-last)
- If an entry for today's date already exists, replace it
- Save research outputs to permanent locations (don't let them evaporate)

## Step 3: Confirm

Tell the user in 2-3 lines max:
- Which log(s) were updated
- Any action items from pre-flight (or nothing if clean)
- One-line "how to continue"

## Step 4: Run /coach

After the handoff entry is written, run the `/coach` skill to do the AI-use self-audit for the session.

## Step 5: Done

Session stays open. User closes manually.
