---
id: 01M7PVGQ2WCZ0TMF72QF53PA2W
created: 2026-11-18T08:14:04.89209Z
updated: 2026-11-18T08:15:12.346051Z
type: task
title: Laid-out flowcharts route connections around steps, and no connection label is hidden
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1931
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Pre-UAT, 2026-11-18. After Compass lays a flowchart out (Tidy up, an import with no positions, a converted text diagram, or a Polaris draft), connections can run through other steps and hide their labels. The picture then shows the wrong flow, though the steps in words are right.
- COM-1913: the Yes line (Known fix? → Apply the fix) runs under "Investigate" with its Yes label hidden (~/compass-uat/s6y6p7g/COM-1913/03b-convert-preview-zoom.png, 08-converted-canvas.png).
- Lucidchart import of Steve's Minor Technology page: the line from Escalate? (No) back to Investigate runs through "Close Incident" (COM-1912/02b-minor-technology-zoom.png). Major Technology has several lines through boxes.
- Also seen: a long decision label is cut short in the import preview ("Approve…").
- Tester A (COM-1904): when a branch rejoins the flow (e.g. a Hand-off connected to End), Tidy up puts every step in one row or column, the "No" connection is drawn behind four shapes, and a step can land after the step it leads into (~/compass-uat/s6y6p7g/COM-1904/04-tidy-top-bottom.png, 05-tidy-left-right.png, 16-v2-chart.png).

**Done when**
- After Tidy up (and every automatic layout: imports, conversion, Polaris), no connection passes through a step it doesn't start or end at, including loops back up the flow.
- A branch that rejoins the flow is laid out beside the main path, and every step comes in flow order: a step is never placed after the step it leads into.
- Every connection's label is visible and not covered by a step. A long decision label wraps instead of being cut short.
- The same holds in the picture used for PDF/Word and downloads.
- Tests cover a loop back up the flow, a branch that rejoins, and a branch that crosses a lane, using made-up charts shaped like the Lucidchart fixture (not Steve's file).

Independent: frontend layout and render.