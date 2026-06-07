---
description: Run a deep competitive analysis for a product area. Searches web, docs, and any available internal sources in parallel. Builds a feature comparison matrix and produces a leadership-ready document.
argument-hint: <product area, e.g. "AI writing tools", "expense management", "video transcription" — competitors optional>
user-invocable: true
---

# Competitor Analysis

Deep competitive research across all available sources. Works for ANY product area and ANY set of competitors.

## Input Parsing

Extract from user's argument:
- **Product area** (e.g., "AI writing tools", "expense management", "video editing")
- **Competitors** (named providers; if none given, discover them in Phase 0)
- **Scope**: full analysis (default), add competitor, refresh existing, single deep-dive

## Before starting research, ask:

1. **Audience:** Who reads this? (investors, team, potential partners, just you)
2. **Scope:** Full analysis or single competitor deep-dive?
3. **Dimensions:** Beyond features — pricing? GTM? regional? roadmap?
4. **Existing work:** Any prior analysis to build on?

## Phase 0: Competitor Discovery

If competitors not named:
1. Web search for main players
2. Check any internal docs or notes
3. Present shortlist of 4-8 likely competitors for confirmation

## Phase 1: Research (parallel)

For each confirmed competitor, run simultaneously:
- **Web search:** product pages, pricing, changelogs, blog posts
- **Review sites:** G2, Capterra, TrustRadius ratings and reviews
- **Tech press:** recent coverage, funding announcements, launches
- **Job listings:** what they're hiring for (signals roadmap)
- **Social/community:** Reddit, Twitter/X, HackerNews sentiment

## Phase 2: Build comparison matrix

| Capability | Us | Competitor A | Competitor B | ... |
|-----------|-----|-------------|-------------|-----|
| [Feature] | [status] | [status] | [status] | ... |

Status options: shipped, beta, announced, not available, unknown.

## Phase 3: Cross-reference and fact-check

- Mark confidence: [V] verified from their docs, [M] from reviews/press, [?] unconfirmed
- Flag claims that conflict between sources
- Note what you COULDN'T find (gaps in knowledge)

## Phase 4: Produce document

```markdown
# Competitive Analysis: [Product Area]

**Date:** [today] | **Author:** [user] | **Scope:** [full/deep-dive/refresh]

## Executive Summary
[3-5 sentences: who's winning, where, and what it means for us]

## Feature Comparison Matrix
[The table from Phase 2]

## Competitor Profiles

### [Competitor A]
- **Positioning:** [how they describe themselves]
- **Strengths:** [what they do well]
- **Weaknesses:** [gaps, complaints, limitations]
- **Pricing:** [model and numbers if available]
- **Recent moves:** [last 6 months of changes]
- **Trajectory:** [growing/flat/declining, hiring signals]

[Repeat for each competitor]

## Pricing Intelligence
[Comparison table if data available]

## Strategic Implications
- [What this means for our product decisions]
- [Where we're differentiated]
- [Where we're behind and it matters]
- [Where we're behind and it doesn't matter]

## Gaps in This Analysis
- [What we couldn't verify]
- [Sources we'd need for better data]
```

## Rules

- Never present unverified claims as facts
- Always note the source and confidence level
- Include "Gaps" section honestly
- Quantify wherever possible (pricing, user counts, growth rates)
- Update existing analysis docs rather than creating duplicates
- Save output to a permanent location in the project folder
