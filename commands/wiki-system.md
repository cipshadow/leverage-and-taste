---
description: Knowledge base management. Subcommands: ingest <source>, query <question>, lint, explore. Maintains a personal wiki with confidence-tagged claims and cross-references.
argument-hint: <ingest|query|lint|explore> <source or question>
user-invocable: true
---

# /wiki — Personal Knowledge Base System

A structured knowledge base maintained by AI but curated by you. Four operations: ingest, query, lint, explore.

**Wiki location:** `wiki/` in your workspace root. Requires a `wiki/CLAUDE.md` schema file (see wiki-schema/ in skills-and-ways-of-working for the template).

---

## Mode detection

Parse $ARGUMENTS:
- Starts with `ingest` → Ingest mode
- Starts with `query` → Query mode
- `lint` → Lint mode
- `explore` → Explore mode
- Empty → ask which operation

---

## Ingest mode

Process a new source into the knowledge base.

### Protocol

1. Read `wiki/CLAUDE.md` for the schema and conventions
2. Read `wiki/index.md` to understand what's already in the wiki
3. Read the source fully
4. **Discuss key takeaways with the user before writing anything**
5. Create or update wiki pages in the appropriate section(s) — a single source should touch multiple pages
6. Update `wiki/index.md` with any new or changed pages
7. Add `[[backlinks]]` from existing pages to new content
8. Flag contradictions with existing wiki content using `> CONTRADICTION:` blocks (prefer the more recent figure)
9. Tag every factual claim with confidence level: `[V]` verified, `[H]` high, `[M]` medium, `[L]` low, `[?]` unverified
10. Append to `wiki/log.md`: `## [YYYY-MM-DD] ingest | [description]`
11. Show which pages were created or updated

Process one source at a time.

---

## Query mode

Answer a question using the knowledge base.

### Protocol

1. Read `wiki/index.md` to find relevant pages
2. Read those pages, following `[[links]]` for connected context
3. Synthesize an answer with citations to specific wiki pages
4. If the answer is substantial or reusable, offer to file it back into the wiki
5. If the question reveals a gap in the wiki, flag it and suggest what sources would fill it
6. If sources contradict, show both values and prefer the more recent one

---

## Lint mode

Full health check on the wiki.

### Checks

1. **Contradictions** between pages (same fact, different values)
2. **Stale claims** (dates >3 months old on fast-moving topics)
3. **Orphan pages** with no inbound `[[wikilinks]]`
4. **Missing pages** (concepts mentioned but no dedicated page)
5. **Missing cross-references** (pages that should link to each other but don't)
6. **Claims without source citations**
7. **All `[?]` unverified claims** — prioritize which to verify first
8. **Broken `[[wikilinks]]`** pointing to non-existent pages

Output a report to `wiki/outputs/lint-report-YYYY-MM-DD.md`.

Suggest 3 sources from `wiki/_sources-registry.md` that would fill the biggest gaps.

---

## Explore mode

Find unexplored connections between existing topics.

### Protocol

1. Scan all wiki pages
2. Identify the 5 most interesting unexplored connections between topics
3. For each:
   - Name the topics involved
   - Explain what insight the connection might reveal
   - Cite which wiki pages contain related information
   - Suggest what source would confirm or deepen the connection
4. If connections are strong, create new pages or add cross-references
5. Update `index.md` and `log.md` with any changes

---

## Auto-ingest (called by /ho and /my-week)

Automatic scanning for new domain knowledge. Not user-invoked directly.

### Protocol

1. Read wiki schema and index
2. **Source-drift detection:** Check if ingested sources have been updated since their wiki pages were last refreshed. Compare modification dates. Refresh top 3 most stale.
3. **Session scanning:** Scan current session for new domain knowledge not already captured
4. **Contradiction check:** For each new fact, check against existing pages
5. **Update:** Add new information with confidence tags and wikilinks
6. **Report:** "Wiki: [what was added/updated]" or "Wiki: no new knowledge this session."
