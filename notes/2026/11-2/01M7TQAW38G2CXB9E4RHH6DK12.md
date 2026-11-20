---
id: 01M7TQAW38G2CXB9E4RHH6DK12
created: 2026-11-19T20:17:56.840704Z
updated: 2026-11-20T14:05:05.132393Z
type: task
title: A picture's or diagram's settings open in a fixed floating panel on the right, readable with "Show as on paper"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1999
sprint: s6y6p7g
comments:
- id: 01M7TWCYFQS3R0BYN2V59K59RT
  author: Steve Vine
  at: 2026-11-19T21:46:27.703226Z
  text: |-
    Done — PR #1991, merged 0a3d9bcf.
    Selecting a picture now opens its settings in a floating panel of one size at the right-hand edge of the window, headed Picture, Drawing, Diagram or Flowchart, with a close button. The box under the picture is gone, so nothing in the document moves when the panel opens or closes.
    It holds what the box did: alignment, caption, and alt text (a picture), Change the drawing (a drawing), or the diagram's text, alignment, caption and Turn into a flowchart (a text diagram). A flowchart's panel has Edit flowchart, Make it a standalone flowchart and Remove; its alignment and caption join them with COM-1998/2004.
    The panel always uses the app's own colours, so it reads well with "Show as on paper" on or off, light or dark. It sits at the top right, or the bottom right when the top would cover the picture; on a narrow window it runs along the bottom and the page scrolls the picture clear of it.
    It follows the selection. The close button, Escape or a click outside the document close it. Tab from a selected picture moves into the panel. Each change applies at once and is one Undo step, even when made quickly one after another.
    Assumption: "far right of the editor" is the window's right-hand edge, under the top bar.
    To check on staging: select an image, a drawing, a text diagram and a flowchart, with "Show as on paper" on in dark mode; check the text doesn't move, and try a narrow window.
