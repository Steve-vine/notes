---
id: 01M7QSD5E1Q2V3SX88CC6GZEG2
created: 2026-11-18T16:56:25.793264Z
updated: 2026-11-18T22:40:02.334039Z
type: task
title: A flowchart's Full screen opens in front of the Library reader, not hidden behind it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1964
sprint: s2q1gxe
comments:
- id: 01M7QSDRQP49NE6SCEQZ2NAPWB
  author: Steve Vine
  at: 2026-11-18T16:56:45.558769Z
  text: |-
    Coordination agreed with compass-da (18 Nov, ~17:00 GMT):
    - Round 2 doesn't touch the full-screen Modal's layer. Its only change to the full-screen view is COM-1947's sun/moon button, merged as 753e34ff.
    - Either fix is fine: from the reader's side, or a zIndex on the Modal in FlowchartFigure.tsx, without asking first.
    - Rebase on origin/main right before pushing, because flowchart lanes A, B and D are still merging frontend changes.
    - Main briefly didn't compile at 68d6d9b9, a duplicate LINE_WIDTHS in render.ts, fixed in compass-da's PR #1947. Don't branch from main until that fix has landed.
assignee: steve
label:
- bug
priority: high
task_status: active
---
Steve, testing the Library on staging (18 Nov): pressing **Full screen** on a flowchart shown in a document shows nothing new, but the document stops scrolling until Escape is pressed.

**Likely cause** (to confirm when built): the full-screen view does open, but behind the reader.
- The reader is itself a full-screen layer over Compass (reader.css, z-index 200).
- The flowchart's full-screen view is a Mantine Modal (FlowchartFigure.tsx), which also sits at layer 200 by default.
- So the view opens unseen underneath the reader. The modal still locks the page's scrolling, and Escape closes it, which is exactly what Steve saw.
- The reading pane is a drawer on the same layer, so it may behave the same.

**Done when**
- In the Library reader, Full screen on a flowchart opens the full-screen view in front of everything, with its zoom, scheme toggle and close button working. Escape or close returns to the same place in the document, which scrolls normally again.
- The same holds in the reading pane, if the pane shows flowcharts with a Full screen button.
- Full screen still works in Content's Read view, in the editor, on a flowchart's own page, and in the User Portal.
- A step's links inside the full-screen view open in front of it too.
- A test opens a document with a flowchart in the reader, presses Full screen, and finds the full-screen view visible and on top.

Coordination: FlowchartFigure.tsx is Content Flowcharts code, which compass-da is changing in flowchart round 2 (COM-1940–1947, 1951–1960). Tell compass-da before changing it, or fix it from the reader's side (the layer the reader's own pop-ups open on) so as not to touch their file.

Independent: frontend only.