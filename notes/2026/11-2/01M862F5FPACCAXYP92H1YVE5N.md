---
id: 01M862F5FPACCAXYP92H1YVE5N
created: 2026-11-24T06:04:10.614156Z
updated: 2026-11-24T21:39:31.612376Z
type: task
title: Two decision records created at the same moment no longer fail with an error over the same DEC number
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2130
sprint: szwetpq
assignee: steve
label:
- bug
priority: low
task_status: todo
---
Found by the COM-2124 rehearsal while seeding data. Outside the Backup and Restore sprint.

**What happened**

Creating two decision records at the same moment (two requests in parallel) made one of them fail with a server error: both tried to take the same DEC number. Decisions take "one above the highest", with no counter (ADR 0170 notes this), so concurrent creates race.

**Done when**

- Two or more decisions created at the same moment each get a distinct DEC number, and none fail.
- Numbers are still never reused, including after a restore (`restored_number_floors`, ADR 0170).
- Check whether audit findings (the other kind numbered "one above the highest") have the same race, and fix both the same way.
- A test creates decisions concurrently against real Postgres.