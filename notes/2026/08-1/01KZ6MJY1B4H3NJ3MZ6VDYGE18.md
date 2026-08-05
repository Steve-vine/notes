---
id: 01KZ6MJY1B4H3NJ3MZ6VDYGE18
created: 2026-08-04T14:59:32.011291Z
updated: 2026-08-05T19:29:35.727794Z
type: task
title: Observation toggle with no interval silently never runs — default it or refuse it
project: 01KX671DATY39VW6GWK3M2T3DN
number: 537
order: 1.125
sprint: skxht3g
comments:
- id: 01KZ6Q7M14J79MSQXMA6QKCPYW
  author: Steve Vine
  at: 2026-08-04T15:45:47.044086Z
  text: |-
    PR #454 — https://github.com/Steve-vine/ise/pull/454

    Built option (1), defaulting over refusing so no future integration's setup flow grows a validation hurdle.

    - Create and update fill in a cadence when detection is on and none is set, and the API returns it — the chosen value is a real visible setting, not a hidden one. An explicit cadence in the same call wins. Default is daily (86400), the slowest UI preset: observation detection changes on a human timescale, so a defaulted setting should cost the least it can.
    - New `SystemRead.schedule_warnings` (additive, ADR 0009) derives the inert combination at read time and the Obs card renders it — that covers rows predating the fix without a data migration guessing intervals for them.
    - `is_obs_due` still treats NULL as never-due; guessing there would start loops nobody scheduled.

    Sync side checked as asked and deliberately NOT guarded: a NULL sync_interval_seconds IS the encoding of "scheduled sync off" (ISE-166 — no separate flag), so no two settings can disagree, and a warning would flag a deliberate choice. Reasoning recorded in the schedule_warnings docstring, not just the PR.

    Tests: API enable path returns a cadence; the DoD assertion (inert before, due after, idempotent); pre-existing rows warn while detection-off does not; and the page-level guard, verified to FAIL with the SystemDetailPage change reverted rather than merely to pass.

    No migration. Still needs Steve's immediate repair on the live M365 System (set a cadence) — the fix does not retro-fit existing rows, it flags them.
assignee: steve
priority: medium
task_status: done
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
