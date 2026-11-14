---
id: 01M7D5YRJ45HZ33YZ0DQW9EBG9
created: 2026-11-14T14:04:06.596224Z
updated: 2026-11-14T14:04:18.346055Z
type: task
title: 'Switching a check back on keeps to its schedule: a quarterly or yearly check that already has this period''s capture waits for the next period instead of collecting at once'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1826
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: active
---
## What happened

Found in Claude's pre-UAT pass of COM-1815 / COM-1820 on staging 53965a3b (2026-11-14), E2E Test Company. CHK-2 (ACC.13) was Yearly, with captures filed on 6 Nov 2026, so its card read "next early January 2027 (yearly)". It was switched off and back on from the ⋯ menu (COM-1820). Its card then read **"next 14 Nov 2026"**: switching on set the next capture to now, which would give a second capture in the same year, against COM-1815's "captured once per calendar year".

## What people see

- Switching a check back on counts its next capture from its schedule and its last capture, the same way changing the schedule does (COM-1815): if the current period (day / week / month / quarter / year) already has a capture, the next capture is at the start of the next period; if it hasn't, it collects at the next scheduled run.
- So a yearly check captured on 6 Nov, switched off and on in November, reads "next early January 2027 (yearly)"; a weekly check last captured three weeks ago collects at once.
- The switch-on confirmation can say when it will next collect ("Compass collects it again early January 2027").

## Done when

- The repro above reads "next early January 2027 (yearly)" after switching on.
- A check with no capture in the current period collects at the next run after switching on.
- Unit tests cover switching on across daily/weekly/monthly/quarterly/yearly with and without a capture in the current period.

**Independent** unless the switch-on response changes shape. Fix-forward from COM-1815 / COM-1820.