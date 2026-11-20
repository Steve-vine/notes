---
id: 01M7WZJMQR1DWARKYG5ARR4V5B
created: 2026-11-20T17:20:28.920671Z
updated: 2026-11-20T19:18:01.211541Z
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
- id: 01M7X69VQVRXPYGBH6K1HSMRG5
  author: Steve Vine
  at: 2026-11-20T19:18:01.211274Z
  text: |-
    Re-check on staging 514c4649: Passed
    All checks done as E2E Admin A in E2E Test Company, on the Edit tab of "E2E pre-UAT COM-2029 lane keeps connections". It shows a standalone flowchart (COM-1927 laned standalone) and two of its own flowcharts. For each button I checked that the topmost thing under its centre is the button itself, and clicked it with a real mouse click at that point.
    - Buttons visible and on top: Passed, for all 3 flowcharts in all 4 states (Show as on paper off and on, selected and not). All 4 buttons were on top every time: Zoom out, Zoom in, Full screen, Download. (r4re-01, r4re-02)
    - They work: Passed, for the standalone and both of the document's own flowcharts. Zoom in made the picture 1.5× larger (472×457 → 708×686), and Zoom out put it back. Full screen opened the flowchart full screen and Esc closed it (r4re-03, r4re-04). Download showed "Download the flowchart: PNG picture / SVG picture", and PNG downloaded a file (r4re-05). The document's saved text and sections were exactly the same before and after.
    - Still under the sticky section toolbar: Passed. When I scrolled a flowchart's top up to the section toolbar, all 4 buttons went under the toolbar (r4re-06). A tall flowchart that scrolls under the toolbar when clicked behaves the same.
    - Images and text diagrams: Passed, as the builder describes. In "E2E pre-UAT COM-2004 every kind of picture" on the Edit tab, only the two flowcharts (its own and a standalone) have reading buttons, and both are on top. Images, text diagrams and the drawing have none there. On the Read tab all 7 pictures have all 4 buttons, and all are on top. (r4re-08)
    - Test: Passed. pictureToolsOnTop.test.ts was added, and the Browser smoke's journey 6 now clicks Full screen.
    Observations:
    - Clicking a reading button on the Edit tab also selects the flowchart and opens its settings panel. Nothing changes, but it's a little surprising.
    - I couldn't get the buttons under the picture settings panel. At 1000 px wide the panel moves below the flowchart instead of covering it.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2035/ (r4re-*)
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