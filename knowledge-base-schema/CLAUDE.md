# Knowledge Base Schema

## What This Is

A personal knowledge base about [YOUR DOMAIN]. Maintained by an LLM. The human curates sources and asks questions. The LLM writes and maintains the entire wiki.

This wiki is the compiled domain knowledge layer. It sits above per-project working memory (CONTEXT.md, SESSION_LOG.md) and provides reusable domain knowledge that all projects can reference.

## Architecture

- **Article directories** contain the compiled wiki pages. The LLM owns these entirely.
- **raw/** contains source material (articles, notes, docs, transcripts). These are immutable. Never modify files in raw/.
- **raw/assets/** contains images, screenshots, and diagrams referenced by sources.
- **outputs/** contains generated reports, briefings, analyses. When an output is valuable enough to inform future queries, promote it into the appropriate article directory.

## Wiki Sections

| Section | What goes here |
|---------|---------------|
| `concepts/` | Core domain knowledge: fundamental concepts, definitions, mental models |
| `products/` | Product knowledge: features, capabilities, roadmap, architecture |
| `market/` | Market landscape: competitors, trends, positioning, pricing |
| `strategy/` | Strategic context: vision, bets, priorities, decisions |
| `technical/` | Technical architecture: systems, APIs, data models, infrastructure |
| `operations/` | Operational knowledge: processes, runbooks, workflows |
| `research/` | Research findings: user insights, experiments, data analysis |

**CONFIGURE:** Adjust sections to match your domain.

## Page Format

Every wiki page follows this structure:

```markdown
---
title: Page Title
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
source_count: N
status: active | stub | stale
---

One-paragraph summary of what this page covers.

[Content with [[wikilinks]] and confidence tags]

## See Also
- [[related-page-1]]
- [[related-page-2]]

## Sources
- [Source: filename.md] or [Source: url] or [Source: conversation YYYY-MM-DD]
```

## Conventions

### Cross-references
Use `[[page-name]]` links between wiki pages (Obsidian-style wikilinks). Cross-reference aggressively. The connections between pages are as valuable as the pages themselves.

### Source citations
Every factual claim cites its source: `[Source: filename.md]` or `[Source: url]`. When a claim comes from multiple sources, cite all of them.

### Confidence tags
Every factual claim (numbers, dates, technical behavior) gets a confidence tag:

| Tag | Level | Source requirement |
|-----|-------|-------------------|
| `[V]` | Verified | Official docs, specs, API references, primary sources |
| `[H]` | High | Approved documents, published guides, authoritative sources |
| `[M]` | Medium | Working documents, meeting notes, drafts |
| `[L]` | Low | Inferred, cross-referenced indirectly, from conversation |
| `[?]` | Unverified | Claim exists but source not yet checked |

### Contradiction handling
When new information contradicts existing content:
- Flag with a `> CONTRADICTION:` callout block
- Show both values with dates and sources
- Prefer the more recent figure
- Never silently overwrite contradicted content
- Note the contradiction in log.md

## Index and Log

- **index.md** catalogs every page with a one-line description, organized by section. Updated on every ingest.
- **log.md** is append-only chronological. Format: `## [YYYY-MM-DD] action | Description` where action is `ingest`, `query`, `lint`, `explore`, or `update`.
- **_sources-registry.md** lists all known sources with ingest status: `[x]` ingested, `[ ]` not yet, `[p]` priority next.

## Operations

### Ingest
1. Read the full source
2. Discuss key takeaways with user
3. Create or update wiki pages (a single source should touch multiple pages)
4. Update index.md
5. Add backlinks from existing pages
6. Flag contradictions
7. Append to log.md

### Query
1. Read index.md to find relevant pages
2. Read those pages, following [[links]]
3. Synthesize answer with citations
4. Offer to file substantial answers back into the wiki
5. Flag gaps revealed by the question

### Lint
1. Find contradictions between pages
2. Find stale claims (>3 months on fast-moving topics)
3. Find orphan pages (no inbound links)
4. Find missing pages (concepts mentioned but unexplained)
5. Find uncited claims
6. Find all [?] claims and prioritize verification
7. Output: `outputs/lint-report-[date].md`

### Explore
1. Scan all pages for topics appearing in multiple contexts
2. Identify unexplored connections
3. For each: name topics, explain insight, cite pages, suggest confirming source
4. Create new pages or cross-references for strong connections

## Scope Boundary

**This wiki is for [YOUR DOMAIN] knowledge only.** Don't ingest operational state (session logs, pipeline status). Distilled knowledge flows up from projects into the wiki; operational state stays in the project.
