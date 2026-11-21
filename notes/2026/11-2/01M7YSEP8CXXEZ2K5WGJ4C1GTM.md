---
id: 01M7YSEP8CXXEZ2K5WGJ4C1GTM
created: 2026-11-21T10:11:56.812471Z
updated: 2026-11-21T10:11:56.812471Z
type: task
title: Two data subject request tests fail now and then because of the clock
assignee: steve
priority: low
label: tech_debt
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2059
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