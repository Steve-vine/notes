---
id: 01M785WF6G47SPHBZKZ3NCN64V
created: 2026-11-12T15:26:39.312485Z
updated: 2026-11-12T15:26:39.312485Z
type: task
title: 'On a phone, the Dashboard doesn''t scroll sideways: its "Compliance by domain" table scrolls inside itself'
assignee: steve
task_status: todo
priority: low
label: bug
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1763
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