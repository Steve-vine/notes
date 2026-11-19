---
id: 01M7V3M4H5J44J3MPBAVDM3S67
created: 2026-11-19T23:52:43.301166Z
updated: 2026-11-19T23:52:50.039378Z
type: task
title: A flowchart can't be set wider than it can be shown, so its tools and caption stay on it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2011
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Found in pre-UAT of round 3, by Tester B on staging 7ea67f64, against COM-2004 and COM-1998.

**Steps:** drag a flowchart's corner past its own size (the editor saves e.g. 60%), then hover it on the Read tab.

**Seen:**
- The flowchart stays at its own 192 px, but its frame is 408 px wide.
- The reading tools float 210 px to the right, over empty page.
- The caption is centred under the empty frame, on the Read tab and in the PDF.
- Dragged smaller (20%), it is fine.

Screenshots: ~/compass-uat/s6y6p7g/COM-2004/r3-read-flowchart-tools-detached.png, r3-export3-pdf-page3.png

**Done when**
- A flowchart's corner handle can't make it bigger than the largest size it is shown at: its own size, capped at the text width. The drag stops there.
- A flowchart already saved with a width bigger than that shows with its frame the size of the picture: the tools on the picture's corner and the caption under the picture, in the editor, the Read tab, the PDF and Word.
- The same holds for any other picture kind that is never shown larger than its own size.
- Tests cover dragging past the flowchart's own size and a saved oversized width, with the tools and caption on the picture.

Independent: frontend (pictureResize, FlowchartFigure), plus the PDF render's frame if it needs it.