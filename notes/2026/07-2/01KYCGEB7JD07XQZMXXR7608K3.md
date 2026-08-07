---
id: 01KYCGEB7JD07XQZMXXR7608K3
created: 2026-07-25T11:26:52.146144Z
updated: 2026-08-07T10:37:57.04492Z
type: task
title: Retrieval layer, first slice — ranked signal/history search for issue-chat
project: 01KX671DATY39VW6GWK3M2T3DN
number: 289
sprint: svgrad3
blocked_by:
- 01KYCGDFZS07QN37N8BQMVFZWH
comments:
- id: 01KYD0C7ZX3KQVS1X4M6TYNHF0
  author: Steve Vine
  at: 2026-07-25T16:05:20.509248Z
  text: |-
    Done — PR #260 (feature/ise-289-retrieval-search → main), CI running.

    - New retrieval.py: search_signals (Findings) + search_incident_history (Issues), ranked by core-Postgres FTS (to_tsvector/plainto_tsquery/ts_rank), window+entity bounded, truncation-honest shortlist; empty/stop-word query → recency fallback.
    - Deliberately NOT pg_trgm — search.py documents CREATE EXTENSION may fail on the CNPG role (trigram migration passes testcontainer, fails cluster). Functional GIN indexes on to_tsvector('english', title) for finding+issue (migration 0054), declared in models so models-match passes; index expr == query expr.
    - Wired into issue-chat: search_signals (scoped to the incident entity by default) + find_relevant_history ("has this happened before?"), over the read-only session (pure ISE-state reads, no writable session). System prompt tells it to search rather than trawl.
    - Scope: signals + incident history only. CamelCase terms (CrashLoopBackOff) are one FTS token — the documented trigram upgrade path.
    - Tests: test_retrieval.py (ranking, window/entity, recency, bounding, history, chat wiring) + migration models-match. Backend ruff+mypy(315 fresh) green.
assignee: steve
label: null
priority: medium
task_status: done
---
**Sprint 24 tuning, batch 2 — start after batch 1 completes.** First implementation slice of the retrieval-layer ADR (which must land first).

Add a ranked, bounded search tool for the investigation surfaces — `search_signals` / `find_relevant_history`: "signals and incident history relevant to this entity, this window, this symptom", answered by indexed Postgres queries (FTS/trigram), returning a truncation-honest shortlist the model drills into by choice.

Directly serves the "any clues in DataDog history for the last few hours?" ask from the sprint discussion — today the agent must pull broad slices and winnow with model tokens; after this, the winnowing is a database query.

Scope deliberately small: signals + incident history only. Documents already have their summary path; webhooks/repos join when their sprints land on the same contract.