---
id: 01M7Z51HYRD4X0DA67WTTZXTZR
created: 2026-11-21T13:34:29.336185Z
updated: 2026-11-21T13:34:32.383644Z
type: task
title: 'Manual Collection: each piece''s actions reachable without scrolling sideways on a desktop; two wording leftovers'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2073
sprint: s9hexqn
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in Claude's pre-UAT pass (staging 12bd442a5, 2026-11-21), on COM-2056 / COM-2060.

**1. Actions off-screen (the main fix).**
- **Steps:** At 1440×900, open the Assessment screen ▸ RIM.9 ▸ Overview ▸ Evidence ▸ Manual Collection, as E2E Admin A.
- **Expected:** Each piece's actions (edit details, new version, archive, take off) can be seen and clicked on a normal desktop window.
- **Seen:** The actions column is past the right-hand edge of the table, so you have to scroll the table sideways to reach the icons.
- **Screenshots:** ~/compass-uat/s9hexqn/COM-2056/rim9-manual-collection-actions.png and rim9-manual-collection-actions-scrolled.png

**2. Two leftovers from the renamed buttons.**
- The empty Exceptions page still says exceptions are "recorded with Request an exception on the control". The button is now **Request exception**, on the **Assessment screen**.
- Add to SAP shows two messages at once: "Entry added" and "INS.10 added to the SAP". Keep only the second.

**Done when**
- At 1440 and 1280 wide, each Manual Collection row's actions are visible without scrolling sideways on the Assessment screen. Use whichever works best: keep the actions column pinned at the right edge, drop or narrow a less useful column in this narrower middle column, or move the actions into a row menu.
- The Control screen's Evidence tab (where Viewers and others see the same table without actions) still looks right.
- On a phone the table still scrolls sideways as now.
- The empty Exceptions wording points to Request exception on the Assessment screen.
- Add to SAP shows one confirmation.

Frontend only. Independent.