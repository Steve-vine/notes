---
id: 01M58ZMC0MJJ85K1FHKP0MZ2CG
created: 2026-10-19T02:25:13.236615Z
updated: 2026-10-19T02:25:13.236615Z
type: task
title: A role's Content card stops showing a round that is still running once the assignment is stopped and restarted for a later date
task_status: todo
label: bug
assignee: steve
priority: low
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1104
---
Follow-up to sprint 78 (Attestations, ADR 0117). Noticed while building COM-1102, 2026-10-19; not yet seen on staging.

## What is wrong

On Access Control ▸ Roles ▸ a role ▸ Content: stop an assignment while its round is running, then restart it with a future assign date. The round that was already running still asks people up to their own due dates, as designed. But the row now shows only Scheduled and the new Next opens, and the "12 of 40 signed, 6 days left" progress disappears.

The Attestations ▸ Open tab still shows the round, so nothing is lost, but the role page reads as if nothing is running.

## Fix

While a round from before the restart is still running, the row should keep showing it: Running, with its progress, and the next opening alongside.

**Done when:** after stop → restart (future date) mid-round, the role's Content card shows the running round's progress until its last person's due date, then Scheduled.