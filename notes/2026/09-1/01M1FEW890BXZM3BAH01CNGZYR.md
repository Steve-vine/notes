---
id: 01M1FEW890BXZM3BAH01CNGZYR
created: 2026-09-01T21:44:19.48839Z
updated: 2026-09-04T16:50:48.146687Z
type: task
title: The Conductor owns all scheduling
project: 01KX671DATY39VW6GWK3M2T3DN
number: 762
sprint: s7nj09w
comments:
- id: 01M1J5E3ZY8DQG7QC8MPNS9Z1M
  author: Steve Vine
  at: 2026-09-02T22:57:02.462643Z
  text: |-
    Built — PR #706 (feature/ise-762-conductor), stacked on #705. No migration.

    WHAT SHIPPED
    - `conductor.py` declares every core scheduled job — name, task, cadence, and one sentence about what it is for — and `beat_schedule()` builds Celery's dict from those plus the connector-declared sweeps (ADR 0085). `worker.py` keeps the broker, the queues and the worker's own settings, and stops holding a hand-written schedule.
    - The ISE-605 expiry rule moved into the Conductor: it is a statement about cadence, not about the worker.
    - `SystemCadence` names the interval column, the last-run column and any opt-in beyond `System.enabled`. `is_due` is now the ONE place the enabled gate lives — that is the "disabled means silent" guarantee (ISE-754, ADR 0072) expressed once instead of fourteen times. `dispatch_syncs` and `dispatch_obs_loop` are the same two lines with a different cadence.
    - `task_telemetry` gains one hash field per task NAME, overwritten each run — O(1) to write, bounded by the number of task types.

    THE UI QUESTION, ANSWERED
    The task said headless "unless we decide the Conductor's schedule is worth showing — worth asking, given nothing today shows what is due to run". Built it: a **Schedule panel on System Status** listing every job, its cadence, when it last ran and when it is next expected, with dispatchers and connector-declared sweeps marked. It is the gap the 2026-08-06 backlog actually left — the screen built to explain that backlog could say the queue was full and not what was filling it.

    Two properties held deliberately:
    - **Descriptive, never a control.** Nothing on that panel can start, stop or reschedule anything. A cadence somebody can nudge from a screen is a cadence that stops matching what the code says it is.
    - **"Not recorded" is not "never ran".** The stamps live in Redis and do not survive it, so the panel says "not recorded" and `next_due_in_seconds` is null rather than a number that would read as a claim. There is a test for this.

    ALSO IN THE PR (unrelated, blocked the merge)
    `test_document_register.py::test_investigation_context_carries_summaries_with_their_age` pinned a document's `source_modified_at` to the module's fixed `NOW` (2026-07-22) and asserted a phrase that `investigation_context` computes against the REAL clock — so its apparent age was 240 days plus however long ago the baseline was. It rolled 8 months → 9 months on its own and reddened #705's backend run. Anchored to `datetime.now(UTC)`. Nothing to do with this sprint; the parametrised test beside it passes `now=NOW` and is the one that pins the wording.

    Tests: `tests/test_conductor.py` (the schedule the worker runs IS the declarations; every entry carries its own expiry; a disabled integration is never due for anything; the two cadences are one rule read with different fields) and `SchedulePanel.test.tsx`.
assignee: steve
label:
- tech_debt
priority: medium
task_status: done
tech: null
---
ADR 0107: one component owns cadence — what runs, how often, and whether it runs at all.

Roughly fourteen beat entries each implement their own dispatch, gating and due-calculation today: syncs, obs loop, approved changes, notifications, report runs, status pages, ticket sweeps, dashboards, system status, stale-run reaping, webhook recovery, estate lifecycle, repo sweeps, heartbeat.

**Why it matters beyond tidiness:** this is where the "disabled means silent" guarantee (ISE-754) becomes expressible once instead of fourteen times. It is also what lets the Differ run per-minute independently of integration polling.

**Headless.** No user-facing surface, unless we decide the Conductor's schedule is worth showing — worth asking, given nothing today shows what is due to run.

**Done when** cadence decisions live in one place and adding a scheduled job means declaring it, not writing another dispatcher.