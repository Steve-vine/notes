---
id: 01M59GFG3CBM3ZP6J69EE4RY47
created: 2026-10-19T07:19:39.372158Z
updated: 2026-10-19T07:19:59.365686Z
type: task
title: Every CI run records its slowest tests, so we can see where test time goes and split the suites evenly
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1110
sprint: sjlj05e
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Sprint 77, CI / Build optimisation. Raised 2026-10-19 from the review of sprint 77's tasks. Start after sprint 76 is on staging. Wanted before COM-1089 (split the test jobs) and COM-1090 (migration tests from saved copies).

## Why

CI records only a total time for each suite. We can't see which tests or files are slow, how much the migration tests cost (COM-1090's "at least halved" needs a before figure), or how to split a suite evenly (COM-1089 needs measured durations). Each investigation so far has measured by hand, once (COM-331, COM-333), and the measurements went stale as the suite doubled.

## What changes

- Every backend and frontend test run on CI publishes its slowest tests and slowest files on the run's summary page, and keeps the full timings as a download.
- Nothing about what is tested changes, and the extra reporting costs seconds.

## Notes (technical)

- Backend: add `--durations=30` to the integration and unit commands, and write `--junitxml` to a file. A short script turns the junit file into a job-summary table: top 30 tests, top 20 modules by summed time, and the migration-test files' total as one line.
- Frontend: add the `junit` reporter alongside the default (`--reporter=default --reporter=junit --outputFile.junit=…`). Same summary: top files, plus Vitest's `Duration (…)` breakdown line.
- Upload the junit files as artifacts with **short retention** (3 days): the org's Actions storage quota has blocked a release before (memory: release blocked by Actions storage quota). Or skip the artifact and keep only the summary — say which in the PR.
- These files are what COM-1089's split reads (`pytest-split`'s `.test_durations` can be generated from them). Leave the split itself to COM-1089.

**Done when:** every PR run's summary page shows the slowest tests and files for each suite that ran, the migration tests' total time is visible, and the PR includes a first reading.