---
id: 01M5BSZVW4DP237BZVCH1VPF2V
created: 2026-10-20T04:44:21.764155Z
updated: 2026-10-20T15:55:34.710369Z
type: task
title: The Actions aggregate test passes when a CI run crosses midnight
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1149
comments:
- id: 01M5CP9F4MGBDBQZS5Y9XX6A4T
  author: Steve Vine
  at: 2026-10-20T12:58:56.531998Z
  text: |-
    Done by COM-1152's PR, #1145, merged at 12:58 UTC on 2026-10-20 (main a98d2898).

    - `test_aggregates_all_sources` now checks against the target date the fixture stored, rather than a "today" taken at import, so a run across midnight UTC passes.
    - A new guard test (`tests/test_no_import_time_dates.py`) fails if any test module takes today's date at import again.

    Details are on COM-1152.
assignee: steve
label:
- tech_debt
priority: low
task_status: done
---
Follow-up from sprint 79 (CI flake, 2026-10-20 00:08 UTC on PR #1128).

`tests/test_actions.py::test_aggregates_all_sources` failed with `assert '2026-10-18' == '2026-10-17'`: the test computes `_TODAY` once at import, and the run started before midnight and reached that test after it, so the expected overdue date was a day behind the data. A rerun passed. Same family as COM-1103.

**Fix:** compute today inside the test (or freeze the clock), so a run that crosses midnight still passes.