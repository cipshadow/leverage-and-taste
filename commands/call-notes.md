---
description: Turn a call transcript into structured notes. Paste transcript text, provide a file path, or omit to fetch from Zoom.
argument-hint: <file path, or paste transcript, or empty to pick from Zoom>
user-invocable: true
model: sonnet
---

## Input handling

1. If the user pasted a file path, read that file directly.
2. If the user pasted transcript text, use that directly.
3. If no input was given, list recent Zoom recordings, ask the user to pick one, then fetch its transcript.

## Processing

Extract structured notes from the transcript:

```markdown
# [Meeting Title] — YYYY-MM-DD

**Attendees:** [names mentioned or identified from speaker labels]
**Duration:** [estimated from timestamps, or "unknown"]
**Projects:** [comma-separated list of related projects]

## Context
One sentence: why this meeting happened.

## Decisions made
- [Decision]: [rationale in one sentence max]

## Action items
- [ ] [Owner]: [task] (by [date if mentioned])

## Key discussion points
### [Topic 1]
- [2-3 bullets max]

### [Topic 2]
- [2-3 bullets max]

[Max 5 topics]

## Open questions
- [Unresolved items needing follow-up]
```

## Rules

- Skip pleasantries, small talk, logistics ("can you hear me", "let me share my screen")
- Attribute action items to specific people by name
- If a decision was contested, note dissent in one line
- Preserve exact numbers, dates, product names, commitments verbatim
- Keep output under 400 words for meetings 30 min or less, under 800 for longer
- Sentence case headings only
- No filler, no narration of your process

## Saving

Save to: `meetings/YYYY-MM-DD-slugified-title.md`

Create the directory if it doesn't exist.

**File format:** Structured notes at the top, then a `## Transcript` section with the full verbatim transcript preserved below (no editing, timestamps and speaker labels intact).

## Project classification

Auto-detect relevant projects from meeting title and content. For each matched project, append a one-line reference to that project's `MEETINGS.md`:

```
- [YYYY-MM-DD — Meeting Title](../../meetings/YYYY-MM-DD-slug.md): one-line summary
```

Create `MEETINGS.md` in the project folder if it doesn't exist.

## Output

1. Show the notes for review
2. State which projects were detected
3. Save the combined file (notes + transcript)
4. Update each matched project's MEETINGS.md
5. Confirm saved path
