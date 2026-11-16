---
id: 01M7K1DDCYAH06XE4YZXPW2GK6
created: 2026-11-16T20:40:10.398442Z
updated: 2026-11-16T23:51:00.017575Z
type: task
title: Show whether a check collects records or a snapshot, on the Evidence Collection list and in Details
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1876
sprint: s7nqsy0
comments:
- id: 01M7KCANP0DAB05B1DT65Z9JVZ
  author: Steve Vine
  at: 2026-11-16T23:50:54.912227Z
  text: |-
    Done — PR #1869, merged a9d847dd.
    Evidence Collection ▸ All checks has a Kind column reading "Records" or "Snapshot". It sorts like the other columns, and a Kind filter sits beside Reads, kept in the address.
    A collected check's Details shows "Kind: Records" or "Kind: Snapshot" straight after Collects; hovering explains it ("Collects each period's records by their date" / "Keeps how it's set up on the day it runs").
    Proposed checks in Review show their kind the same way: on the card, and as a sortable Kind column in the New checks and Changes lists.
    Polaris's list of checks says each check's kind too.
    Assumption: Compass's own (built-in) checks read "Snapshot" — they look at how things stand on the day they run.
    To check on staging: All checks (sort, filter, reload keeps the filter), CHK-7's Details, and a proposal waiting in Review.
assignee: steve
priority: medium
task_status: review
---
From Steve's testing of round 2 (staging 43d03f09).

Whether a check collects **records** (things that happen, each with a date, collected period by period) or a **snapshot** (how something is set up, kept "as at" the day it runs) is only implied today by the "Collects" sentence.

**Done when**
- Evidence Collection ▸ All checks has a **Kind** column reading "Records" or "Snapshot". The column sorts like the others, and the list can be filtered by it, with the filter kept in the address like the other filters.
- A check's Details shows "Kind: Records" or "Kind: Snapshot", read-only, beside Collects. Hovering over it explains the word in a line: "Collects each period's records by their date" for Records, and "Keeps how it's set up on the day it runs" for Snapshot.
- Proposed checks waiting for Review show their kind the same way.
- The screen-conventions test passes, and there's a test for the column, its sort and filter, and the Details line.

**Where** (for the builder): pages/ChecksPage.tsx, checks/NoRuleCheckPage.tsx (Details), and the check list's API, if it doesn't already return the kind.