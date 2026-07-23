---
id: 01KXX7M9HFQ8W8KE7THBCVB0G9
created: 2026-07-19T13:04:13.359327313Z
updated: 2026-07-23T18:32:58.047674Z
type: task
title: Retire the scheduled summarise/analyse timers
project: 01KX671DATY39VW6GWK3M2T3DN
number: 144
sprint: srmqjcq
blocked_by:
- 01KXX7KDMJK1YACXH6N4JZYM7D
- 01KXX7KJT32P27V03GCRCE2RQ0
comments:
- id: 01KXY0M47T4W7XE7A8SXEKPSKQ
  author: Steve Vine
  at: 2026-07-19T20:21:02.330312289Z
  text: |-
    Done — final Sprint 14 slice. Scheduled summarise/analyse timers retired. PR #130 → main (all CI green). Merged to staging (4b4546c). Review.

    Removed the dispatch-summaries/dispatch-analyses Beat entries (Obs Loop is now the only scheduled detection — no model on a clock); removed the ISE-122 stopgap flag ai_scheduled_jobs_enabled (+ .env.example); task types + per-system tasks kept for on-demand/historical use (ADR 0030 §6). UI copy (Settings + AI spend) updated: ceiling pauses AI features (diagnose/assist), Obs Loop keeps detecting and runs no model. Backend 633 passed.
assignee: steve
label: null
priority: medium
task_status: done
---
**Sprint 14 (vertical slice: backend + UI).** Close out the old scheduled AI — the Obs Loop replaces it, completing the cost re-architecture.

- **Backend**: remove the 15-/30-min `summarise-state` / `analyse` Beat timers (the deterministic Obs Loop + on-demand investigation now cover detection). The stopgap that disabled them (Sprint 11) becomes permanent removal.
- **UI**: Settings / Agent-runs no longer surface the retired scheduled AI; the change in scheduled-AI spend is visible on the AI spend view.

**DoD**: the old summarise/analyse timers are gone, the Obs Loop is the only scheduled detection, and the UI (Settings/Agent-runs/spend) reflects their removal. Not done until the UI no longer shows them running.

Depends on the scheduler + Kubernetes detectors.