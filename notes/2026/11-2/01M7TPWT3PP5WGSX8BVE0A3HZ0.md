---
id: 01M7TPWT3PP5WGSX8BVE0A3HZ0
created: 2026-11-19T20:10:16.054997Z
updated: 2026-11-20T14:05:05.124451Z
type: task
title: A flowchart in a document is shown at its own size in the editor and can be resized from its corner
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1998
sprint: s6y6p7g
comments:
- id: 01M7TYJ6YTJ012R01MXZ1ATDQK
  author: Steve Vine
  at: 2026-11-19T22:24:17.3704Z
  text: |-
    Done — PR #1996, merged 1ea4caf2.
    In the Edit tab a document's own flowchart is now shown exactly as the Read tab and a standalone flowchart show it, with the same zoom, full screen and download, and never stretched: a flowchart is never drawn bigger than its own size, as in the PDF and Word.
    Selected, either kind (a document's own or a standalone one) has the corner handle pictures have. Dragging keeps its proportions, down to half its own size so the words stay readable. Alignment (Left, Centre, Right, Full width) is in its settings panel.
    The size and place are saved with the document, including for a standalone flowchart shown in it, and the Read tab, print preview, PDF and Word all show it at that size, still whole on one page. Editing the flowchart later keeps the chosen size. A flowchart never resized keeps today's size.
    Word now follows a chosen size too, as the PDF already did.
    Assumptions: "readable" means no smaller than half its own size; a flowchart more than twice the page's width can't be made smaller. Dragging bigger than its own size shows and prints at its own size, since print never enlarges.
    To check on staging: draw a 3-box flowchart in a document; in the Edit tab it should be the same size as on the Read tab. Resize and align it and a standalone one, then check Read, print preview, PDF and Word.
- id: 01M7V3A53CRFFJW5KY1V5YBJTW
  author: Steve Vine
  at: 2026-11-19T23:47:16.204749Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Passed
    Tested as E2E Admin A. "E2E pre-UAT COM-1998 flowchart sizes" holds the document's own 3-box flowchart (672 px wide) and the same three boxes as the standalone "E2E pre-UAT COM-1998 standalone three boxes". The page's text width is 180 mm = 680 px. Sizes are the picture's own, in CSS pixels; PDF and Word converted at 96 dpi.
    - In the Edit tab the document's own flowchart is shown as a standalone one is, the same size as the Read tab and print, and never stretched: Passed. Unresized, both are 672×92 px in the Edit tab (paper off and on), on the Read tab (paper on and off), in the PDF (672.0×92.0) and in Word (177.8 mm = 672 px). Neither is stretched across the 1352 px column.
    - Corner handle on both kinds; it stays on the corner; dragging keeps proportions down to a readable minimum: Passed. The handle stayed exactly on the corner (0 px off) at every step of every drag. The aspect ratio held at 7.304 throughout. The smallest it goes is 340 px (50%, half its own size). Dragging to the column's width turns it into Full width.
    - Aligned left, centre or right with its caption and Links: Passed. Own set to Right at 476 px, standalone to Left at 442 px; each caption and Links list stays under its picture.
    - The chosen size is saved and reaches the Read tab, print preview, PDF and Word, still whole on one page: Passed. Published as v2: own 476.1×65.2 px on the right, standalone 442.1×60.5 px on the left. That is the same in the editor (paper on and off), on the Read tab (paper on and off), in the PDF/print preview (476.2×65.2 at the right margin, 442.2×60.5 at the left) and in Word (126.0 mm right-aligned, 117.0 mm left-aligned). Both are on one page.
    - Editing the flowchart later keeps the chosen size; one that grows past the column is capped: Passed. I changed a label in the canvas and pressed Done: still 476.1 px, right. A 3432 px flowchart shows at 680 px (the column/page width) in the editor and on the Read tab, and at 180 mm in the PDF and Word.
    - A never-resized flowchart keeps today's size, and nothing published changes: Passed. Unresized flowcharts show at their own size or fitted to the text width. "E2E pre-UAT COM-1960 fit to page" and "COM-1904 flowchart document" still fill the text width as in round 2. They're narrower than in round 2 only because the house style's margins are now 15 mm instead of 5 mm.
    - Tests: in the PR; not re-run here.
    Observations: (1) the Edit tab's zoom, full screen and download buttons sit under the picture and can't be clicked (the PR says the Edit tab has them; COM-2004 is Tester B's). (2) On a wide, short flowchart a little downward movement while dragging outweighs a lot of sideways movement: 25 px down grows it by about 360 px, so it jumps to Full width.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1998/ (PDF/Word r3-a-unresized.*, r3-b-resized.*, r3-c-large-capped.*)
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Steve's smoke test of round 2: he created a small flowchart with 3 or 4 shapes in a document and pressed OK. In the editor it appeared across the full width of the page, so three shapes took up a whole A4 page. There's no way to resize it.

Steve added that this only happens in one of the ways a flowchart can be shown:
- The Read tab and print preview already show the 3-box flowchart at a sensible size.
- A standalone flowchart added to a document already shows at a sensible size in the Edit tab too.

So only the document's own flowchart, in the Edit tab, is stretched. The editor is the odd one out (see COM-2000). What's missing everywhere is a way to choose the size.

**Done when**
- In the Edit tab, a document's own flowchart is shown the way a standalone flowchart added to a document already is: the same sensible size the Read tab and print preview give it. It's never stretched to fill the column. Both kinds share one way of being shown, so they can't drift apart again.
- A flowchart in the document editor, whether the document's own or a standalone one, has a resize handle on its bottom-right corner, like pictures (see COM-1997). The handle stays on the corner as you drag. Dragging resizes the flowchart and keeps its proportions, down to a sensible minimum where the words can still be read.
- The flowchart can be aligned left, centre or right, like a picture. Its caption and Links stay with it.
- The chosen size is saved with the document. The Read tab, print preview, PDF and Word all show the flowchart at that size, the same as the editor. The 1960 rule still holds: a flowchart is always whole on one page.
- Editing the flowchart later keeps the size the person chose. A flowchart that grows past the column is capped at the column width.
- A flowchart that has never been resized keeps the size the Read tab and print give it today. Nothing already published changes size.
- Tests cover:
  - a document's own small flowchart being the same size in the Edit tab as the same flowchart added as a standalone one, and as in the Read tab;
  - resizing it;
  - the size reaching the Read tab, PDF and Word.

Relates to:
- COM-1997 (the corner handle for pictures): share the handle, don't build a second one;
- COM-1999 (the settings panel);
- COM-2000 (the editor matches the finished product);
- COM-2001 (one click selects).

Independent: the size sits on the document's flowchart block, like a picture's width. If the PDF/Word render needs the API to carry it, this joins the chain.