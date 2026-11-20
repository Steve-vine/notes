---
id: 01M7WMCNVWZG168Q8PHGFJ9454
created: 2026-11-20T14:04:59.132767Z
updated: 2026-11-20T15:10:46.678868Z
type: task
title: On the Edit tab a flowchart scrolls under the section's toolbar, not over it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2022
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Steve (testing round 3): on the Content Edit tab, each section's toolbar stays fixed at the top so it's always visible while scrolling. When the page scrolls down, flowcharts pass over the top of the toolbar. Nothing else does this, only flowcharts.

**Done when**
- Scrolling the Edit tab, a flowchart passes under the section's toolbar, the same as pictures, diagrams and tables. This applies to a document's own flowchart and to a standalone flowchart added to the document.
- The same holds with "Show as on paper" on and off, and while the flowchart is selected (its frame, resize corner and buttons go under the toolbar too).
- Full screen and the right-hand settings panel still show above everything, as they do now.
- Tests check that the toolbar stays on top of a flowchart.