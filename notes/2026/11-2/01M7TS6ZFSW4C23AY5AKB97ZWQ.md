---
id: 01M7TS6ZFSW4C23AY5AKB97ZWQ
created: 2026-11-19T20:50:46.393629Z
updated: 2026-11-19T20:50:49.212427Z
type: task
title: A flowchart's Zoom in and out steps are relative to the size it's shown at
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2003
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Steve's smoke test of round 2: Zoom in on a flowchart in the Read tab isn't relative to the flowchart's size. A large flowchart gets about 50% bigger on the first click, but a small one gets 5 or 6 times bigger.

Cause (FlowchartFigure.tsx, ZOOMS = [1, 1.5, 2, 3]): each zoom step makes the picture a share of the column's width (150%, 200%, 300%), not a share of the size it was shown at. A large flowchart already fills the column, so 150% is half as big again. A small one is shown at its own small size, so 150% of the column is many times bigger.

**Done when**
- Each Zoom in step makes a flowchart the same amount bigger than it was, whatever its size: 1.5×, 2× and 3× the size it's first shown at. Zoom out steps back the same way. A small flowchart and a large one grow by the same proportion on each click.
- At the first size (no zoom), every flowchart shows as now: a large one fitted to the column, a small one at its own size.
- When zoomed past the column's width, the frame scrolls to pan inside itself as now, and the page never scrolls sideways.
- Lane names, pinned lane headings and Link spots stay on the right shapes at every zoom.
- The same holds in full screen, where the steps are relative to the size full screen first shows it at. It also holds for a standalone flowchart, on its own page and when shown in a document.
- If a picture or diagram zoom is added elsewhere, it follows the same rule. Today only flowcharts have zoom.
- Tests cover a small and a large flowchart each growing 1.5× on the first Zoom in, and back on Zoom out.

Independent: frontend reading view only.