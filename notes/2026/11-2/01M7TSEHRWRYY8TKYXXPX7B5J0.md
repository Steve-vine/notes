---
id: 01M7TSEHRWRYY8TKYXXPX7B5J0
created: 2026-11-19T20:54:54.492216Z
updated: 2026-11-20T14:05:05.19791Z
type: task
title: Images, diagrams and flowcharts share the same reading tools and the same settings
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2004
sprint: s6y6p7g
comments:
- id: 01M7V0PKTKXPM5XYMCFXS1AVCR
  author: Steve Vine
  at: 2026-11-19T23:01:38.770866Z
  text: |-
    Done — PR #1998, merged 7ea67f64.
    On the Read tab (and anywhere else a document is read), images, drawings and text diagrams now have the same reading tools as flowcharts: Zoom out, Zoom in, Full screen and Download. Zoom steps from the size the picture is shown at. Download saves an image as its original file, and a drawing or text diagram as a PNG or SVG picture.
    The tools look and sit the same for every kind, over the picture's top-right corner. They appear on hover or keyboard focus (always on a touch screen), so a small picture isn't covered. A flowchart's tools moved from the row above it onto the picture as well.
    In the editor's settings panel, every kind now has alignment, caption and alt text. Drawings, text diagrams and flowcharts gained alt text, and flowcharts gained a caption beside their alignment. Size is still set with the corner handle.
    A flowchart's alt text reads as its caption and step count (e.g. "Flowchart: Raising a change, 5 steps") until someone writes their own; the panel shows what will be read. Alt text now reaches Word as well as the PDF, for every picture. A flowchart's caption prints under it, with its Links kept with it, as before.
    Saved settings are unchanged, and nothing published changes except that the reading tools appear.
    Assumption: a standalone flowchart shown in a document keeps the caption and alt text of the flowchart itself; in the document it has the reading tools, size and alignment.
    To check on staging: hover an image, a drawing, a text diagram and a flowchart on the Read tab, and try zoom, full screen and both downloads. Give a flowchart a caption and alt text in the editor, then check the PDF and the Word file (in Word: right-click the picture, View Alt Text).
- id: 01M7V3J65EEA85JABYYTEG4XW8
  author: Steve Vine
  at: 2026-11-19T23:51:39.43826Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Failed
    Tested as E2E Admin A, E2E Test Company, in "E2E pre-UAT COM-2004 every kind of picture" (2 images, 2 text diagrams, a drawing, the document's own flowchart, a standalone flowchart shown in it). Headless Chromium.
    - Reading tools for every kind (Zoom out/in, Full screen, Download): Passed on the Read tab. All 7 pictures have the same 4 buttons, 100×22 px, 6 px in from the picture's top-right corner.
    - Zoom steps relative to the shown size: Passed. ×1.5 then ×2 of the shown width (e.g. 340.2 → 510.2 → 680.3 px), and back. The picture pans inside its frame, and the page never scrolls sideways.
    - Full screen: Passed. It opens for every kind, with zoom and "Close full screen".
    - Download: Passed.
      - Both images downloaded byte-identical to the files I uploaded (same md5; 800×400 and 300×150).
      - Drawing, diagrams and flowcharts offer "PNG picture" / "SVG picture", and both are real PNG/SVG files.
    - Tools look and sit the same; show on hover or focus; keyboard: FAILED in one case.
      - Hidden (opacity 0) until hover, and shown on hover. Tabbing onto Zoom in, Full screen and Download shows them.
      - On a touch phone they're always shown.
      - The failure: a flowchart whose chosen size is bigger than its own size (drag its corner past its own size; the editor saves e.g. 60%) is still drawn at its own 192 px. Its frame stays 408 px wide, so on the Read tab its tools float 210 px to the right of the flowchart, over empty page. Its caption is centred under the empty frame rather than the flowchart, on the Read tab and in the PDF.
      - The same flowchart dragged smaller (20%) has its tools correctly on its corner.
    - Settings panel for every kind (alignment, caption, alt text, corner size): Passed for image, drawing, text diagram and the document's own flowchart. The standalone flowchart has alignment and size only, no caption or alt text: the builder's stated assumption. Steve to confirm.
    - A flowchart's caption under it in Read, PDF and Word; Links stay with it: Passed. The caption is under it on the Read tab, in the PDF, and in Word (Caption style). In the PDF, the Links list (a step linked to control INS.2) follows the caption.
    - A flowchart's alt text defaults sensibly: Passed for the document's own flowchart: "Flowchart, 3 steps", then "Flowchart: E2E caption for the flowchart, 3 steps" once it had a caption. A hand-written alt text replaces it.
      - The standalone flowchart reads "Flowchart, 4 steps" on the Read tab (no title). In Word it reads "Flowchart: E2E pre-UAT COM-1907 Service request handling, version 5, 4 steps".
    - Alt text used by screen readers on the Read tab, in the PDF and in Word: FAILED for the PDF.
      - Read tab: the img alt matches what was written, for every kind.
      - Word: each picture's alt text is there (Word's alt-text field), for every kind.
      - PDF: there is no alt text in the file at all. It is untagged: no structure tree, no /Alt entry, and the alt strings appear nowhere in it. A screen reader gets nothing.
      - test_picture_alt.py only checks the HTML that's turned into the PDF, not the PDF itself.
    - Saved settings kept; nothing published changes except the tools: Passed as far as I could check. Older published E2E flowchart documents (COM-1904, COM-1931) keep their captions and sizes and now show the tools. I had no "before" to compare against.
    - Tests: Passed (pictureTools.test.tsx, test_picture_alt.py), with the PDF caveat above.
    Observations:
    - Full screen shows a picture at its file's own size, not enlarged. A drawing shown at 272 px on the page is 182 px in full screen (smaller). A text diagram fills the width (1412 px).
    - On a phone with "Show as on paper" on, the tools shrink with the sheet to 10×10 px buttons.
    Screenshots and files: ~/compass-uat/s6y6p7g/COM-2004/ (r3-read-flowchart-tools-detached.png, r3-export3-pdf-page3.png, r3-read-phone-touch.png, r3-export3.pdf, r3-export3.docx, downloads/)
