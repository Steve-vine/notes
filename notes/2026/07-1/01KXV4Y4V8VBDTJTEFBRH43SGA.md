---
id: 01KXV4Y4V8VBDTJTEFBRH43SGA
created: 2026-07-18T17:38:41.640359578Z
updated: 2026-07-24T12:32:43.313687Z
type: task
title: AI-proposed / human-confirmed incident merge
project: 01KX671DATY39VW6GWK3M2T3DN
number: 121
sprint: sdv8hgy
blocked_by:
- 01KXV4XHT1TF92MARARTXZJKZK
- 01KXV4XS64Z84BG0E0VT3GHDXH
assignee: steve
label: null
priority: medium
task_status: done
---
**Sprint 13 (Incident Loop) — split from ISE-114.** Let ISE **propose** merging related Incidents, with a human confirming — **never automatic** (ADR 0025).

- **Backend**: AI proposes candidate merges of related open Incidents (shared entity, correlated timing, similar signature); on human confirm, the signals + timeline of the merged incident fold into the survivor; provenance recorded.
- **UI (the vertical slice)**: the merge proposal appears as a **timeline bubble** on the incident conversation, with confirm / reject controls; on confirm, the two incidents visibly become one.
- Sits in the AI/learning era — depends on the **Estate Knowledge Base** (Sprint 12) for the entity/edge context that makes "related" meaningful, and on the Incident model tasks (state machine + stable-key correlation).

**DoD**: two related open incidents surface a merge-proposal bubble; confirming folds them into one incident in the UI; rejecting dismisses it. Not done until the propose/confirm flow renders in the timeline.