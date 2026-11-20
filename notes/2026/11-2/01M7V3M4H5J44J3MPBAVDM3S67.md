---
id: 01M7V3M4H5J44J3MPBAVDM3S67
created: 2026-11-19T23:52:43.301166Z
updated: 2026-11-20T14:05:05.26714Z
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
- id: 01M7VAPY7C5PXCTAY2SF0SPZSE
  author: Steve Vine
  at: 2026-11-20T01:56:35.180395Z
  text: |-
    Pre-UAT on staging 0ed475e8 — Passed
    Tested as E2E Admin A, E2E Test Company, in "E2E pre-UAT COM-2004 every kind of picture" (its own flowchart was saved at 60%, wider than its own 192 px, and there's a standalone flowchart at 20%) and "E2E pre-UAT COM-2009 unresized pictures" (an own flowchart and a standalone flowchart, neither resized). Own headless Chromium, paper on, sizes in pixels.
    - The corner handle stops at the flowchart's own size: Passed.
      - Own flowchart (centred): dragged down-right well past its size: 190 px (28%) and no further, all the way to +300/+500 px. Dragged smaller first: 136, then 102 px, so shrinking still works.
      - Standalone flowchart (left, 20%): 136 → 170 → 190 px, then it stays at 190 px (28%) however far I drag.
      - The frame follows the picture throughout (frame = picture width at every step).
    - A flowchart saved wider than itself is framed by its picture: Passed, for the one saved at 60%:
      - Editor, paper on and off: frame 192 = picture 192; tools 6 px in from the picture's top-right corner; caption centred under it.
      - Read tab, Left, Centre and Right: frame 192 each time; tools 6 px in from the picture's corner; caption centre = picture centre (300/300, 544/544, 788/788) and 6 px below it.
      - Zoomed in: the frame stays 192 and the picture pans inside it; the tools stay on the frame's corner.
      - PDF: the figure's box is 192 px wide and the caption's centre is exactly under it (152.7 px).
      - Word: the flowchart is 192×342; its caption (left-placed) has a right indent that leaves exactly 192 px, so it's centred under the picture. The same for the left-placed drawing (272 px).
    - Other kinds never shown above their own size: Passed. That only applies to flowcharts: images, drawings and diagrams can be made bigger. Both flowchart kinds (own and standalone) are capped.
    - Tests: Passed (widthCap.test.tsx; test_flowchart_pages.py for the PDF figure).
    Observations:
    - For a small flowchart, Full width in the settings panel can still be chosen. It's saved as Full width but shows at the flowchart's own size, framed by the picture, so nothing visibly changes. I put it back to Left.
    - A sideways-only drag of a tall flowchart's corner does nothing; you have to drag down or up as well. That follows the "corner follows the pointer" rule (COM-2007) on a picture much taller than wide.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2011/ (r3re-read-oversized-left-hover.png, r3re-read-oversized-centre.png, r3re-read-oversized-right.png, r3re-read-oversized-zoomed.png, r3re-standalone-drag-past-own.png, r3re-own-drag-past-own.png); PDF/Word in ~/compass-uat/s6y6p7g/COM-2010/r3re-every-kind.*
assignee: steve
label:
- bug
priority: medium
task_status: done
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