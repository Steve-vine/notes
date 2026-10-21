---
id: 01M5FVDWRV25K3FJJW4MSS8ADB
created: 2026-10-21T18:26:27.739673Z
updated: 2026-10-21T20:16:50.885226Z
type: task
title: A Data Subject Requests evidence test no longer fails in the hour before UK midnight
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1197
sprint: ss8348q
comments:
- id: 01M5FW8H4J3SQM53V7D3G48WPJ
  author: Steve Vine
  at: 2026-10-21T18:41:00.562138Z
  text: |-
    Done — PR #1212, merged 21 Oct 19:40 BST (shared with COM-1196, since neither could pass CI without the other today).

    - A test added this afternoon (COM-1185) failed when run in roughly the hour before UK midnight. It set up its own data inconsistently: the letter's "sent on" day was a UTC day while the moment it was sent was already the next UK day. Compass then correctly counted lateness from the end of the earlier day.
    - The test now uses times in the middle of the day, so it passes at any hour. It passed at 19:26 BST, inside the hour where it had failed.
    - No change to Compass itself.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found 21 Oct 2026 at 19:20 BST: `test_dsr_evidence_of_operation.py::test_overdue_and_late_are_counted_exactly` (added by COM-1185 part 4) fails when run in the hour or so before UK midnight ("answered 4 hours late" instead of 5).

**Why:** the test records the answer letter's sent date as the UTC date of a moment that, in that hour, is already the next day in the UK, so Compass (correctly) counts lateness from the end of the earlier sent day.

**Change:** the test pins its times to the middle of the day so the sent date and the sent moment are the same day in every zone. No app change.

**Done when:** the test passes at any time of day.