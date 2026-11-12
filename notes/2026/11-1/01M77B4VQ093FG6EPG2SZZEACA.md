---
id: 01M77B4VQ093FG6EPG2SZZEACA
created: 2026-11-12T07:39:22.720258Z
updated: 2026-11-12T08:14:52.453439Z
type: task
title: 'A pinned tile cuts off a one-word name ("Vulnerabili…", "Assessme…"): the number key takes the room the name needs'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1745
sprint: spsp226
comments:
- id: 01M77D5VC0AEZ9S120EY3XSCHG
  author: Steve Vine
  at: 2026-11-12T08:14:52.288053Z
  text: |-
    Done, merged in PR #1742 (CSS only) and deployed to staging (a2523db9).

    The number on a first-row tile is now a plain faint digit in the corner, as in your design, so the name gets the tile's full width.

    Pre-UAT on staging as E2E Admin A: Passed. "Assessments" (tile 6) and "Vulnerabilities" (second row) show in full, and the numbers 1–6 are still readable in each corner.

    Screenshot: ~/compass-uat/spsp226/COM-1745/
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in the COM-1744 pre-UAT pass on staging (2026-11-12, 7ff9a75d).

**What happens:** with pins in the first row, a tile whose name is one long word is cut off with an ellipsis: "Vulnerabili…" and "Assessme…". Two-word names such as "Vendor Management" wrap onto two lines and are fine.

**Why:** the number key (1–6) sits in a bordered box in the tile's bottom-right corner, and the name keeps clear of it along its whole width. That leaves about 74px for the name, and "Vulnerabilities" needs about 78px.

**Fix:** follow the design. The number is a plain, faint digit tucked into the very corner (4px from the bottom, 7px from the right), and the name uses the tile's whole width.

**Done when:** on staging, pinned Vulnerabilities, Assessments and Inventory tiles in the first row show their names in full, with the number still readable in the corner.