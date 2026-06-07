---
description: Aggregate the last month of weekly recaps from WORK_LOG.md into deduplicated, outcome-focused contributions by project.
user-invocable: true
model: sonnet
---

# /my-month — Monthly Contributions Aggregator

Middle layer between `/my-week` (raw weekly data) and performance review evidence.

## Step 1: Determine the month

Ask: "Which month? (e.g., March 2026, or 'last 4 weeks')"
Default to the last 4 calendar weeks if not specified.

## Step 2: Read inputs

**Work log entries:** Read `WORK_LOG.md` and extract all weekly entries within the requested month.

**Existing contributions log:** Read `CONTRIBUTIONS_LOG.md` if it exists, to avoid duplicates.

## Step 3: Deduplicate and aggregate

The key job is collapsing repeated work into single entries:

**Same doc across multiple weeks → one entry:**
"Iterated on Pricing Blueprint over 3 weeks: drafted initial model, incorporated feedback, got approval ([doc](url))"

**Same project theme across weeks → one narrative:**
Synthesize into a coherent arc rather than listing each week separately.

**Meetings → only mention if they drove a decision or outcome:**
"Led 3 user calls resulting in [outcome]"

**Slack/comms → only capture decisions and actions:**
"Coordinated with X on Y, resulting in Z."

## Step 4: Output format

```markdown
## Contributions: [Month Year]

### [Project A]
- [Outcome-focused sentence with links]
- [Another contribution]

### [Project B]
- ...

### Cross-cutting / Other
- ...

### By the Numbers (month total)
- X docs/files created or modified
- X meetings/calls
- X commits/PRs
- X Claude Code sessions · ~X hrs saved

---
```

**Writing rules:**
- First person ("I led...", "Got approval on...")
- Every entry must have at least one link where possible
- Quantify where possible
- Each entry = one sentence, max two
- Note multi-week arcs: "over 2 weeks", "across 3 iterations"

## Step 5: Present and save

Present for review, then:

1. Write to `MONTHLY_CONTRIBUTIONS_DRAFT.md` (overwritten each run)
2. Append to `CONTRIBUTIONS_LOG.md` (permanent, most recent month at top)

**Overwrite rule:** If same month already exists in CONTRIBUTIONS_LOG.md, replace it.

Ask: "Anything to adjust before I save?"
