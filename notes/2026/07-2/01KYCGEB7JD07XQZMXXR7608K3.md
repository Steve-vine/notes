---
id: 01KYCGEB7JD07XQZMXXR7608K3
created: 2026-07-25T11:26:52.146144Z
updated: 2026-07-25T15:43:09.393861Z
type: task
title: Retrieval layer, first slice — ranked signal/history search for issue-chat
project: 01KX671DATY39VW6GWK3M2T3DN
number: 289
sprint: svgrad3
blocked_by:
- 01KYCGDFZS07QN37N8BQMVFZWH
assignee: steve
label: null
priority: medium
task_status: todo
---
**Sprint 24 tuning, batch 2 — start after batch 1 completes.** First implementation slice of the retrieval-layer ADR (which must land first).

Add a ranked, bounded search tool for the investigation surfaces — `search_signals` / `find_relevant_history`: "signals and incident history relevant to this entity, this window, this symptom", answered by indexed Postgres queries (FTS/trigram), returning a truncation-honest shortlist the model drills into by choice.

Directly serves the "any clues in DataDog history for the last few hours?" ask from the sprint discussion — today the agent must pull broad slices and winnow with model tokens; after this, the winnowing is a database query.

Scope deliberately small: signals + incident history only. Documents already have their summary path; webhooks/repos join when their sprints land on the same contract.