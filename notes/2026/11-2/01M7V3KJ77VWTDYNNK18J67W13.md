---
id: 01M7V3KJ77VWTDYNNK18J67W13
created: 2026-11-19T23:52:24.551914Z
updated: 2026-11-20T14:05:05.233092Z
type: task
title: The picture settings panel never covers the selected picture, and a picture isn't selected when the page opens
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2008
sprint: s6y6p7g
comments:
- id: 01M7V694BDAXYESB8WAKBVK05Y
  author: Steve Vine
  at: 2026-11-20T00:39:08.397644Z
  text: |-
    Done — PR #2007, merged a2c021bf.
    The picture settings panel no longer covers the picture it's for:
    - When a picture is selected, the panel goes top right or bottom right, wherever the picture is clear. If neither is clear, the page scrolls the picture clear, all of it in view, about half a second after the click (so a double-click still opens a flowchart or drawing).
    - The scrolling now moves Compass's page itself, not the window.
    - In a short window where the whole panel can't fit beside the picture, the panel is made shorter and its settings scroll inside it.
    - While you scroll the page yourself, the panel only moves or shortens. It never scrolls the page back.
    - It keeps clear of the picture and its caption, not the whole width of the page, so a small centred picture on a wide window doesn't make it move.
    Opening a document's Edit tab selects nothing, even when the first block is a picture. The first click on the picture selects it and opens its panel.
    Checked in a headless browser:
    - 600×900, 800×600, 1100×700 and 1440×900, with paper on and off, for a picture at the top, middle and bottom of a long document, an image, a Full width image and a flowchart: 72 cases, the panel never covered the picture and the whole picture stayed in view.
    - At 800×600 the panel was shortened to about 150–175 px.
    Assumptions:
    - A picture taller than the window can't be kept clear: the panel then sits where it covers the least.
    - The panel is never made shorter than about 100 px.
    To check on staging:
    - In "E2E pre-UAT COM-2004 every kind of picture", at 600×900 select the document's own flowchart: the page scrolls it clear of the panel.
    - At 1100×700, select the Full width image near the top: it isn't covered.
    - Open a document whose first block is a picture: nothing is selected.
- id: 01M7VAP0NQSRDPVNPVX146HG7R
  author: Steve Vine
  at: 2026-11-20T01:56:04.919763Z
  text: |-
    Pre-UAT on staging 0ed475e8 — Passed
    Tested as E2E Admin A, E2E Test Company, in a new document "E2E pre-UAT COM-2008 long document with pictures" (37 blocks: an image as the very first block, a Full width image, a text diagram, a drawing and the document's own flowchart in the middle, a 50% image near the end, lorem paragraphs between) and in "E2E pre-UAT COM-2004 every kind of picture". Own headless Chromium, sizes in pixels.
    - Panel never covers the selected picture, on every window size: Passed. 4 sizes (600×900, 800×600, 1100×700, 1440×900) × paper on/off × 6 pictures × the picture scrolled to the top, middle and bottom of the window before the click = 144 cases. In all 142 cases where the picture could be clicked, the panel never overlapped the picture or its caption, and the whole picture stayed in the page's view. (The other 2: a 72 px diagram scrolled fully under the editor's toolbar, so there was nothing to click.)
      - Wide windows: the panel goes top right or bottom right (e.g. 1440: x 1124, 300 px wide). At 600 px it runs across the window (568 px wide) and moves top or bottom, away from the picture.
    - Scrolling uses Compass's page, not the window: Passed. Builder's check: at 600×900, selecting the own flowchart near the bottom: the panel moved to the top (y 72–420), the flowchart sat at y 520–862, clear of it. When I then scrolled the page myself by 250 px it stayed where I put it (not scrolled back), and the panel stayed open.
    - 1100×700, Full width image near the top: Passed. Image at x 210–890, y 316–656; panel at x 784, y 72–300. Not covered.
    - Short window: Passed. At 800×600 the flowchart's panel is 155 px tall and its settings scroll inside it (153 of 346 px shown); Remove can be scrolled to.
    - Opening the Edit tab selects nothing, even when the first block is a picture: Passed. Two documents whose first block is a picture (an image; a drawing): no panel, nothing selected, 4 of 4 fresh loads. The first click on the picture selects it and opens its panel ("Picture" / "Drawing").
    - Tests: Passed (pictureSettings.test.tsx adds the 600×900 / 1100×700 / short-window / every-size cases and "selects nothing when the picture is all there is").
    Smoke (nearby): resizing an image with paper on: the corner stays under the pointer (0 px off), 340 → 272 px, and the Read tab shows 272 px. The panel with paper on uses the app's colours (#FBFBFD / #1C1E2B).
    Observations, not defects:
    - A picture partly hidden under the editor's sticky toolbar when you click it stays partly hidden: at 600×900 an image at y 70–220 under a toolbar ending at y 149. The panel avoids it, but the page doesn't scroll it fully into view. Screenshot r3re-obs-picture-under-toolbar.png.
    - Clicking on a flowchart step that has links (its numbered badge area) in the editor doesn't select the flowchart, so no panel opens. Clicking anywhere else on it does.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2008/ (r3re-600x900-own-flowchart-clear.png, r3re-1100x700-fullwidth-not-covered.png, r3re-800x600-flowchart-short-panel.png, r3re-onload-nothing-selected.png, r3re-smoke-resize-paper-on.png)
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found in pre-UAT of round 3, by Tester B on staging 7ea67f64, against COM-1999.

**1. The panel covers the picture.**
- In a 600×900 window with paper off, select the document's own flowchart in "E2E pre-UAT COM-2004 every kind of picture". The panel docks at the bottom (y 536–884) and covers the bottom 113 px of the flowchart (y 307–649).
- In a 1100×700 window, a Full width image near the top has its top-right corner covered.
- Cause: Compass scrolls an inner page container, not the window. The panel's scroll-clear uses window scrolling, so nothing moves (window.scrollY stays 0).
- Screenshots: ~/compass-uat/s6y6p7g/COM-1999/r3-narrow600-scroll-flowchart.png, r3-1100x700-fullwidth-image-covered.png

**2. A picture that is the document's first block is already selected when the Edit tab opens.** Its panel is open, and the first click on it closes the panel. Screenshot: ~/compass-uat/s6y6p7g/COM-1999/r3-onload.png

**Done when**
- On every window size, the panel never covers the selected picture. When it would, the panel moves to another free place, or the page scrolls the picture clear. The scrolling uses whatever actually scrolls (Compass's page container), not the window.
- Check 600×900, 800×600, 1100×700 and 1440×900, with paper on and off, for a picture at the top, the middle and the bottom of a long document, and a Full width picture.
- Opening a document's Edit tab selects nothing, and no panel opens, even when the first block is a picture. The first click on it selects it.
- Tests cover the panel position against the picture in a short and a narrow window, and nothing being selected on load.

Independent: frontend only.