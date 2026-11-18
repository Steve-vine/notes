---
id: 01M7PVGQ2WCZ0TMF72QF53PA2W
created: 2026-11-18T08:14:04.89209Z
updated: 2026-11-18T08:14:17.059664Z
type: task
title: Laid-out flowcharts route connections around steps, and no connection label is hidden
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1931
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Pre-UAT, 2026-11-18. After Compass lays a flowchart out (Tidy up, an import with no positions, a converted text diagram, or a Polaris draft), connections can run through other steps and hide their labels. The picture then shows the wrong flow, though the steps in words are right.
- COM-1913: the Yes line (Known fix? → Apply the fix) runs under "Investigate" with its Yes label hidden (~/compass-uat/s6y6p7g/COM-1913/03b-convert-preview-zoom.png, 08-converted-canvas.png).
- Lucidchart import of Steve's Minor Technology page: the line from Escalate? (No) back to Investigate runs through "Close Incident" (COM-1912/02b-minor-technology-zoom.png). Major Technology has several lines through boxes.
- Also seen: a long decision label is cut short in the import preview ("Approve…").

**Done when**
- After Tidy up (and every automatic layout: imports, conversion, Polaris), no connection passes through a step it doesn't start or end at, including loops back up the flow.
- Every connection's label is visible and not covered by a step. A long decision label wraps instead of being cut short.
- The same holds in the picture used for PDF/Word and downloads.
- Tests cover a loop back up the flow and a branch that crosses a lane, using the made-up Lucidchart fixture's shape (not Steve's file).

Independent: frontend layout and render.