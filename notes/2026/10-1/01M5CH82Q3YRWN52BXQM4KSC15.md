---
id: 01M5CH82Q3YRWN52BXQM4KSC15
created: 2026-10-20T11:30:48.163423Z
updated: 2026-10-20T15:55:34.721048Z
type: task
title: Tests that run across midnight UTC (01:00 BST) pass instead of failing on a date one day out
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1152
sprint: sjlj05e
comments:
- id: 01M5CP9BWEQA2ZVCJV97NQKS1R
  author: Steve Vine
  at: 2026-10-20T12:58:53.197672Z
  text: |-
    Merged in PR #1145 at 12:58 UTC on 2026-10-20 (main a98d2898). Tests only; no app change.

    **What changed**
    - `test_actions.py` no longer takes "today" at import. `test_aggregates_all_sources` checks the overdue gap's due date against the target date the fixture stored, read back from the database.
    - **Audit:** I covered every backend test module, not only the nine named.
      - The nine `_TODAY`/`TODAY` modules all use fixed dates (e.g. `date(2026, 9, 9)`), and several also pin the app's own "today". A run across midnight can't move them.
      - Four more modules keep an import-time `_NOW = datetime.now(UTC)` as a datetime: `test_conditional_access_api`, `test_report_catalogue`, `test_report_execution` and `test_report_history`. Their data sits days either side of `_NOW`, and none turns it into a calendar date, so the few minutes a run takes are harmless.
      - Each of the 13 modules now carries a one-line comment saying why it's safe.
    - **Proof:** a new unit test, `tests/test_no_import_time_dates.py`. It fails on any module-level assignment that turns the clock into a calendar date (`date.today()`, `datetime.today()`, `.now(...).date()`, `.utcnow().date()`). It also checks itself against the exact line that failed PR #1128 and against the safe shapes.
      - My call: this guard instead of monkeypatching a clock in one test. It stops the whole class of bug from coming back in any module, and it runs on every PR in about a second.

    **Checks**
    - Locally: ruff check, ruff format --check, mypy src; `test_actions.py` (14 passed, real Postgres, sequential) and the guard (2 passed).
    - CI run 39422283677: green, 25.2 min in total, backend-test 24.8 min.
      - It ran alongside the other cleanup workers' PRs.
      - The frontend job was skipped, since no frontend files changed.

    Also closes COM-1149, the same bug.
assignee: steve
label:
- bug
- follow_up
priority: medium
task_status: done
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