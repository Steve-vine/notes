---
id: 01M75EZ3WFAGJEMHZWQR6XXJKR
created: 2026-11-11T14:07:39.919111Z
updated: 2026-11-11T22:18:28.870663Z
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
- id: 01M76B1TM6SKH1EXT05AB0HN4W
  author: Steve Vine
  at: 2026-11-11T22:18:28.870463Z
  text: |-
    Couldn't check (Claude's pre-UAT pass, staging fcaf1d13).

    Why: checking this means marking a published document as reviewed. Every published document on staging is shared Playbook content that no test created, and the browser-testing rules forbid reviewing or publishing it. There is no E2E document I could publish to make one of my own.

    What I could see: the Review… button and its dates are on the Edit tab of each published document. I didn't press it.

    What Steve should look at:
    1. Open a published document with no draft changes (most policies; not AI Risk Assessment Standard or the Joiners, movers and leavers procedure, which have drafts) and go to the Edit tab.
    2. Press Review… and mark it reviewed.
    3. Last reviewed and Next review should change straight away, without a refresh.
    4. Also try Publish with "Mark as reviewed" on a document with a draft. The dates should change straight away there too.
assignee: steve
label: null
priority: medium
task_status: review
---
Marking a document as reviewed doesn't immediately change the last/next review date, you have to refresh the screen to see it.