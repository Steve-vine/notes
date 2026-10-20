---
id: 01M58P1TEWSREZRCEXF3K70KHJ
created: 2026-10-18T23:37:48.252562Z
updated: 2026-10-20T12:59:02.874633Z
type: task
title: The report-schedule tests fail when CI runs them in the first minute after midnight UK time
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1103
assignee: steve
label:
- bug
priority: low
task_status: active
---
Found 2026-10-18 on PR #1085 (COM-1095): `backend-test` failed with five failures in `tests/test_report_schedules.py`, all with `assert 0 == 1` or `NoResultFound`. Re-running the job later passed. Nothing in that PR touches reports.

## Why

The tests' `_scheduled()` helper makes a daily schedule at **00:01** UK time and says it is "due on any pass". It isn't. The job ran at 23:00:13 UTC, which is 00:00:13 BST, so today's 00:01 slot hadn't arrived yet and `send_scheduled_reports()` sent nothing.

## Fix

Make the helper's schedule genuinely due whatever the clock says: either freeze "now" in the test, or set `at_time` to a moment already past in UK local time. Tests only; scheduled reports themselves behave correctly.

**Done when:** the five tests pass with the clock set to 00:00:30 Europe/London.