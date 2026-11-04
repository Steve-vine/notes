---
id: 01M6G7H6KJXNCAJFJ67ARWCXAT
created: 2026-11-03T08:13:40.850473Z
updated: 2026-11-04T07:45:33.96385Z
type: task
title: Action reminder emails have stopped since 31 October, and the Security Feed digest stops with them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1534
sprint: s6xh9g1
comments:
- id: 01M6GA9TASF55SBABRX77D2G9S
  author: Steve Vine
  at: 2026-11-03T09:02:04.633156Z
  text: |-
    Done: PR #1547 merged (f69ccf37), deployed to staging at 08:44.

    - An action whose due date Compass worked out is now recorded the way it's looked up. Rows written the old way since 31 October are recognised too, so nothing is repeated.
    - The action emails and the Security Feed digest each run whatever happens to the other. A failure still marks the run as failed.

    Pre-UAT (staging): **Passed**
    - The 09:00 run succeeded for the first time since 31 October 13:00 (40 s). It sent 19 action emails and then the Security Feed digests (8).
    - It wrote 24,029 records, almost all this week's weekly chases for overdue vulnerabilities (20,550 across 6 people) and unrequested access changes. None duplicates a record from before; I checked for repeats and found 0.

    Worth knowing: the weekly chase lists every overdue vulnerability, about 3,400 on staging, so those emails are long. That's how the chase works, not this fix.
assignee: steve
label: null
priority: medium
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