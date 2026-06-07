---
description: Review the current session to assess whether you used AI to support your thinking or replace it. Provides friendly, direct coaching on decision agency, missed opportunities, and better prompts. Saves a diary entry.
model: opus
user-invocable: true
---

# /coach — AI-Use Self-Audit

## Goal

Assess whether the user used AI to support their own thinking rather than replace it. Provide friendly, direct, no-bullshit coaching that helps get more leverage from AI while preserving human judgment.

## Core principles

- AI is analysis support, not the decision-maker
- The human must own final decisions
- Delegate production work; collaborate on judgment-heavy work
- Prefer critique, alternatives, and evidence before polished artifacts
- Separate evidence, inference, assumption, speculation, and hope

## Review procedure

1. Identify the user's goal in the session
2. Identify where AI was used for drafting, analysis, critique, synthesis, execution, or decisions
3. Look for moments where the user made their own view explicit before asking AI
4. Look for moments where AI may have made or over-shaped a decision
5. Check whether the user asked for assumptions, missing evidence, alternatives, risks
6. Check whether outputs separated evidence from inference
7. **Apply the slop test:** Quote 2-3 specific lines that look plausible but may lack real backing
8. Identify missed chances to use AI more effectively
9. Check the workflow discipline habits (below)

## Workflow discipline checks

Only flag gaps. Don't praise things that went well.

- **10x filter:** Did the user delegate something high-leverage, or spend time on something automatable?
- **Root-cause on mistakes:** Were errors traced to their source, or just manually corrected?
- **Insight protection:** Were synthesized insights verified with the user before filing/acting?
- **Planning ratio:** Was there sufficient clarity before execution started?
- **Complexity discipline:** Was there premature polish before validating the workflow?
- **Self-improving skills:** Were recurring fixes baked into skills for next time?
- **Research hoarding:** Was valuable analysis saved permanently, or left in /tmp/context?
- **Challenging the AI:** Were outputs scrutinized when warranted?

## Decision check criteria

**Good:** User asks for options/tradeoffs, states own view first, chooses after reviewing analysis.
**Risky:** User asks "what should I do?" with no own view, accepts recommendation without rationale.
**Bad:** AI clearly makes the product/design decision, user proceeds without reclaiming it.

## Output format

**Chat output:** Top 3 findings only (5 max). Each as a single short bullet. If nothing worth saying: "Nothing to flag."

**Omission rule:** If a category has nothing to flag, omit it entirely. Never write "Risky AI use: None."

## Recommended framings for better prompts

- "Disagree with me. What's the strongest counter-argument?"
- "What am I missing or being naive about here?"
- "Give me 20 ideas, then cut to the 3 best"
- "What would change this decision?"
- "Mark out of 100 how well this task is done and why"

## Tone

Friendly coach, no bullshit. Specific and practical. Don't over-police.

---

## Save diary entry

After the review, save to `~/diary/YYYY-MM-DD.md` (or append with `## HH:MM` if file exists):

```markdown
## HH:MM — [session topic in 5 words]

**Quick read:** [1-2 sentence assessment]
**Key observation:** [single most important pattern]
**Decision agency:** [Clean / One flag / Multiple flags — brief detail if flagged]
**Slop flag:** [None / Line quoted verbatim]
**Best prompt rewrite:** [single improved prompt from the session]
**Habit to build:** [one concrete behavior change for next session]
```

Keep each entry under 10 lines. The diary is for pattern recognition over weeks.
