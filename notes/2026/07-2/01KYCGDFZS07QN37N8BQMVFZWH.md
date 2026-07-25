---
id: 01KYCGDFZS07QN37N8BQMVFZWH
created: 2026-07-25T11:26:24.249465Z
updated: 2026-07-25T12:26:46.571592Z
type: task
title: 'ADR: retrieval layer contract — comprehend once, find in the DB, read shortlists'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 284
sprint: svgrad3
assignee: steve
priority: medium
task_status: active
---
**Sprint 24, batch 1. Pillar 3 (zero-cost retrieval). Docs only — direction-setting ADR, incremental build later.** Net-new from the sprint discussion (2026-07-25); not in the ISE-263/264/265 briefs.

The problem: agent tools are "list and get", not "find and rank" — the *finding* is done by the model with tokens, so AI cost grows with data volume rather than incident difficulty, and gets worse with every new source.

The contract (an architectural layer between raw sources and agents):
1. **Comprehension at write time, once** — everything ingested (signals, webhooks, repo changes, documents) gets its cheap-to-read form computed on arrival. Generalises the document-summary pattern (ADR 0042 §4).
2. **Finding in the database** — indexed, ranked search ("relevant to this entity / timeframe / symptom") as deterministic tool calls. Postgres FTS/trigram first; no embeddings until proven needed.
3. **Small, ranked, truncation-honest results** — the model reads a shortlist and drills in by choice (`bound_payload` / read-on-demand made universal).

This is also the integration contract: Webhooks (sprint 22) and IAC Repos (sprint 26) must plug in as ingest→comprehend→index→search, never as raw piles to trawl. First implementation slice is a batch-2 task. Record in the ISE Canon.