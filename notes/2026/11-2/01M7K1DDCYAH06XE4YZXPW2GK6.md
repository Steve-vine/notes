---
id: 01M7K1DDCYAH06XE4YZXPW2GK6
created: 2026-11-16T20:40:10.398442Z
updated: 2026-11-17T19:50:15.230955Z
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
- id: 01M7MJ2KQG218P31K6JFQS4731
  author: Steve Vine
  at: 2026-11-17T10:50:36.656432Z
  text: |-
    Pre-UAT on staging 44d15b9a — Passed
    - Kind column on All checks, sortable, filterable, filter kept in the address: as E2E Admin A, All checks has a Kind column. Every E2E check reads "Snapshot" (the 12 built-in checks and CHC-2). Sort by Kind puts sort=kind in the address. Kind filter offers All / Records / Snapshot. Records gives 0 checks, Snapshot gives 13, and after a reload the address (kind=records) and the filter stay. Test Company (where I was already looking for COM-1878 and COM-1886) has Records checks (CHC-7, CHC-24, CHC-25, CHC-26). There, Kind = Records lists exactly those four, and sorting by Kind puts Records first. Passed.
    - Details shows "Kind: …" read-only after Collects, with an explanation on hover: CHC-2 shows "Kind: Snapshot" straight after "Collects", and hovering shows "Keeps how it's set up on the day it runs". Test Company's CHC-7 shows "Kind: Records", and the Records word in Review explains "Collects each period's records by their date". Passed.
    - Proposed checks waiting for Review show their kind: in E2E, the proposal cards (CHC-3 replacing CHC-2, and CHC-1 on ACC.13) show "Kind: Snapshot". Test Company's Review ▸ Changes list has a Kind column (CHC-24 reads Records). Passed, with one observation: in E2E's Review lists (Changes, New checks) there's no Kind column at all. The list only shows it when a proposal has its kind recorded, and these older proposals don't, although their cards say "Kind: Snapshot".
    - Tests and screen conventions: the staging deploy run for 44d15b9a is green. I didn't read the test files.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1876/
assignee: steve
priority: medium
task_status: done
---
From Steve's testing of round 2 (staging 43d03f09).

Whether a check collects **records** (things that happen, each with a date, collected period by period) or a **snapshot** (how something is set up, kept "as at" the day it runs) is only implied today by the "Collects" sentence.

**Done when**
- Evidence Collection ▸ All checks has a **Kind** column reading "Records" or "Snapshot". The column sorts like the others, and the list can be filtered by it, with the filter kept in the address like the other filters.
- A check's Details shows "Kind: Records" or "Kind: Snapshot", read-only, beside Collects. Hovering over it explains the word in a line: "Collects each period's records by their date" for Records, and "Keeps how it's set up on the day it runs" for Snapshot.
- Proposed checks waiting for Review show their kind the same way.
- The screen-conventions test passes, and there's a test for the column, its sort and filter, and the Details line.

**Where** (for the builder): pages/ChecksPage.tsx, checks/NoRuleCheckPage.tsx (Details), and the check list's API, if it doesn't already return the kind.