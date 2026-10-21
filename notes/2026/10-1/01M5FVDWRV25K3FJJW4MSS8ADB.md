---
id: 01M5FVDWRV25K3FJJW4MSS8ADB
created: 2026-10-21T18:26:27.739673Z
updated: 2026-10-21T18:26:36.155603Z
type: task
title: A Data Subject Requests evidence test no longer fails in the hour before UK midnight
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1197
sprint: ss8348q
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found 21 Oct 2026 at 19:20 BST: `test_dsr_evidence_of_operation.py::test_overdue_and_late_are_counted_exactly` (added by COM-1185 part 4) fails when run in the hour or so before UK midnight ("answered 4 hours late" instead of 5).

**Why:** the test records the answer letter's sent date as the UTC date of a moment that, in that hour, is already the next day in the UK, so Compass (correctly) counts lateness from the end of the earlier sent day.

**Change:** the test pins its times to the middle of the day so the sent date and the sent moment are the same day in every zone. No app change.

**Done when:** the test passes at any time of day.