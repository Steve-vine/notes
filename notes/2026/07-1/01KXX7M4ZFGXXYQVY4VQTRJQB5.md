---
id: 01KXX7M4ZFGXXYQVY4VQTRJQB5
created: 2026-07-19T13:04:08.687415711Z
updated: 2026-07-19T13:04:29.127541932Z
type: task
title: Estate drift detection → low-severity Observations
task_status: backlog
assignee: steve
priority: medium
label:
- feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 143
tech: null
sprint: srmqjcq
---
**Sprint 14 (vertical slice: backend + UI).** Keep the estate graph honest — the anti-rot mechanism the Estate KB (Sprint 12) was designed around.

- **Backend**: the Obs Loop validates the estate graph (entities/aliases/edges, ISE-125/126/127) against what discovery now sees; divergence emits **low-severity drift Observations** (a removed dependency, a workload that vanished, an alias that no longer resolves).
- **UI**: drift shows on the **Observations** screen and is flagged on the **Estate** — a stale edge / removed dependency is visibly marked on the entity graph and its aliases.

**DoD**: removing a real dependency surfaces a drift Observation and the Estate UI flags the stale edge. Not done until drift is visible in both places.

Depends on the Kubernetes detectors; builds on ISE-126/127.