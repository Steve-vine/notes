---
id: 01M658KNT2BHKQKBRQ7MZWYHD7
created: 2026-10-30T02:00:51.778983Z
updated: 2026-10-30T17:20:56.445575Z
type: task
title: A reviewer without View contracts gets a refused request for the contract topics when they open a review — the topic picker shows disabled and the browser logs an error
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1462
sprint: s2v7d6y
comments:
- id: 01M66X8BEEMS48XK743EF5Z7FQ
  author: Steve Vine
  at: 2026-10-30T17:20:55.246417Z
  text: |-
    Done — PR #1479 merged.

    - A reviewer named on a review without *View contracts* no longer asks for the topics list when they open the review, so no request is refused and no error is logged.
    - The Topic field still shows the clause's own topic. Only *Review contracts* holders and the owner can change topics, and they already see the list.

    To test on staging: as E2E Viewer (named on CR-1), open CR-1 and pick a clause. The browser console shows no refused request.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Defect in COM-1440, found by Claude's pre-UAT pass (COM-1452) on staging, 2026-10-30.

## What happens

E2E Viewer was added as a reviewer by an @mention on CR-1. When they open the review, a background request for the contract topics is refused (403). The topic picker shows disabled. Nothing visible breaks, but the request fails and an error is logged every time. The browser suite treats that as a broken screen.

## Expected

A named reviewer can read the topics the review's clauses are tagged with, as they read the review itself. Or the page doesn't ask for them when the reader can't change topics.

The same class of fault as COM-1455.

**Chain:** independent unless the fix opens the topics read to reviewers (then API).