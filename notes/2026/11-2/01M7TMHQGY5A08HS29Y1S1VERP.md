---
id: 01M7TMHQGY5A08HS29Y1S1VERP
created: 2026-11-19T19:29:15.806184Z
updated: 2026-11-19T21:27:40.217382Z
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
assignee: steve
label:
- bug
priority: high
task_status: active
---
Steve's smoke test of round 2 (staging 5d1e1459): when he creates a flowchart, its shapes default to a blue background and border. That blue isn't any of the colours in the colour pickers. If he leaves the colour as it is and presses Done, the finished picture shows the shapes in black and grey instead.

**Done when**
- A new shape's default background and border are colours from the pickers, and the picker shows them as the current choice.
- A shape left on its default colour looks the same on the canvas, in the reading view, in the PNG and SVG downloads, and in the PDF and Word files.
- This holds on both light and dark canvases. On a dark canvas the finished picture may still be light, as exports always are, but it uses the same colour family as the canvas, not black and grey.
- Existing flowcharts whose shapes were never given a colour show the same default colour wherever they're drawn.
- Tests cover a default-coloured shape on the canvas and in the picture.

Independent: frontend canvas and picture, and the PDF/Word render if it draws its own default.