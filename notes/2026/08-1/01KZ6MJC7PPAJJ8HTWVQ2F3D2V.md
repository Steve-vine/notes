---
id: 01KZ6MJC7PPAJJ8HTWVQ2F3D2V
created: 2026-08-04T14:59:13.782236Z
updated: 2026-08-07T10:56:16.896359Z
type: task
title: Observation toggle with no interval silently never runs — default it or refuse it
project: 01KX671DATY39VW6GWK3M2T3DN
number: 536
sprint: skxht3g
comments:
- id: 01KZ7417E078ENSPCH3VP4WV3K
  author: Steve Vine
  at: 2026-08-04T19:29:29.023475Z
  text: |-
    Cancelled as a duplicate. ISE-537 carries the identical title and body — the two were created 19 seconds apart (14:59:13 and 14:59:32), evidently a double-submit.

    The work shipped under ISE-537: PR #454, released to main 2026-08-04 (`881770c`), no migration. Nothing is lost by cancelling this one.
assignee: steve
priority: medium
task_status: cancelled
---
Live-found 2026-08-04 checking the fresh M365 enable: the System had `obs_detection_enabled = true` but `obs_interval_seconds = NULL`, and `obs_loop.py:50` treats a NULL interval as never-due — so the Observation loop never ran and the ISE-401 licence-pool detectors were silently inert. The toggle looked on; nothing said it was doing nothing. Exactly the invisible-degradation shape ISE-531's Platform Log exists for, except this one isn't even a warning — no code path ever fires.

The sync side has the same latent shape: `sync.py:49` skips a system whose `sync_interval_seconds` is NULL. Sync setup flows presumably always set an interval, which is why it has never bitten — but the obs flow demonstrably lets the toggle land without one.

## Fix — decide the shape in plan mode, lean (1)

1. **Default on enable (recommended):** turning `obs_detection_enabled` on with no interval sets a sensible default (obs sources are slow-moving — 3600s+; licence pools would be fine at daily). The API/UI shows the value it chose so it is a real setting, not a hidden one.
2. **Refuse:** validation error on enabling detection without an interval — honest, but adds a form-flow hurdle for every future integration.
3. Either way: **surface the inert state** for existing rows — a System card notice when `obs_detection_enabled AND obs_interval_seconds IS NULL` ("Observation detection is on but has no interval — it will never run"). This also covers rows that predate the fix without needing a data migration to guess intervals for them.

Check whether the same guard is worth adding for `sync_interval_seconds` (enabled system, NULL interval → never syncs, health frozen at its last value) while in there — same one-line due-check, same silence.

## Immediate repair (Steve, UI)

Set an observation interval on the live M365 System — until then the licence detectors stay off. Done independently of this task.

## Definition of done

Enabling observation detection cannot produce a permanently-idle loop: the interval is defaulted (or demanded), any pre-existing inert combination is visibly flagged on the System page, and a test asserts the enable path yields a due-able system.
