---
id: 01M7TMHQGY5A08HS29Y1S1VERP
created: 2026-11-19T19:29:15.806184Z
updated: 2026-11-20T02:25:17.418187Z
type: task
title: A new shape's default colour is one you can pick, and the finished picture shows the same colour
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1991
sprint: s6y6p7g
comments:
- id: 01M7TVAHDSB66BT5N0HR6FRMF7
  author: Steve Vine
  at: 2026-11-19T21:27:40.217219Z
  text: |-
    Done — PR #1987, merged f58cfed2.
    A shape left on its default colour is now the house style's Light shade (background) and Primary (border) — a Note's is the Accent shade — on the canvas, in the reading view, the PNG/SVG downloads and the PDF/Word, so the finished picture matches what was drawn.
    The Style panel shows the default as the colour it is: Fill reads "Default (Light shade)" and Border "Default (Primary)", with that swatch ticked.
    On a dark canvas (and the dark full-screen view) a default shape keeps those same colours, as a chosen colour does, with dark words on it; the connections and lanes there are the house Primary turned light so they show on the dark ground.
    Assumption: the default follows the house style rather than the old canvas blue. With Compass's standard house style that's navy with a pale blue-grey fill, so the canvas now looks like the finished picture always did; a house style with another Primary changes both together.
    To check on staging: draw a new flowchart, leave the colours alone, press Done — the picture should look the same as the canvas; open Style on a shape to see the default named and ticked.
- id: 01M7V3SPDS7ZXP74CVGJBX17QQ
  author: Steve Vine
  at: 2026-11-19T23:55:45.464968Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Failed
    - A new shape's default background and border are picker colours, shown as the current choice: Failed on a standalone flowchart; Passed in a document.
      - Standalone (E2E pre-UAT COM-1992 all shapes standalone), as E2E Admin A: a new shape is drawn with a pale blue fill (#eef6fe) and a navy border (#12558e). Neither colour is in the pickers, whose Light shade is #e7f5ff and Primary #1971c2. Fill and Border both read just "Default", and no swatch is ticked (r3-01-style-default-dark.png).
      - In a document (E2E pre-UAT COM-1991 document flowchart): Fill reads "Default (Light shade)" and Border "Default (Primary)", and those swatches are ticked (r3-03).
      - Why (technical): a standalone flowchart's page has no house-style sheet. The shape colours fall back to one set of values (--rt-…-fallback, the navy set), but the picker falls back to the app's built-in swatches, so the two don't match.
    - A default-coloured shape looks the same on the canvas, reading view, PNG/SVG and PDF/Word: Passed. Standalone: canvas, saved picture, PNG and SVG downloads, PDF page 2 and Word image are all #eef6fe / #12558e. Document: canvas, picture, PDF and Word are all #e9e9e9 / #212121, with the Note #cae1df.
    - Light and dark canvases; a dark finished picture uses the same colour family, not black and grey: Passed. On the dark canvas, shapes keep their default fill and border with dark words. In the dark full-screen reading view, shapes keep their fill and the connections turn lighter (r3-05, r3-08).
    - Existing flowcharts with no colour show the same default everywhere: Passed. The saved pictures of COM-1907's and COM-1904's older flowcharts already use the same colours their canvases draw now.
    - Tests: Passed. defaultColour.test.tsx was added, but it always sets up a house-style sheet. The standalone case, with no sheet, isn't covered, which is where the mismatch shows.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1991/
- id: 01M7VCBG3AX4VFXD3GNWCNN0RQ
  author: Steve Vine
  at: 2026-11-20T02:25:17.417951Z
  text: |-
    Re-check on staging d8749c62: "a new shape's default background and border are picker colours, shown as the current choice" now Passed on a standalone flowchart.
    - As E2E Admin A, on "E2E pre-UAT COM-1992 all shapes standalone" (the chart that failed), a shape on Default is drawn #e9e9e9 with a #212121 border. Style reads "Default (Light shade)" and "Default (Primary)", with those swatches (#e9e9e9, #212121) ticked (r3re-01).
    - A new standalone ("E2E pre-UAT COM-2016 new standalone") does the same. Its Read tab, PDF and Word picture match the canvas (see COM-2014).
    - One remaining edge case is logged under COM-2016: if the house style takes more than about 3 s to load, the canvas stays in the fallback light blue while Style ticks the grey house swatches.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1991/r3re-01-standalone-style.png
assignee: steve
label:
- bug
priority: high
task_status: review
---
Steve's smoke test of round 2 (staging 5d1e1459): when he creates a flowchart, its shapes default to a blue background and border. That blue isn't any of the colours in the colour pickers. If he leaves the colour as it is and presses Done, the finished picture shows the shapes in black and grey instead.

**Done when**
- A new shape's default background and border are colours from the pickers, and the picker shows them as the current choice.
- A shape left on its default colour looks the same on the canvas, in the reading view, in the PNG and SVG downloads, and in the PDF and Word files.
- This holds on both light and dark canvases. On a dark canvas the finished picture may still be light, as exports always are, but it uses the same colour family as the canvas, not black and grey.
- Existing flowcharts whose shapes were never given a colour show the same default colour wherever they're drawn.
- Tests cover a default-coloured shape on the canvas and in the picture.

Independent: frontend canvas and picture, and the PDF/Word render if it draws its own default.