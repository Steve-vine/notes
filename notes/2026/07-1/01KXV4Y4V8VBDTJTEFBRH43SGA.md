---
id: 01KXV4Y4V8VBDTJTEFBRH43SGA
created: 2026-07-18T17:38:41.640359578Z
updated: 2026-07-18T17:39:04.229446145Z
type: task
title: AI-proposed / human-confirmed incident merge
task_status: backlog
priority: medium
assignee: steve
label:
- feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 121
sprint: sdv8hgy
---
**Sprint 13 (Incident Loop) — split from ISE-114.** Let ISE **propose** merging related Incidents, with a human confirming — **never automatic** (ADR 0025).

- AI proposes candidate merges of related open Incidents (shared entity, correlated timing, similar signature); the operator confirms or rejects; provenance recorded.
- Merging folds the signals + timeline of the merged incident into the survivor.
- Sits in the AI/learning era — depends on the **Estate Knowledge Base** (Sprint 12) for the entity/edge context that makes "related" meaningful, and on the Incident model tasks (state machine + stable-key correlation).

Deferred from ISE-114 because it cannot land before the estate graph exists.