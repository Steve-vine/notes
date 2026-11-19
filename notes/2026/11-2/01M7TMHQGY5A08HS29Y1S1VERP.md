---
id: 01M7TMHQGY5A08HS29Y1S1VERP
created: 2026-11-19T19:29:15.806184Z
updated: 2026-11-19T19:29:17.507335Z
type: task
title: A new shape's default colour is one you can pick, and the finished picture shows the same colour
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1991
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Steve's smoke test of round 2 (staging 5d1e1459): when he creates a flowchart, its shapes default to a blue background and border. That blue isn't any of the colours in the colour pickers. If he leaves the colour as it is and presses Done, the finished picture shows the shapes in black and grey instead.

**Done when**
- A new shape's default background and border are colours from the pickers, and the picker shows them as the current choice.
- A shape left on its default colour looks the same on the canvas, in the reading view, in the PNG and SVG downloads, and in the PDF and Word files.
- This holds on both light and dark canvases. On a dark canvas the finished picture may still be light, as exports always are, but it uses the same colour family as the canvas, not black and grey.
- Existing flowcharts whose shapes were never given a colour show the same default colour wherever they're drawn.
- Tests cover a default-coloured shape on the canvas and in the picture.

Independent: frontend canvas and picture, and the PDF/Word render if it draws its own default.