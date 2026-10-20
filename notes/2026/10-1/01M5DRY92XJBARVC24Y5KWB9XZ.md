---
id: 01M5DRY92XJBARVC24Y5KWB9XZ
created: 2026-10-20T23:04:30.045304Z
updated: 2026-10-20T23:04:30.045304Z
type: task
title: Two Data Subject Request tests fail between midnight and 01:00 UK time — they compare the UK date with the server's UTC date
task_status: backlog
assignee: steve
priority: medium
label: bug
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1190
---
Found 2026-10-21 00:03 BST on PR #1172 (sprint 81 train). Not caused by that PR; nothing visible to users. Every PR's `backend-test` fails in that hour, the same class as the earlier "tests that run across midnight UTC" fix.

- `tests/test_dsr_accounting.py::test_the_first_accounting_in_twelve_months_is_free` — `assert previous["given_on"] == date.today().isoformat()` → `'2026-10-21' == '2026-10-20'`: the app records the UK day, the test expects the runner's UTC day.
- `tests/test_dsr_compliance.py::test_refusals_disclosures_retention_and_templates_export` — `KeyError: 'DSR-2'`: presumably a period/date-window filter computed on one clock and the data on the other.

## Notes (technical)

- Compare against the app's UK-day helper (or freeze the clock) instead of `date.today()`; check the compliance export's period bounds the same way. Grep `tests/test_dsr_*.py` for other `date.today()` uses.
- Reproduce by running the two tests with the clock frozen at 23:30 UTC.

**Done when:** both pass with the clock at 23:30 UTC.