---
id: 01KXX7M4ZFGXXYQVY4VQTRJQB5
created: 2026-07-19T13:04:08.687415711Z
updated: 2026-07-21T17:44:33.55533Z
type: task
title: Estate drift detection → low-severity Observations
project: 01KX671DATY39VW6GWK3M2T3DN
number: 143
sprint: srmqjcq
blocked_by:
- 01KXX7KJT32P27V03GCRCE2RQ0
comments:
- id: 01KXXZ8NY4PY50Y2T4K6ANRPZM
  author: Steve Vine
  at: 2026-07-19T19:57:18.660371434Z
  text: |-
    Done. Estate drift detection. PR #129 → main (all CI green). Merged to staging (464829d). Review.

    drift.py: a harvested edge discovery stopped re-confirming (last_confirmed_at past a 1h staleness window, well above sync cadence) is stale; authored edges never drift. Obs Loop emits a low-severity drift Observation per stale edge (never pages), joined to its source entity → appears on Observations screen + entity. Graph endpoint returns stale_edge_targets; Estate flags the stale edge with a red dashed "· stale" spoke. No migration (reuses last_confirmed_at). Backend 634 passed.
assignee: steve
label: null
priority: medium
task_status: done
---
**Sprint 14 (vertical slice: backend + UI).** Keep the estate graph honest — the anti-rot mechanism the Estate KB (Sprint 12) was designed around.

- **Backend**: the Obs Loop validates the estate graph (entities/aliases/edges, ISE-125/126/127) against what discovery now sees; divergence emits **low-severity drift Observations** (a removed dependency, a workload that vanished, an alias that no longer resolves).
- **UI**: drift shows on the **Observations** screen and is flagged on the **Estate** — a stale edge / removed dependency is visibly marked on the entity graph and its aliases.

**DoD**: removing a real dependency surfaces a drift Observation and the Estate UI flags the stale edge. Not done until drift is visible in both places.

Depends on the Kubernetes detectors; builds on ISE-126/127.