---
id: 01M5BSZVW4DP237BZVCH1VPF2V
created: 2026-10-20T04:44:21.764155Z
updated: 2026-10-20T12:17:50.579912Z
type: task
title: The Actions aggregate test passes when a CI run crosses midnight
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1149
assignee: steve
label: tech_debt
priority: low
task_status: todo
---
Follow-up from sprint 79 (CI flake, 2026-10-20 00:08 UTC on PR #1128).

`tests/test_actions.py::test_aggregates_all_sources` failed with `assert '2026-10-18' == '2026-10-17'`: the test computes `_TODAY` once at import, and the run started before midnight and reached that test after it, so the expected overdue date was a day behind the data. A rerun passed. Same family as COM-1103.

**Fix:** compute today inside the test (or freeze the clock), so a run that crosses midnight still passes.