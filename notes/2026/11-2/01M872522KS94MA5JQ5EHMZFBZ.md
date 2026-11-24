---
id: 01M872522KS94MA5JQ5EHMZFBZ
created: 2026-11-24T15:17:53.875138Z
updated: 2026-11-24T16:28:37.054145Z
type: task
title: Pressing Enter in the Add department window saves it, as it does in the Create company window
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2142
sprint: sectbn9
comments:
- id: 01M8733E2EERZDHJEYA85Y8SK0
  author: Steve Vine
  at: 2026-11-24T15:34:29.198469Z
  text: |-
    Built and merged to main: PR #2133 (754ee7623). Screen only.

    What people see:
    - Admin → Companies → a company → Departments: in Add department, pressing Enter adds the name, as clicking Add does. In Rename, Enter saves.
    - An empty name does nothing on Enter, like the greyed-out button, and Enter pressed twice while saving doesn't send twice.
    - A duplicate still shows its message, and the window stays open.

    Tested: Vitest for Enter adds (and empty sends nothing), Enter renames, and Enter on a duplicate shows the message. CI green.

    Not checked yet: in a browser. It's re-checked on staging after the next deploy.
- id: 01M8766HSYKDY4G18ARKP4MVSC
  author: Steve Vine
  at: 2026-11-24T16:28:37.053983Z
  text: |-
    Pre-UAT recheck on staging c7e9ad0d6 (includes this fix), E2E Test Company, as E2E Admin A: **Passed**.
    - Add department: typed "it" and pressed Enter. The window stayed open with "E2E Test Company already has a department called IT".
    - Typed "E2E Temp Enter 1628" and pressed Enter: added (Departments · 4), and the window closed.
    - Rename: changed it to "E2E Temp Renamed 1628" and pressed Enter: saved.
    - Deleted the temporary department afterwards. E2E Test Company is back to Finance, Operations, IT.
    Screenshots: ~/compass-uat/sectbn9/COM-2142/
assignee: steve
label:
- bug
priority: low
task_status: review
---
Sprint "Vendor Departments". Found in the pre-UAT pass of COM-2131 on staging 0234a65f3 (24 Nov 2026).

## The problem
Admin → Companies → a company → Departments → Add department: typing a name and pressing Enter does nothing. You have to click Add. The Create company window's Departments section (COM-2132) does take Enter, so the two behave differently.

## What people see
- In the Add department window, and in Rename, pressing Enter saves, just as clicking the button does.
- A duplicate or empty name is refused the same way as with the button.

## Done when
- Enter saves in both the Add and Rename windows, and a duplicate still shows its message.

Independent: screen only, no migration or API change.