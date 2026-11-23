---
id: 01M84XTFR1V2SDQHR0Y61HSY85
created: 2026-11-23T19:23:44.257812Z
updated: 2026-11-23T19:24:16.953945Z
type: task
title: 'ADR: Backup and restore — an Admin takes a copy before a significant change, restores it three ways, and can recover Compass from outside when it cannot start'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2114
sprint: szwetpq
assignee: steve
label:
- brief
priority: high
task_status: active
---
Write the ADR the rest of the Backup and Restore sprint is built to. ADR 0169 is the next free number on main as of 2026-11-23.

**Chain:** independent (a document only).

**Steve's decisions (2026-11-23)**

- An in-app copy of the database, on demand, before a significant change. It does not replace the scheduled Postgres backup. It can live in the evidence bucket.
- Three restore options: **1. Everything** (the nuclear option: all data including logs), **2. Keep audit logs** (roll back, carrying the audit records forward), **3. Selected records** (open the copy beside live Compass and put back chosen records).
- It must recover from a **complete failure**. Losing logs is acceptable there, as it would be restoring the Postgres backup.

**Done when**

- The ADR records the three options, what each keeps and loses, the hold on automation after any restore, recovery from outside the app, how copies are protected and for how long, and how it amends ADR 0122.
- Steve has read it and it is marked Accepted.