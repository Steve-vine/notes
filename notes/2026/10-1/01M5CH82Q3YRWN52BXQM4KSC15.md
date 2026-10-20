---
id: 01M5CH82Q3YRWN52BXQM4KSC15
created: 2026-10-20T11:30:48.163423Z
updated: 2026-10-20T11:30:51.232468Z
type: task
title: Tests that run across midnight UTC (01:00 BST) pass instead of failing on a date one day out
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1152
sprint: sjlj05e
assignee: steve
label:
- bug
- follow_up
priority: medium
task_status: todo
---
Found 2026-10-20 reviewing the overnight sprints for COM-1124. **Chain:** independent (tests only).

## What happens

PR #1128 (COM-1135), run 39344448987, attempt 1:

`tests/test_actions.py::test_aggregates_all_sources - AssertionError: assert '2026-10-18' == '2026-10-17'`

The other 3,132 tests passed, and the rerun passed.

`test_actions.py` sets `_TODAY = datetime.now(UTC).date()` at **module import**, i.e. at collection. The fixture seeds "Overdue gap" with `target_date=past.date()`, where `past` is `now() - 2 days` taken **when the fixture runs**. The attempt started at about 23:55 UTC and collected before midnight; the fixture ran after it. So the expected date (19th − 2) and the seeded one (20th − 2) differ by a day.

The app is not at fault: it judges "overdue" against the date at request time. This is a test bug, and it fails any PR whose integration run spans 00:00 UTC. Overnight sprints routinely do.

## Fix

- In `test_actions.py`, derive the expected date from the same instant the fixture used. Expose the seeded `past`/`today` from the fixture, or read the date back from the seeded row; don't recompute "today".
- Audit the other modules that set a module-level `_TODAY`/`TODAY` and fix any that compare it with dates created later:
  - `test_framework_target_level.py`
  - `test_posture.py`
  - `test_posture_backfill.py`
  - `test_inventory_support.py`
  - `test_attestation_resign.py`
  - `test_attestation_compliance.py`
  - `test_attestation_assignments.py`
  - `test_attestation_open.py`
  - `test_portal_attestations.py`

  Where a module-level date is only compared with dates built from that same value, it's safe; say so in a one-line comment.
- Prove it with a test that changes the clock between collection and the fixture. One way: monkeypatch the module's `datetime` or `_TODAY` to the day before, and check the assertion still holds. That keeps the fix from regressing quietly.

**Done when:** none of those modules can disagree about "today" across midnight UTC, the proof test is in place, and the integration suite is green.