- id: 01M7VAQCCAYYPJFB8HSF7KHVJY
  author: Steve Vine
  at: 2026-11-20T01:56:49.674085Z
  text: |-
    Re-check on staging 0ed475e8: "tools look and sit the same" and "alt text reaches the PDF" now Passed, and the standalone flowchart's alt text now matches everywhere.
    - The flowchart saved at 60% in "E2E pre-UAT COM-2004 every kind of picture": its frame is the picture (192 px). On the Read tab its tools sit 6 px in from the picture's corner and its caption is centred under it, placed left, centre or right, and when zoomed. In the PDF the caption is centred under the flowchart.
    - The PDF is tagged: every picture is a Figure carrying its alt text (or its caption, or the default "Picture" / "Diagram" / "Flowchart…, N steps"), the same text as in Word. Two published documents re-exported come out pixel-identical to their untagged round 3 PDFs.
    - The standalone flowchart reads "Flowchart: E2E pre-UAT COM-1907 Service request handling, 4 steps" on the Read tab, in the PDF and in Word, without "version 5".
    Details on COM-2010 and COM-2011. Files: ~/compass-uat/s6y6p7g/COM-2010/, ~/compass-uat/s6y6p7g/COM-2011/
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Steve's smoke test of round 2: the different kinds of picture in a document don't offer the same things.
- In the Read tab, flowcharts have Zoom in/out, Full screen and Download, but images and diagrams don't.
- In the editor, images and diagrams have alignment, caption and alt text, but flowcharts don't.

All of them should have the same set.

The kinds are uploaded images, drawings (Excalidraw), text diagrams, and flowcharts (a document's own or a standalone one).

**Done when**
- **Reading tools, for every kind (Read tab and shared views):**
  - Zoom in and Zoom out, with steps relative to the size it's shown at (COM-2003).
  - Full screen.
  - Download. An image downloads as its original file. A drawing or text diagram downloads as PNG or SVG. A flowchart downloads as now.
  - The tools look and sit the same for every kind. They show on hover or focus, so a small picture isn't covered, and work from the keyboard.
- **Settings, for every kind (in the editor's settings panel, COM-1999):**
  - Alignment: left, centre, right, full width.
  - Caption.
  - Alt text, used as the picture's text for screen readers in the Read tab, PDF and Word.
  - Size, by the corner handle (COM-1997 / COM-1998).
- A flowchart's caption shows under it the way a picture's caption does, in the Read tab, PDF and Word. Its Links stay with it. A flowchart with no caption keeps what it shows today.
- A flowchart's alt text defaults to something sensible, such as its title and step count, until someone writes their own.
- The settings that already exist on images and diagrams keep their saved values. Nothing already published changes, except that the new reading tools appear.
- Tests cover each kind having the three reading tools, each kind having alignment, caption and alt text, and a flowchart's caption and alt text reaching the PDF and Word.

Relates to:
- COM-1997 (corner handle);
- COM-1998 (flowchart sizing);
- COM-1999 (settings panel);
- COM-2003 (zoom steps).

Independent if a flowchart's caption, alignment and alt text sit on the document's flowchart block like a picture's. If the PDF/Word render needs the API to carry them, this joins the chain.