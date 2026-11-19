---
id: 01M7TQGG2YQV31HFG95RS3Q3HM
created: 2026-11-19T20:21:01.150801Z
updated: 2026-11-19T23:51:24.567359Z
type: task
title: The document editor shows flowcharts, diagrams and images at the same size as the Read tab and print, with "Show as on paper" on or off
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2000
sprint: s6y6p7g
comments:
- id: 01M7TRA3RA8Y6PVXFMR6XRCWH8
  author: Steve Vine
  at: 2026-11-19T20:35:00.489913Z
  text: 'Steve added (19 Nov 20:35): a standalone flowchart added to a document already shows at a sensible size in the Edit tab. Only the document''s own flowchart is stretched there. So the document''s own flowchart should be shown the same way the standalone one is (COM-1998 covers the details). The same goes for any other picture kind that differs between the Edit tab and the Read tab.'
- id: 01M7TXJPPJC5AN33SJMA534BDG
  author: Steve Vine
  at: 2026-11-19T22:07:04.911064Z
  text: |-
    Done — PR #1993, merged 80901479.
    An image, drawing or text diagram is now the same size in the editor with "Show as on paper" on or off as on the Read tab and in print. Its size is a share of the page's text width, as the PDF and Word have always drawn it, or of the column when the window is narrower than a page. Before, without paper, the editor took that share of its whole, wider column, so pictures grew when paper was switched off.
    A picture at its own size, or Full width, is never wider than the page's text. Resizing in either mode means the same size everywhere, and saved documents keep their sizes.
    Measured at a 1200 px window: a 50% picture is 314 px wide in all four views (editor/Read, paper on/off); before, it was 450 px without paper. A 3-box flowchart is 192 px wide in all four.
    Assumption: the Read tab with paper (its default) and print preview are the reference, and they don't change. The Read tab without paper now shows pictures at that same size too, so switching paper or Edit/Read never changes a picture's size.
    The flowchart's own size and corner handle are COM-1998.
    To check on staging: resize an image to about half, then switch "Show as on paper" on and off in the editor and compare with the Read tab and print preview.
- id: 01M7V3HQMQ13X50BYFC2DK4RJF
  author: Steve Vine
  at: 2026-11-19T23:51:24.567113Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Failed
    Tested as E2E Admin A, E2E Test Company, in "E2E pre-UAT COM-2004 every kind of picture". It has 7 pictures: a never-resized image (300×150 file), a 50% image, a never-resized text diagram, a 50% text diagram, a 40% drawing, the document's own 3-box flowchart, and a standalone flowchart. Headless Chromium; widths measured in pixels.
    - Same size in the editor (paper on and off) as on the Read tab: Passed. At 1200 and 1440 px, all four views (Edit paper off, Edit paper on, Read paper on, Read paper off) gave identical sizes for every picture: 300×150, 340.2×170.1, 300×72, 340.2×81.7, 272.1×272.1, flowchart 192×342, standalone 192×472.
    - Same as print preview: FAILED for a text diagram that has never been resized. "Print preview" is the PDF. There, the diagram is drawn across the whole text width (~170 mm, about 640 px). In the editor, on the Read tab and in Word it is 300×72 px. Every other picture matches the PDF: the 50% image is 90 mm = 340 px; the 300×150 image is 300 px; the drawing is 272 px; the flowcharts are 192×342 and 192×472.
    - A 3-box flowchart is small, not stretched: Passed. It is 192 px wide in the editor and on the Read tab (the column is 1352 px).
    - A size means the same everywhere (editor, Read, print preview, PDF, Word): FAILED, only for the never-resized text diagram above. Word matches the editor exactly for all 8 pictures.
    - Paper off, never wider than the column; shrinks on a narrow window keeping proportions: Passed. At 390 px the column is 330 px. The 50% image shows at 151 px and the flowcharts at 181 px. Nothing overflows the column, and width:height is unchanged.
    - Paper on, the sheet shrunk to fit: pictures shrink with it: Passed. At 800 px the 50% image is 317 px in Edit and 331 px on Read (the editor's column is narrower, so its sheet shrinks a little more). At 390 px it is 141 and 155 px.
    - Resizing in either mode shows at once on the Read tab: Passed. With paper on I dragged the image to 30%: 204.1×102 px in Edit with paper on, Edit with paper off, and on Read.
    - Read tab, PDF and Word unchanged; saved sizes kept: Passed as far as I could check. Older published E2E flowchart documents (COM-1904, COM-1931) keep their captions and sizes. I had no "before" PDF to compare against.
    - Tests: Passed (pictureSizes.test.tsx).
    Note: the browser's own Print (Ctrl+P) of the Read tab prints a blank page, because Compass hides itself for print. The Print preview button (the PDF) is the real print.
    Screenshots and files: ~/compass-uat/s6y6p7g/COM-2000/ (r3-export2-pdf-page2.png shows the full-width diagram; r3-export2.pdf, r3-export2.docx)
assignee: steve
label:
- bug
priority: high
task_status: review
---
Steve's smoke test of round 2: flowcharts, diagrams and images change size in the document editor when "Show as on paper" is switched on or off. They should stay the same size.

Steve added: the Read tab and print preview already get it right. The 3-box flowchart shows at a sensible size, and images and diagrams show at the size he resized them to. Only the editor differs. The editor should look like the finished product.

**The finished product is the reference.** The Read tab and print preview / PDF show the size to match, and the editor follows them, not the other way round.

Likely cause: in the editor, a picture's width is kept as a share of the column it sits in. With "Show as on paper" off, that column is the editor's full width. With it on, it's the page's text width (e.g. 166 mm on the built-in A4 style). So the same 50% is a different size in each mode. And in the editor a flowchart always fills the column, while the Read tab sizes it sensibly.

**Done when**
- In the editor, with "Show as on paper" on or off, an image, drawing, text diagram or flowchart is the same size and shape as in the Read tab and print preview, at the same browser zoom. Switching mode, or between Edit and Read, doesn't change its size.
- A flowchart in the editor is the size the Read tab gives it (e.g. a 3-box flowchart is small, not full width), not stretched to the column.
- A picture's size means the same everywhere: the editor, the Read tab, print preview, the PDF and Word.
- With "Show as on paper" off, a picture is never wider than the editor column. On a narrow window it shrinks to fit, keeping its proportions, as the Read tab does.
- With "Show as on paper" on and the sheet shrunk to fit a narrow window, pictures shrink with the sheet as now.
- Resizing a picture in the editor, in either mode, shows that size straight away in the Read tab and print preview.
- The Read tab, print preview, PDF and Word don't change. Pictures already in documents keep their saved size.
- Tests cover a picture with a set width, one with no width, and a small flowchart: the same size in the editor (both modes) as in the Read tab.

Relates to:
- COM-1997 (corner resize handle);
- COM-1998 (flowchart sizing);
- COM-1999 (settings panel).

Independent: frontend document editor only.