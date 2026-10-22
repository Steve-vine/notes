---
id: 01M5JY4D0SQDF9TN6QFXRJ3HDN
created: 2026-10-22T23:11:25.721419Z
updated: 2026-10-22T23:11:25.721419Z
type: task
title: A vendor-review assistant test fails just after UK midnight because it takes "today" from UTC
task_status: active
priority: medium
assignee: steve
label: tech_debt
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1267
---
Found 2026-10-23 00:09 BST on PR #1246 (COM-1235), whose backend-test ran in the first hour of the UK day. Same family as COM-1243: `tests/test_assistant_vendors_reviews.py::test_a_review_moves_compliance_via_the_assistant` expects the next review as 12 months after `date.today()` (the UTC date) while the app uses the UK day ("2027-10-23" vs "2027-10-22").

**Chain:** independent (tests only)

**Fix:** take today as the UK day (`time_zones.today_in(deployment_zone())`); check the file's other `date.today()` uses with the clock at 23:30 UTC.

**Done when:** the file passes with the clock at 23:30 UTC and at the real time.