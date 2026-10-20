---
id: 01M58P1TEWSREZRCEXF3K70KHJ
created: 2026-10-18T23:37:48.252562Z
updated: 2026-10-20T13:43:22.013367Z
type: task
title: The report-schedule tests fail when CI runs them in the first minute after midnight UK time
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1103
comments:
- id: 01M5CRTRA3J82JKVK31GF2BRJK
  author: Steve Vine
  at: 2026-10-20T13:43:20.130815Z
  text: |-
    Merged in PR #1151 at 13:41 UTC on 2026-10-20 (main 6583a192). Tests only; scheduled reports themselves were already correct.

    **What changed**
    - The `_scheduled()` helper's daily schedule moves from 00:01 to **00:00** UK time. 00:00 is the one local time of day that has always already passed, so the schedule is genuinely due on any pass. The docstring explains why.
    - A new parametrized `clock` fixture runs the six delivery tests twice:
      - on the real clock;
      - with the task's `datetime.now` pinned to 00:00:30 Europe/London (2026-10-19), with every other timestamp left real.
    - My call: fix the schedule rather than freezing the clock in every test, so the tests still run against the real clock too. The pinned run is the proof.

    **Checks**
    - With 00:01 put back, the pinned run failed exactly the five tests PR #1085 lost; the disabled-schedule test passed, as it did then.
    - With 00:00, all 23 tests in the file pass locally (real Postgres, sequential).
    - ruff check, ruff format --check, and the import-time date guard from COM-1152 all pass.
    - CI run 39427595118: green, 34.5 min in total, backend-test 29.4 min (it queued 3.9 min first, with three PR runs sharing g5). The frontend job was skipped, since no frontend files changed.

    **Done when** ("the five tests pass with the clock set to 00:00:30 Europe/London") is met: the pinned variants pass, in CI on every PR.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Found 2026-10-18 on PR #1085 (COM-1095): `backend-test` failed with five failures in `tests/test_report_schedules.py`, all with `assert 0 == 1` or `NoResultFound`. Re-running the job later passed. Nothing in that PR touches reports.

## Why

The tests' `_scheduled()` helper makes a daily schedule at **00:01** UK time and says it is "due on any pass". It isn't. The job ran at 23:00:13 UTC, which is 00:00:13 BST, so today's 00:01 slot hadn't arrived yet and `send_scheduled_reports()` sent nothing.

## Fix

Make the helper's schedule genuinely due whatever the clock says: either freeze "now" in the test, or set `at_time` to a moment already past in UK local time. Tests only; scheduled reports themselves behave correctly.

**Done when:** the five tests pass with the clock set to 00:00:30 Europe/London.