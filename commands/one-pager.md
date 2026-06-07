---
description: Create a new product one-pager, or review and improve an existing one against best practices.
argument-hint: <initiative name to create new> or <doc URL/path to review existing>
user-invocable: true
---

# One-Pager — Product Brief Creator & Reviewer

Two modes: **create** a new one-pager, or **improve** an existing one with structured feedback.

---

## Mode detection

- If $ARGUMENTS looks like a URL, doc ID, or file path → **Improve mode**
- If $ARGUMENTS is a name or initiative description → **Create mode**
- If empty → ask: "Create a new one-pager or review an existing one?"

---

## Create mode

### Step 1: Interview (MANDATORY)

Ask at least these questions before writing anything:
1. What's the initiative/feature name?
2. Who's the audience for this doc? (leadership, team, cross-functional partners)
3. What problem does this solve? Who feels the pain?
4. Why now? What changed that makes this urgent?
5. What's the scope? What's explicitly out?
6. What decision do you need from the reader?

### Step 2: Draft structure

```markdown
# [Initiative Name] — One-pager

**DRI:** [name] | **Status:** Draft | **Last updated:** [date]

## Goal of this document
- [Specific decision needed from reader]
- Next steps: [what happens after approval]

## Problem & opportunity
[Why this matters. Quantified pain. Who feels it.]

## Why now
[What changed. Market signal, dependency unlocked, deadline.]

## Target users
[Who benefits. Segment and size.]

## Proposed solution
[What we'll build. Scope boundary.]

## Success metrics
| Metric | Current | Target | How measured |
|--------|---------|--------|-------------|

## Rollout plan
[Phases, pause conditions, ramp strategy]

## Risks & mitigations
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|

## Open questions
- [Unresolved items]
```

### Step 3: Fill in with user's input

Populate using the interview answers. Mark gaps with `[NEED: ...]`.

---

## Improve mode

Read the doc, evaluate against the rubric, output structured feedback, then offer to apply fixes.

### Rubric

**Tone:** Be constructive. Lead with what's working. Prioritize the 2-3 highest-leverage changes. Don't flag minor issues.

Score each as **Strong**, **Good start**, or **Worth adding**:

**1. Problem before solution**
Does the doc spend real time on the problem before proposing anything? The reader should feel the problem is undeniable before seeing the solution. Look for: clear description, who experiences it, concrete example or data point.

**2. Why now**
Could this have been written six months ago or six months from now? If yes, the "why now" is missing. Look for: competitive moves, market shifts, dependency unlocked, approaching deadline.

**3. Summary above the fold**
Someone skimming should understand the recommendation without reading further. Detailed analysis lives below.

**4. Recommendation first, evidence second**
State what you think should happen, then prove it. Don't make the reader assemble paragraphs into a conclusion.

**5. Success criteria**
How will you know it worked? Measurable outcomes with current state and target state.

**6. Explicit scoping**
What's in and what's out? Prevents scope debates later.

**7. Risks acknowledged**
Are risks named honestly with mitigations? Or is the doc purely optimistic?

**8. Quantified impact**
Is the opportunity sized in dollars, users, or another concrete metric? "Many users want this" is not enough.

### Output

For each criterion: the rating, one-line explanation, and (if not Strong) a specific suggestion for improvement.

Then offer: "Want me to apply these improvements to the doc?"
