---
id: 01M7WZJMQR1DWARKYG5ARR4V5B
created: 2026-11-20T17:20:28.920671Z
updated: 2026-11-20T18:14:08.907546Z
type: task
title: A flowchart's Zoom, Full screen and Download buttons can be seen and clicked on the Edit tab
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2035
sprint: s6y6p7g
comments:
- id: 01M7X2MSSJV31FPDQYNPWGFW32
  author: Steve Vine
  at: 2026-11-20T18:14:05.362494Z
  text: |-
    Done — PR #2029, merged c3b7586d.
    On the Edit tab a flowchart's Zoom out, Zoom in, Full screen and Download now sit over its picture, where they can be seen and clicked. This works for a document's own flowchart and for a standalone one, with "Show as on paper" on and off, selected or not. Full screen opens, Zoom zooms and Download offers its menu, and none of them changes the document.
    They still pass under the section's sticky toolbar when the page scrolls (COM-2022), and under the picture settings panel.
    Cause: not COM-2022 itself. The editor lifts every part of the document to the same layer, and the flowchart's picture comes after its buttons, so it was drawn over them. The buttons now sit one layer above the picture, inside it.
    Measured in a real browser on staging data: before, all 16 buttons were under the picture; after, all 16 are on top, and the same in the "every kind of picture" document.
    Images and text diagrams have no reading buttons on the Edit tab, only on the Read tab, where they were already on top (re-checked).
    Tests: a check that the buttons' layer beats the editor's and stays under the toolbar. The Browser smoke's journey 6 now checks that Full screen on a just-drawn flowchart is on top, and clicks it.
    To check on staging: hover a flowchart on the Edit tab and use each button.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found in Claude's pre-UAT round 4 (staging b65d7ed8, tester B).

On the Edit tab, a flowchart's Zoom, Full screen and Download buttons sit underneath its picture, so they can't be seen or clicked. The tester could only open full screen by script. The Read tab is fine. COM-2004 gave every picture these buttons, so this may be a regression from COM-2022, which changed the flowchart block's stacking, or from COM-2027's picture changes.

**Done when**
- On the Edit tab, a flowchart's Zoom, Full screen and Download buttons show and work, for a document's own flowchart and for a standalone one, with "Show as on paper" on and off, selected and not.
- They still go under the sticky section toolbar when scrolled (COM-2022).
- Images and text diagrams are checked too.
- A test checks the buttons are on top of the picture and clickable.