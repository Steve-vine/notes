---
id: 01M7V3M4H5J44J3MPBAVDM3S67
created: 2026-11-19T23:52:43.301166Z
updated: 2026-11-20T00:45:05.136776Z
type: task
title: A flowchart can't be set wider than it can be shown, so its tools and caption stay on it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2011
sprint: s6y6p7g
comments:
- id: 01M7V6KXV7JK13SWEXBMQMXM98
  author: Steve Vine
  at: 2026-11-20T00:45:02.183642Z
  text: |-
    Done — PR #2008, merged 71f89379.
    A flowchart's corner handle now stops at the flowchart's own size: the biggest it is ever shown at. Full width is only possible when the flowchart is at least as wide as the page's text. Making it smaller works as before. This applies to a document's own flowchart and to a standalone flowchart shown in a document.
    A flowchart already saved wider than itself (say 60%) is now framed by its picture, in the editor and on the Read tab. The reading tools sit on the picture's corner and the caption is centred under it, whether it's placed left, centre or right, at Full width or zoomed.
    In the PDF, the flowchart's frame is the picture's width, so its caption sits under it.
    In Word, the flowchart was already shown at its own size. A caption under any picture placed left or right is now centred under the picture, not the page.
    Cached PDFs and Word files are made afresh.
    Assumptions: the drag stops at a whole percent, so at most 1% under the flowchart's own size. The Word caption change applies to every picture kind placed left or right.
    To check on staging: drag a small flowchart's corner far to the right; it stops at its own size. Open a document whose flowchart was saved wider than itself (Tester B's E2E pre-UAT COM-2004 document): on the Read tab the tools should sit on the picture and the caption under it. Then check its PDF and Word export.
assignee: steve
label:
- bug
priority: medium
task_status: review
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