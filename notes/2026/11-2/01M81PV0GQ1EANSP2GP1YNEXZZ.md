---
id: 01M81PV0GQ1EANSP2GP1YNEXZZ
created: 2026-11-22T13:23:58.103966Z
updated: 2026-11-23T19:36:40.368071Z
type: task
title: Attestations wording after reading groups — the menu says "roles", and Who reads what has a second Export beside the page's
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2099
sprint: sdy0mr7
comments:
- id: 01M81RPN1XRF4P93105Q7C7BE2
  author: Steve Vine
  at: 2026-11-22T13:56:32.445873Z
  text: |-
    Done: merged in PR #2082 and on staging (7d818ebe6). The browser smoke is green.

    Pre-UAT on staging, E2E Test Company, as E2E Admin A: **Passed**.
    - **Menu:** the Compass menu's Attestations line reads "Policies each reading group is asked to read and sign — who has, who is late."
    - **Download CSV:** Attestations ▸ Who reads what has the page's Export, and the grid's button is now "Download CSV". Those are the only two download buttons on the screen.

    Screenshot: ~/compass-uat/attestations-tweaks/COM-2099/
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Sprint "Attestations - Tweaks and Improvements". Found in Claude's pre-UAT pass on staging (f71fdd72e), 22 Nov.

## What people see now
- The Compass menu describes Attestations as "Policies the people in each role read and sign — who has, who is late". Content is assigned to reading groups now (ADR 0168), not roles.
- Attestations ▸ Who reads what has its own **Export** button (a CSV of the grid) just under the page's **Export** (the evidence export). Two buttons with the same name do different things.

## Change
- Menu: "Policies each reading group is asked to read and sign — who has, who is late."
- The grid's button becomes **Download CSV**.

## Done when
- The menu's Attestations line names reading groups.
- Who reads what has one Export (the page's) and a Download CSV for the grid.

Independent (no migration, no API change).