- id: 01M7V3HDTMMYVXY57ZPTECEGSN
  author: Steve Vine
  at: 2026-11-19T23:51:14.516395Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Failed
    Tested as E2E Admin A, E2E Test Company, in "E2E pre-UAT COM-2004 every kind of picture". Headless Chromium, sizes in pixels.
    - A floating panel for each kind, docked right: Passed. Image → "Picture", drawing → "Drawing", text diagram → "Diagram", own flowchart and standalone flowchart → "Flowchart". At 1440 px the panel is 300 px wide at x=1124, at the top right (or the bottom right when the top would cover the picture).
    - Contents: Passed. Picture: alignment, Caption, Alt text. Drawing: the same plus Change the drawing. Diagram: diagram text, alignment, Caption, Alt text, Turn into a flowchart. Own flowchart: Edit flowchart, alignment, Caption, Alt text (with a hint "Flowchart, 3 steps"), Make it a standalone flowchart, Remove. Standalone flowchart: Edit flowchart, alignment, Remove (the builder's assumption: no caption or alt text here).
    - Nothing in the document moves; no box under the picture: Passed. I measured every block's position in the document before and after selecting each of the 5 kinds: 0 px moved.
    - Same whatever the size or alignment; doesn't cover the picture; fits a narrow window: FAILED.
      - The width is always 300 px. The height follows the contents: 169–417 px.
      - At 1440 px the panel never covered the picture.
      - At 600×900, "Show as on paper" off: I selected the document's own flowchart. The panel docks at the bottom (y 536–884) and covers the bottom 113 px of the flowchart (y 307–649). Nothing scrolls it clear.
      - At 1100×700: a Full width image with its top near the top of the window has its top-right corner covered by the panel.
      - Cause, technical: Compass scrolls inside a page container, not the window. The panel's "scroll the picture clear" uses window scrolling, so nothing moves (window.scrollY stays 0).
      - At 390 px nothing was covered in my cases, and there was no sideways scroll.
    - Readable with paper on/off, light/dark, using the app's own colours: Passed. The panel sits outside the paper sheet in all 4 combinations. Background is the app's (#FBFBFD light, #232532 dark). Smallest text contrast is 5.2:1 (the alt-text hint); headings and labels are 10–20:1.
    - Follows the selection; click away / Escape close it; typing stays in the panel: Passed. It switched Picture → Drawing → Flowchart. It closed with Escape (in the editor and in the panel), with the Close button, and with a click on the page title. Typing a caption left the document's text unchanged.
    - Changes apply at once, one Undo step each: Passed. Caption, then Left, then alt text all applied immediately. Undo ×3 removed them one at a time, and Redo ×3 put them back.
    - Keyboard, heading and close button: Passed. Arrow from text onto the picture opened the panel, and Tab moved focus into it (the Close button).
    - Tests: Passed (pictureSettings.test.tsx covers each kind, placement, and dark mode with paper on).
    Minor defect: when a document's first block is a picture, the Edit tab opens with that picture already selected and its panel showing. The first click on the picture then closes the panel.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1999/ (r3-narrow600-scroll-flowchart.png, r3-1100x700-fullwidth-image-covered.png, r3-panel-image-dark-paperon.png, r3-onload.png)
- id: 01M7VAQ4X12K21680MJMV3YHHK
  author: Steve Vine
  at: 2026-11-20T01:56:42.017134Z
  text: |-
    Re-check on staging 0ed475e8: "doesn't cover the selected picture / fits a narrow window" now Passed, and the minor defect (a first-block picture already selected when the Edit tab opens) is gone.
    - 600×900, 800×600, 1100×700 and 1440×900, paper on and off, with pictures at the top, middle and bottom of a long document, a Full width image and the own flowchart: 142 clickable cases, the panel never overlapped the picture or its caption, and each picture stayed in view. The 600×900 flowchart and the 1100×700 Full width image from round 3 are clear now. Compass's page scrolls, not the window.
    - A document whose first block is a picture opens with nothing selected; the first click selects it.
    Details on COM-2008. Screenshots: ~/compass-uat/s6y6p7g/COM-2008/r3re-*
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Steve's smoke test of round 2: in the document editor, clicking an image or diagram opens a box under it. The box holds the alignment, the caption, and either the alt text or "Change the drawing".

It has three problems:
- With "Show as on paper" on, the box keeps the app's colours on the paper's background, so it's unreadable.
- Opening it pushes everything below the picture down the page.
- It doesn't display well under a small picture.

Move these settings into a fixed-size floating panel on the far right instead.

**Done when**
- Selecting a picture opens its settings in a floating panel of a fixed size, docked to the far right of the editor. That covers an uploaded image, a drawing (Excalidraw), a text diagram (DiagramView) and a flowchart in the document.
- The panel holds what the box under the picture holds today:
  - alignment;
  - caption;
  - alt text, "Change the drawing", or the diagram's own settings, depending on the kind.
  For a flowchart it holds alignment and caption once COM-1998 adds them.
- Nothing in the document moves when the panel opens or closes. The box under the picture is gone.
- The panel looks the same whatever the picture's size or alignment. It doesn't cover the selected picture or the text being typed in, and on a narrow window it still fits without hiding the picture.
- The panel is readable with "Show as on paper" on and off, in light and dark mode. It uses the app's own panel colours and never inherits the paper's.
- It follows the selection: selecting another picture shows that one's settings. Clicking away or pressing Escape closes it. Typing in the caption or alt text never moves the cursor into the document.
- Changes apply to the picture at once and are one Undo step each, as now.
- It works from the keyboard. The panel has a heading saying which picture it's for (e.g. "Picture" / "Drawing" / "Diagram" / "Flowchart") and a close button.
- Tests cover the panel opening for each kind, the document not moving, and readable colours with "Show as on paper" on in dark mode.

Relates to COM-1997, the corner resize handle, which stays on the picture.

Independent: frontend document editor only.