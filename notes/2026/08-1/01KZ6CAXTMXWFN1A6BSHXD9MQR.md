---
id: 01KZ6CAXTMXWFN1A6BSHXD9MQR
created: 2026-08-04T12:35:21.044693Z
updated: 2026-08-07T10:09:35.04704Z
type: task
title: search_documents retrieval tool — let the AI find registered documents by content, not only by tag adjacency
project: 01KX671DATY39VW6GWK3M2T3DN
number: 534
order: 1.03125
sprint: skxht3g
comments:
- id: 01KZ6TDDWV9YB4KV7QBB9BV0AA
  author: Steve Vine
  at: 2026-08-04T16:41:23.099625Z
  text: |-
    PR #459 — https://github.com/Steve-vine/ise/pull/459 (migration 0094)

    STACKED on ISE-533's branch so 0094 chains onto 0093 — merge PR #458 first. Base is main (verified).

    All four scope points done:
    1. Migration 0094, functional GIN over title + description + summary + content, expression mirrored in the ORM __table_args__ so models_match stays green. Content in the vector deliberately: "which runbook mentions the failover procedure" is only answerable from the body.
    2. `retrieval.search_documents`, zero-cost: id, title, url, freshness (age_phrase), tags, ts_headline excerpt. Two things worth knowing — the excerpt strips ts_headline's default `<b>` markup (noise a model reads past), and it is hard-capped in CHARACTERS because ts_headline's options are counted in words, so a page of long tokens could still return something document-sized. Headlining is a second bounded query over the shortlist ids, so it re-parses 8 bodies not every candidate.
    3. Wired to assist (the surface that actually failed), issue chat, and the diagnosis loops — mirroring search_repo_knowledge exactly. The assist allow-list is frozen by a test, so the addition carries its reasoning there.
    4. Docstrings steer search-first and repeat the UNTRUSTED-content framing.

    Bonus found while doing it: the MCP server ALREADY had a `search_documents` — an ILIKE over title/description/url that could not find a document by anything its body said. Pointed it at the same ranked implementation rather than leaving two different meanings under one name.

    Tests replay the failing conversation: title-phrase hit, body-phrase hit, and a hit on an UNTAGGED document (the ISE-533 state — this must not go through the tag join), plus bounded/markup-free and stop-word recency fallback.

    One deliberate limit: the diagnosis loops get search_documents but NOT read_document, matching how documents already reach that surface (summaries, not full pages). Opening whole pages inside an autonomous loop is a cost decision for its own ticket.

    Acceptance still needs your live check: ask Assist "what do you know about Chinwag-V2 deployment" on staging and confirm it cites the page as Evidence.
assignee: steve
label: null
priority: medium
task_status: done
---
Companion to ISE-533, from the same live test 2026-08-04: Steve asked Assist "what do you know about Chinwag-V2 deployment" while a Confluence page with exactly that title sat fully-fetched in the Document Register — and the AI had no tool that could find it.

## The gap

The AI's document access is `read_document(document_id)` (`assist_tools.py:442`) plus summaries pushed into investigation context for documents **tag-adjacent to in-scope entities** (`documents_for_entities`, ADR 0042 §3). There is no discovery path:

- A cold question with no entity in scope ("what do we know about X?") has no road to any document.
- An entity whose tags don't intersect the document's tags (or an untagged doc — ISE-533) also has no road.

Meanwhile `retrieval_tools.py` already gives the AI `search_signals`, `search_events`, `find_relevant_history`, `search_repo_knowledge`, `search_commit_history`. Repos got FTS retrieval in Sprint 26; documents — the register whose entire purpose is runbooks the AI should reach during incidents — never did. This closes the asymmetry.

## Scope

1. **FTS over the register**: tsvector over `title + description + summary + content`, following the established FTS shape (events mig 0073 / repo-knowledge and ADR 0050 precedents — copy whichever pattern is cleanest). Migration for the index/generated column.
2. **`search_documents(query)` in `retrieval_tools.py`**, zero-cost tier (ADR 0050 — retrieval must not spend AI tokens): returns id, title, freshness (`age_phrase` exists), tag labels, and a matched snippet — enough for the model to decide whether to `read_document`. Cap results (~10) and snippet length; the existing tools set the shape.
3. **Register it on the surfaces that already get the other search tools** — assist, incident chat, and the loops that carry `search_repo_knowledge` — deliberately mirroring wherever that tool is wired, not inventing a new placement.
4. **Tool docstring should steer the model**: search first when asked about a named system/runbook/topic; the tag-adjacency context still handles the "you're investigating this entity, here are its docs" push case. Retrieval stays read-only; ADR 0049's chat=write boundary untouched.

## Acceptance (the failing conversation, replayed)

With the register as it is today (once ISE-533 restores tags — but this must pass even for an untagged doc), asking Assist "what do you know about Chinwag-V2 deployment" produces an answer drawing on the registered Confluence page: the tool finds it by title/content, the model reads it, the answer cites it as Evidence (ADR 0049). A vitest/pytest-level test asserts the tool returns the doc for a title-word query and for a body-phrase query.

## Not in scope

- Embeddings/semantic search — FTS matches the platform's every other retrieval surface (pg_trgm is unavailable estate-wide; plain tsquery like events/repos).
- Auto-injecting search results into every prompt — pull, not push (the Sprint 24 estate-context lesson).
