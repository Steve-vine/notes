---
id: 01M3EH6R6PVZZCSPHR6MB7DNRV
created: 2026-09-26T09:37:09.846135Z
updated: 2026-09-26T09:37:09.846135Z
type: task
title: System status shows every scheduled job — when it last ran, how long it took, whether it worked, and whether it's overdue
task_status: todo
priority: medium
label: feature
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 760
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