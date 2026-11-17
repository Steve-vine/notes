---
id: 01M7MJFM7V5N3B31XGEBTY98BC
created: 2026-11-17T10:57:43.163179Z
updated: 2026-11-17T10:57:51.246486Z
type: task
title: A check's move shows on its own Changes, and a control's History shows coverage and move lines even before it's assessed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1895
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: active
---
From the pre-UAT pass of round 3 (staging 44d15b9a), COM-1875 and COM-1880.

**The problems.**
1. Moving a check to another control (CHC-2: ACC.13 → ACC.12, in Edit) records "moved CHC-n from X to Y: reason" on the old control's History and in the API. The check's own Changes list never shows it, though COM-1875 promised it there. Screenshot: ~/compass-uat/s7nqsy0/COM-1875/chc2-after-m1.png
2. A control's History tab hides coverage and move lines when the control isn't assessed. On IDM.13 (not assessed), Confirm, then Manual only, then Partly: the API (/checks/history) has all three lines, but the tab shows "History 0 · Not assessed yet." On an assessed control (ACC.13) they show. Screenshot: ~/compass-uat/s7nqsy0/COM-1880/IDM.13-history.png

**Done when**
- After a move, the check's Changes shows "Moved from <old control> to <new control>: <reason>", by whom and when. Both controls' History show it too.
- A control's History tab shows every coverage line (changed, confirmed, Manual only, To confirm) and every move line, whether or not the control has been assessed. "Not assessed yet" only shows when there's nothing at all.
- After a move, the move dialog and its confirmation name both controls.
- Tests cover a move on the check's Changes, and the History of a control that isn't assessed.