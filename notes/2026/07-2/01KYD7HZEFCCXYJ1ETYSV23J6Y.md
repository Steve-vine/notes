---
id: 01KYD7HZEFCCXYJ1ETYSV23J6Y
created: 2026-07-25T18:10:48.399666Z
updated: 2026-07-26T12:21:47.586086Z
type: task
title: Webhook events join the retrieval layer (ADR 0050)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 298
sprint: s6pc5xk
assignee: steve
priority: medium
task_status: backlog
---
**From Sprint 24's retrieval-layer contract (ADR 0050), which names the webhook channel as the first source that must meet it.** Today the events wiring hands the model a bounded recent-events list to scan (ADR 0047's "168-hour event list" — the exact raw-pile pattern ADR 0050 exists to end): the *finding* of the relevant event is done by the model, with tokens, and worsens as event volume grows.

Bring events onto the contract:
1. **Comprehend at write time** — events already arrive normalised to the ISE schema (title, level, event type, outcome, entity hint); add whatever cheap-to-read form search needs computed at ingest (FTS-indexable text, resolved entity id — much already exists).
2. **Find in the database** — a `search_events` retrieval tool (FTS over title/detail + window + entity/level filters, ranked, bounded, truncation-honest), following the `retrieval.py` pattern (core Postgres FTS + functional GIN index, no pg_trgm — see ISE-289).
3. **Shrink the auto-included recent-events block** in incident analysis to a genuinely small shortlist (entity-relevant, ranked) with the search tool as the drill-down — pushed context becomes a pointer + a pulled, bounded result, the ISE-282 pattern applied to events.

ADR 0047 gets a note (not a supersede). Events-as-data posture (never instructions) unchanged.