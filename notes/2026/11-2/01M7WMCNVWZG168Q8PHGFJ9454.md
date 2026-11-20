---
id: 01M7WMCNVWZG168Q8PHGFJ9454
created: 2026-11-20T14:04:59.132767Z
updated: 2026-11-20T15:33:11.913414Z
type: task
title: On the Edit tab a flowchart scrolls under the section's toolbar, not over it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2022
sprint: s6y6p7g
comments:
- id: 01M7WSE4J1PMXS7Y05A6N8HGNK
  author: Steve Vine
  at: 2026-11-20T15:33:09.825669Z
  text: |-
    Done — PR #2021, merged 0b2f5497.
    On the Edit tab, scrolling now takes a flowchart under the section's toolbar, the same as pictures, diagrams and tables. That applies to a document's own flowchart and to a standalone one added to the document.
    It holds with "Show as on paper" on or off, and while the flowchart is selected: its frame, corner handle and buttons go under the toolbar too.
    The right-hand settings panel and full screen still show above everything.
    Cause: the editor's built-in styles put the flowchart's frame one level above the toolbar. Pictures are built differently, so the rule never touched them. The toolbar now sits above everything in the document.
    Checked in a real browser before and after. Before, the flowchart covered the toolbar; after, the toolbar stays on top for a picture, a document's own flowchart and a standalone one.
    To check on staging: a long document with a flowchart. On the Edit tab, scroll so the flowchart passes the section toolbar, with "Show as on paper" on and off, and once with the flowchart selected.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Steve (testing round 3): on the Content Edit tab, each section's toolbar stays fixed at the top so it's always visible while scrolling. When the page scrolls down, flowcharts pass over the top of the toolbar. Nothing else does this, only flowcharts.

**Done when**
- Scrolling the Edit tab, a flowchart passes under the section's toolbar, the same as pictures, diagrams and tables. This applies to a document's own flowchart and to a standalone flowchart added to the document.
- The same holds with "Show as on paper" on and off, and while the flowchart is selected (its frame, resize corner and buttons go under the toolbar too).
- Full screen and the right-hand settings panel still show above everything, as they do now.
- Tests check that the toolbar stays on top of a flowchart.