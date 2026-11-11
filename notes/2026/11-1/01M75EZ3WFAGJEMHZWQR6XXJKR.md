---
id: 01M75EZ3WFAGJEMHZWQR6XXJKR
created: 2026-11-11T14:07:39.919111Z
updated: 2026-11-11T17:50:41.514403Z
type: task
title: Marking a document as reviewed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1731
comments:
- id: 01M75VQEWW3JPN775THRV9HTNG
  author: Steve Vine
  at: 2026-11-11T17:50:40.54002Z
  text: |-
    Done. PR #1727 (auto-merge on).

    What you see: press Review… on a document's Edit tab and mark it reviewed, and the Last reviewed and Next review dates change straight away, with no refresh.

    Cause: the two date fields on the Edit tab were filled once when the tab opened and never re-read the updated document. Compass was already returning the new dates. They now follow the saved document.

    Other routes checked and covered by tests:
    - Publish with "Mark as reviewed";
    - the Read tab Details and the Review record;
    - the content list;
    - an initiative's review.

    Frontend only. 2 new Vitest tests; the full suite passed (3,877 tests); eslint, tsc and prettier are clean.
assignee: steve
label: null
priority: medium
task_status: review
---
Marking a document as reviewed doesn't immediately change the last/next review date, you have to refresh the screen to see it.