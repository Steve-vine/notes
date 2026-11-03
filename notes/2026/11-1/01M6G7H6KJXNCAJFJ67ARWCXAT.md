---
id: 01M6G7H6KJXNCAJFJ67ARWCXAT
created: 2026-11-03T08:13:40.850473Z
updated: 2026-11-03T08:13:44.034909Z
type: task
title: Action reminder emails have stopped since 31 October, and the Security Feed digest stops with them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1534
sprint: s6xh9g1
assignee: steve
priority: medium
task_status: active
---
Found in the sprint 102 pre-UAT (2026-11-03).

## What people see

On staging, no action reminder email (daily or weekly) has gone out since 31 October 13:00, when Actions (sprint 100) was deployed. The hourly job has failed every run since. The Security Feed digest runs in the same job after it, so no digest has gone out either, and the feed's actions (COM-1523) never reach the actions email.

## Fix

- The reminders job records an action whose due date Compass worked out (ADR 0137 §4) the same way it looks it up, so it recognises what it has already sent. Rows written since 31 October are recognised too, so nobody gets repeats.
- The Security Feed digest runs even if the action emails fail, and the reverse.

**Cause (technical):** `mail_digest._key` keys a computed-due action with `due_on=None`, but `_record` wrote `due_on=action.due_date`. The ledger lookup never matched, and the next run re-inserted the same `appeared` row, hitting `uq_notification_dedup` at `db.commit()`. `generate_reminders` called `feed_digest.send_digests` only after `mail_digest.run` returned. Bug from COM-1473.

**Chain:** independent (no migration, no API change).

**Done when:** a test running the job twice over a computed-due action writes one row and sends once; a failure in one email doesn't stop the other; on staging the hourly job succeeds and action emails resume without repeats.