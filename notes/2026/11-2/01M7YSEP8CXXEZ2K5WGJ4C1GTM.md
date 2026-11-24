---
id: 01M7YSEP8CXXEZ2K5WGJ4C1GTM
created: 2026-11-21T10:11:56.812471Z
updated: 2026-11-24T22:47:05.278658Z
type: task
title: Two data subject request tests fail now and then because of the clock
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2059
sprint: szwetpq
comments:
- id: 01M87VVH5KP766PRTPMV6CKV1P
  author: Steve Vine
  at: 2026-11-24T22:47:04.626986Z
  text: |-
    Merged: #2145, dbc86200f, 24 Nov 22:46 GMT. Tests only. Goes into v0.27.0.

    - Retention test: now looks for the whole test phone numbers rather than "07700", so no timestamp or id can match by chance. This also covers COM-2141's failure on #2128.
    - Deadlines test: the cause was any second at all passing between pause and restart, not a minute boundary. It now holds the clock still (the pattern from test_report_schedules.py) and checks a 25-minute pause exactly.
    - RequestsTab test: the leftover timer was the Import button's spinner fade, left running after the button unmounted, on every run of the import test. This file now turns motion off (reduced motion), and the withdraw and bulk tests wait for their window to close.

    Checked by breaking each thing on purpose and seeing the test fail. Each fixed test then passed 10–15 times under load. CollectionCard and DDQ library timeouts: no log of a one-off cause found, and both pass under load, so left alone.
assignee: steve
label:
- tech_debt
priority: low
task_status: review
---
Seen on PR #2049 (COM-2055) on 2026-11-21, which touched neither area. Each test failed once and passed on rerun.

- **test_dsr_retention:** checks that a phone number ("07700") is gone from the activity log, but a timestamp in the log (".107700Z") happened to contain the same digits.
- **test_dsr_deadlines:** expected "paused 0 minutes" but got "1 minute", because the clock crossed a minute boundary during the test.

Also seen the same day on PR #2045, in the frontend suite under load: a Mantine closing animation finished after RequestsTab.test.tsx had ended ("window is not defined"), and CollectionCard and the DDQ library list each timed out once.

**Done when**
- The retention test checks for the phone number in a way a timestamp can't match (e.g. the field values, or a test number that can't appear in a time).
- The deadlines test freezes or controls the clock.
- RequestsTab.test.tsx waits for the window to finish closing (or transitions are off in tests), so no timer fires after teardown.
- Each passes repeatedly under load.

Independent: tests only.