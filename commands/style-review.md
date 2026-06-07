---
description: Review content against a comprehensive style guide using a 4-pass architecture. Outputs a numbered table of corrections grouped by severity.
argument-hint: <paste text, file path, or Google Doc URL>
user-invocable: true
model: sonnet
---

# Style Review — 4-Pass Document Quality Check

Review content and output a numbered table of corrections.

## Input

1. **Pasted text** — review directly
2. **File path** — read the file
3. **Google Doc URL/ID** — fetch the doc

If no content provided, ask which to review.

## Review process

Run a four-pass review. Each pass catches different classes of issues.

---

### Pass 1: Mechanical checks (find-and-replace level)

Flag every instance of these violations:

**Spelling & terminology:**
- American spelling only (analyze, optimize, color — not analyse, optimise, colour)
- "ecommerce" not "e-commerce"
- "canceled/canceling" but "cancellation"

**Numbers:**
- Spell out zero through nine in prose; numerals for 10+
- % sign with numerals: 71% (not "71 percent")
- $ before numbers: $5 billion, $370K (K/M/B/T uppercase)
- Commas in numbers over three digits: 1,000
- En dash for ranges: $5–$10, 60–70% (not hyphen)
- Spell out numbers starting a sentence (unless a year)
- If you see "significant," "many," or "meaningful" — flag it and ask for a number

**Punctuation:**
- Oxford comma always: x, y, and z
- Em dash (—) without spaces; max twice per paragraph
- En dash (–) for ranges, no spaces
- Periods and commas inside quotation marks
- No exclamation points
- Don't use slashes: rewrite "and/or", "risk/reward"
- No terminal punctuation in headers (except question marks)

**Formatting:**
- Sentence case for everything (NOT title case)
- Don't use bold for emphasis — recast the sentence
- Don't use italics for emphasis — recast the sentence
- American date format: October 15, 2018 (no ordinals)
- Abbreviations: no periods (US, EU, UK)
- Tables only for genuinely columnar data

**Links:**
- Descriptive link text (2–4 words); never "click here"
- Every number should link to its source when possible

**Lists:**
- Period for complete sentences; no punctuation for fragments
- Parallel structure across all items
- Numbered lists only when order matters
- Start items with capital letters

---

### Pass 2: Consistency checks (whole-document level)

**Tense consistency** — don't drift between past/present/future within a section.

**Pronoun consistency** — if "we" is used for the team, don't switch to "the team" mid-paragraph.

**Subject consistency in lists** — all bullets should use the same grammatical form.

**Capitalization consistency** — product names and terms must be capitalized identically throughout.

**Number formatting consistency** — don't spell out "three" in one paragraph and use "3" in the next.

**Abbreviation consistency** — define on first use, then use abbreviation everywhere after.

**Bullet punctuation consistency** — if one list uses periods, all lists do.

**Grammar:**
- Subject-verb agreement
- Dangling modifiers
- Comma splices
- Run-on sentences (flag if >35 words for splitting)

---

### Pass 3: Voice and craft (sentence-level)

**Voice & tone:**
- Plain, confident, matter-of-fact. No corporate speak.
- "We" for the team. Never passive "it was decided."
- Confident about the future: "we will," never "we might" or "we hope to consider"
- No hedging when not uncertain: "I think", "perhaps", "maybe"
- No filler: "actually", "very", "just", "basically", "essentially"
- No throat-clearing: "It's important to note that..."
- No filler transitions: "Turning now to," "Another important area is"
- Avoid starting sentences with "This" — be specific about the referent
- Avoid "in order to" — just use "to"
- Active voice always

**Argument quality:**
- Lead with observed reality, then derive the strategic claim
- Every section should close with the "so what"
- Unvalidated numbers: `[brackets]`. Missing data: `[NEED: ...]`.

**Sentence craft:**
- Vary sentence length: long explanatory, then short declarative
- Cut words that don't add meaning (but keep implications and reasoning)
- If a sentence exceeds ~30 words, consider splitting

---

### Pass 4: Paragraph and flow quality (whole-paragraph rewrites)

For each issue, provide the current text AND a full rewritten version. Don't change semantics.

**Check for:**
- Sentence overloading (every sentence packs 2-3 ideas)
- Restating the section title in the opening sentence
- Meta-narration ("Below we describe," "Our work interweaves")
- Word repetition (same noun 3+ times in one sentence)
- Orphan paragraphs between sections
- Missing transitions between major sections
- Dense explanation blocks (5+ lines) interrupting flow
- Cliches used as structural devices
- Duplicate words from editing artifacts

---

## Output format

Present results as a numbered table:

```
| # | Pass | Location | Issue | Original | Suggested fix |
|---|------|----------|-------|----------|---------------|
| 1 | P1 | Section, para | Brief description | "exact text" | "corrected text" |
```

Group by pass: Mechanical → Consistency → Voice → Paragraph/Flow.

After the table:
- **Recurring issues:** Patterns that appear multiple times
- **Not flagged (by design):** Style rules skipped because they don't apply to this doc type

## Applying fixes

If asked to apply:
- Local file → use Edit tool
- Pasted text → output corrected version
- Google Doc → apply edits from bottom to top (note table cells can't be edited via API)

## Exclusions

User may say "exclude N, M" to remove rows. Remove them and re-number.
