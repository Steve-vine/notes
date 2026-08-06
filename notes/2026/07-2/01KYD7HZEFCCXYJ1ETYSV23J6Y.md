---
id: 01KYD7HZEFCCXYJ1ETYSV23J6Y
created: 2026-07-25T18:10:48.399666Z
updated: 2026-08-06T08:34:33.820316Z
type: task
title: Webhook events join the retrieval layer (ADR 0050)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 298
order: -1.0
sprint: s6pc5xk
comments:
- id: 01KYSA0N9JDPPRVVF75WS8T4NY
  author: Steve Vine
  at: 2026-07-30T10:44:39.857953Z
  text: |-
    Built and in review — PR #346 (feature/ise-298-events-retrieval), merged to staging. Migration 0073.

    All three parts of the contract landed. (1) Write-time comprehension needed no new columns — ingest already normalises; what search needed was the index: functional FTS GIN over title+detail+entity_hint, canonical-form expression mirrored in the ORM so models_match stays green (core Postgres FTS, no pg_trgm). (2) retrieval.search_events — ranked, bounded, truncation-honest, window/level/source filters, recency fallback for lexeme-less queries, the retrieval.py house pattern. Issue-chat gains it as a search_events retrieval tool; the existing list_webhook_events tools on the investigation and assist surfaces are re-backed by it (same tool names, now ranked + truncation-honest instead of ILIKE-newest-first). (3) The auto-included block reshaped push→pull (ISE-282 pattern): only entity-relevant events ride in — matched in the DATABASE now, killing the old in-memory json-haystack scan over 100 rows — capped at 5, with everything else a count plus a pointer at the search tool; when nothing is relevant the block is one pointer sentence, never the raw pile.

    ADR 0047 gains a note (not a supersede); events-as-untrusted-data posture unchanged. Full backend suite green locally (1,573) incl. models_match at head 0073. Note for the release train: this sprint batch now carries migration 0073 — any parallel branch adding a migration must stack on it.
assignee: steve
label: null
priority: medium
task_status: done
---
**From Sprint 24's retrieval-layer contract (ADR 0050), which names the webhook channel as the first source that must meet it.** Today the events wiring hands the model a bounded recent-events list to scan (ADR 0047's "168-hour event list" — the exact raw-pile pattern ADR 0050 exists to end): the *finding* of the relevant event is done by the model, with tokens, and worsens as event volume grows.

Bring events onto the contract:
1. **Comprehend at write time** — events already arrive normalised to the ISE schema (title, level, event type, outcome, entity hint); add whatever cheap-to-read form search needs computed at ingest (FTS-indexable text, resolved entity id — much already exists).
2. **Find in the database** — a `search_events` retrieval tool (FTS over title/detail + window + entity/level filters, ranked, bounded, truncation-honest), following the `retrieval.py` pattern (core Postgres FTS + functional GIN index, no pg_trgm — see ISE-289).
3. **Shrink the auto-included recent-events block** in incident analysis to a genuinely small shortlist (entity-relevant, ranked) with the search tool as the drill-down — pushed context becomes a pointer + a pulled, bounded result, the ISE-282 pattern applied to events.

ADR 0047 gets a note (not a supersede). Events-as-data posture (never instructions) unchanged.