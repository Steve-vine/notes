---
id: 01M785WF6G47SPHBZKZ3NCN64V
created: 2026-11-12T15:26:39.312485Z
updated: 2026-11-13T01:59:45.884028Z
type: task
title: 'On a phone, the Dashboard doesn''t scroll sideways: its "Compliance by domain" table scrolls inside itself'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1763
sprint: spsp226
comments:
- id: 01M78Y62CDC1CVTBG05TD1F919
  author: Steve Vine
  at: 2026-11-12T22:31:19.693528Z
  text: |-
    Built — PR #1765 (auto-merge set; frontend only).

    At 390px the Dashboard no longer slides sideways (overflowed by 175px before, 0 now); the "Compliance by domain" table scrolls sideways inside its own frame. From 768px up nothing changes — same position and column widths at 1440px, headings still stick as you scroll.

    Choice: the table only scrolls inside its frame below 768px; doing it at every width would stop its headings sticking on desktop.

    Checked with the real test accounts (Admin A, Viewer) in E2E Test Company, light and dark, 390 and 1440px, console clean — local build pointed at staging, nothing saved. phone.spec.ts now checks the Dashboard at 390px (fails on today's staging, passes on this branch). Dashboard test, eslint, tsc, prettier pass; CI green. Screenshots ~/compass-uat/spsp226/COM-1763/.
- id: 01M79A3QEW18ST9A4ECN2D32E0
  author: Steve Vine
  at: 2026-11-13T01:59:45.88382Z
  text: |-
    Pre-UAT on staging (6e988b9d), E2E Test Company: **Passed**.
    As Admin A and the Viewer at 390×844, light and dark: the page and its scrolling area overflow sideways by 0px; the "Compliance by domain" table's frame ends at x=361 and scrolls sideways inside itself by 205px without moving the page. At 1440 (Admin A): table 907px, columns 377/170/150/110/100, headings still stick, no sideways scroll. Console clean. The phone Browser smoke checks the Dashboard. Screenshots ~/compass-uat/spsp226/COM-1763/com1763-01..05-*.png.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Found by the COM-1759 builder (sprint 116 round 3, 2026-11-12), checking the phone top bar at 390 px.

**What happens:** at 390 px the Dashboard page is 175 px wider than the screen, so the whole page scrolls sideways. The cause is the "Compliance by domain" table, which widens the page instead of scrolling inside its own frame. (COM-1759 fixed the top bar and the shared page header/filter bar; this is a different cause.)

**What it should do:** the Dashboard fits a phone's width; the table scrolls sideways inside itself, as SAP's schedule table does.

**Done when:**
- at 390 px, as Admin A and as the Viewer, the Dashboard doesn't scroll sideways and the table scrolls inside itself;
- desktop is unchanged;
- light and dark checked, and there are no errors in the browser console;
- the Browser smoke's phone test (app/e2e/tests/phone.spec.ts, COM-1759) also checks the Dashboard for sideways scroll.

Frontend only, independent.