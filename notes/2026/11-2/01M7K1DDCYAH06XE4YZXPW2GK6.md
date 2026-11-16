---
id: 01M7K1DDCYAH06XE4YZXPW2GK6
created: 2026-11-16T20:40:10.398442Z
updated: 2026-11-16T23:12:20.018102Z
type: task
title: Show whether a check collects records or a snapshot, on the Evidence Collection list and in Details
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1876
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: active
---
From Steve's testing of round 2 (staging 43d03f09).

Whether a check collects **records** (things that happen, each with a date, collected period by period) or a **snapshot** (how something is set up, kept "as at" the day it runs) is only implied today by the "Collects" sentence.

**Done when**
- Evidence Collection ▸ All checks has a **Kind** column reading "Records" or "Snapshot". The column sorts like the others, and the list can be filtered by it, with the filter kept in the address like the other filters.
- A check's Details shows "Kind: Records" or "Kind: Snapshot", read-only, beside Collects. Hovering over it explains the word in a line: "Collects each period's records by their date" for Records, and "Keeps how it's set up on the day it runs" for Snapshot.
- Proposed checks waiting for Review show their kind the same way.
- The screen-conventions test passes, and there's a test for the column, its sort and filter, and the Details line.

**Where** (for the builder): pages/ChecksPage.tsx, checks/NoRuleCheckPage.tsx (Details), and the check list's API, if it doesn't already return the kind.