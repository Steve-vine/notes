---
id: 01KXX7M9HFQ8W8KE7THBCVB0G9
created: 2026-07-19T13:04:13.359327313Z
updated: 2026-07-19T19:58:34.222730857Z
type: task
title: Retire the scheduled summarise/analyse timers
project: 01KX671DATY39VW6GWK3M2T3DN
number: 144
task_status: active
blocked_by:
- 01KXX7KDMJK1YACXH6N4JZYM7D
- 01KXX7KJT32P27V03GCRCE2RQ0
assignee: steve
label:
- chore
priority: medium
sprint: srmqjcq
---
**Sprint 14 (vertical slice: backend + UI).** Close out the old scheduled AI — the Obs Loop replaces it, completing the cost re-architecture.

- **Backend**: remove the 15-/30-min `summarise-state` / `analyse` Beat timers (the deterministic Obs Loop + on-demand investigation now cover detection). The stopgap that disabled them (Sprint 11) becomes permanent removal.
- **UI**: Settings / Agent-runs no longer surface the retired scheduled AI; the change in scheduled-AI spend is visible on the AI spend view.

**DoD**: the old summarise/analyse timers are gone, the Obs Loop is the only scheduled detection, and the UI (Settings/Agent-runs/spend) reflects their removal. Not done until the UI no longer shows them running.

Depends on the scheduler + Kubernetes detectors.