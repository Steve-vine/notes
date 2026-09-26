---
id: 01M3EH6R6PVZZCSPHR6MB7DNRV
created: 2026-09-26T09:37:09.846135Z
updated: 2026-09-26T12:39:23.943437Z
type: task
title: System status shows every scheduled job — when it last ran, how long it took, whether it worked, and whether it's overdue
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 760
sprint: s3nfes0
blocked_by:
- 01M3EH6EAZSH8VM7KZH1NB43DE
comments:
- id: 01M3EPTFKFFTK6WP5W5NF3FHR4
  author: Steve Vine
  at: 2026-09-26T11:15:19.27936Z
  text: |-
    Merged to main in PR #770 (fa266fe).

    System status now has a Scheduled jobs card with one row per recurring job, by plain name. Each row shows how often the job runs, when it last ran, how long that took, and whether it worked. A failed run shows its error. A job running right now is marked Running. Each row also shows when the job is next due and whether it is On schedule or Overdue.

    A job is Overdue when its last run is more than 3 of its own periods old; the multiple is a setting. So a 5-minute job 40 minutes late is flagged, and a daily job 40 minutes late isn't.

    Jobs that have never run are listed first and say "Never run". The rest follow, most behind first. Just after a deploy, the daily jobs will read Never run until they've run once.

    New scheduled jobs appear on the card automatically, and a test fails if one is added without a plain name.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Second of three System status tasks (ADR 0077 §3). Stacks on COM-759.

**Behaviour.** A **Scheduled jobs** card on System status, one row per recurring job, by plain name:
- directory sync
- shared mailbox read
- sign-in sweep
- authentication-method sweep
- access-work sweep
- scheduled reports
- reminders
- scheduled leavers
- recertification schedules
- posture snapshots
- the connection checks

Each row shows:
- **when it last ran**, **how long it took** and **whether it worked** (with the error when it didn't)
- **when it's next due**
- an **Overdue** flag

**Overdue is judged against each job's own schedule, never as a raw age.** A daily job 40 minutes late is fine; a 5-minute job 40 minutes late is stuck. The figure is age ÷ period, flagged past 3× by default (a setting). A job that has **never run** sorts first, above everything, and says *Never run*. It must not show as a blank cell.

**Mechanism.** The `task_postrun`/`task_failure` handlers from COM-759 also keep a small per-task-name record in Valkey (last start, last finish, duration, outcome, short error). The API derives each job's period and next-due time from the Beat schedule itself (`celery_app.conf.beat_schedule`, both intervals and crontabs), so a new schedule entry appears on the screen with no extra wiring. Plain names come from one mapping of task name to label. Add a test that fails if a Beat entry has no label.

Jobs that already record their passes on their own ledgers (directory sync, shared-mailbox read) still read from the telemetry here, so every row is sourced the same way. Their existing screens are unchanged.