---
id: 01M5JY4D0SQDF9TN6QFXRJ3HDN
created: 2026-10-22T23:11:25.721419Z
updated: 2026-10-22T23:48:49.077974Z
type: task
title: Four test files fail just after UK midnight because they take "today" from UTC (vendor reviews, recertification, SAP, software assets)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1267
comments:
- id: 01M5K08TMRGN96A5ETAREAE6RR
  author: Steve Vine
  at: 2026-10-22T23:48:47.896379Z
  text: |-
    Done — merged in PR #1247 (tests only; nothing to deploy or smoke-test).

    It grew to four test files. While its own PR ran at 00:15 BST, three more tests failed for the same reason: they took today's date from UTC while the app uses the UK day. All four now use the UK day:
    - the vendor-review assistant test (a review's next-review date);
    - recertification (a schedule's next due date);
    - SAP (a repeating entry's occurrences);
    - software assets (support state from end-of-support dates).

    Checked with the clock moved: all four files (111 tests) pass at 23:30 UTC, 00:30 UTC and the real time.

    More of this kind probably remain. COM-1243 and this task found 13 tests between them, each only when CI happened to run just after midnight. A one-off run of the whole backend suite with the clock at 23:30 UTC would find the rest in one go; worth a task if you want them cleared.
assignee: steve
label:
- tech_debt
priority: medium
task_status: review
---
Found 2026-10-23 00:09 BST on PR #1246 (COM-1235), whose backend-test ran in the first hour of the UK day. Same family as COM-1243: `tests/test_assistant_vendors_reviews.py::test_a_review_moves_compliance_via_the_assistant` expects the next review as 12 months after `date.today()` (the UTC date) while the app uses the UK day ("2027-10-23" vs "2027-10-22").

**Chain:** independent (tests only)

**Fix:** take today as the UK day (`time_zones.today_in(deployment_zone())`); check the file's other `date.today()` uses with the clock at 23:30 UTC.

**Done when:** the file passes with the clock at 23:30 UTC and at the real time.