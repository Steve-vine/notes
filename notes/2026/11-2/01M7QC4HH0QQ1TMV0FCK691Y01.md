---
id: 01M7QC4HH0QQ1TMV0FCK691Y01
created: 2026-11-18T13:04:31.776576Z
updated: 2026-11-18T22:32:33.251194Z
type: task
title: Each flowchart lane can have its own header and background colour
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1952
sprint: s6y6p7g
comments:
- id: 01M7QWXHT2R5DXPJAPEZDKXWCG
  author: Steve Vine
  at: 2026-11-18T17:57:48.48244Z
  text: |-
    Done — PR #1950, merged 83fb1039.
    In the lanes panel, each lane has a paint-brush button that opens Header and Background, the same colour picker as shapes (house colours, any colour, Default). Default keeps today's alternating bands.
    The same section sets the lane name's size, bold/italic/underline/strikethrough, colour (Automatic: light or dark to read on its header) and alignment. Each change is one undo step.
    The canvas, the pinned lane names while panning, the reading view's lane names and the picture (PDF, Word, downloads) all show the lane colours, in both lane directions. A transparent shape in a coloured lane reads its words against the lane's colour.
    The colour picker now closes on Escape without closing the canvas.
    Compare versions says e.g. Lane “Service Desk” header colour and background colour changed.
    Assumptions: there's no lane menu on the canvas, so the pickers live in the lanes panel only. Lanes can't be Transparent. Splitting into parts was removed by COM-1960, so every page shows the whole flowchart and its colours.
    To check on staging: colour one lane's header dark and its background pale, in both directions (Top to bottom / Left to right), pan so the names pin, then publish and check the reading view (light and dark), the PDF and the Word download.
- id: 01M7R708TZY9ENDCD7DPGNT44Y
  author: Steve Vine
  at: 2026-11-18T20:54:03.3594Z
  text: |-
    Pre-UAT on staging cbacf0c2 — Failed
    Flowchart: "E2E pre-UAT COM-1952 lane colours" (three lanes). v1 is plain, v2 coloured with lanes as columns (Top to bottom), v3 switched to Left to right, and v4 the same tidied. As E2E Admin A (and E2E Admin B for one light-canvas look) in E2E Test Company.
    - Header and Background set, reset to Default and kept, in both directions: Passed. Service Desk got a Primary header and a #fff3bf background (by hex). Engineer got a Light shade header. Customer got a Text header, which I then reset to Default, and an Accent shade background. One Undo took back only the background, and Redo put it back. Lanes are not offered Transparent. After v2, v3 and v4 the stored chart and every view kept the colours, both as columns and as rows.
    - The colours on the canvas, reading view, pinned names, PDF, Word and downloads, with the lane name always readable: Passed for the colours. The name turned white on the dark header and stayed dark on the light ones (r2-05-read-light-columns.png, r2-09-read-light-rows-tidied.png, r2-10-read-zoomed-panned-pinned.png with the names pinned after zooming and scrolling, r2-lanes-columns-v2-p2.png, r2-lanes-rows-v4.pdf/.docx, r2-dl-….png/.svg). Split parts no longer apply (COM-1960).
    - Lane name size and alignment: Failed. On Engineer I set Size L and Align Left. The picture shows that, but the canvas centres the name and the reading view shows it small and centred. Details under COM-1957.
    - Pressing Escape in a lane's colour picker: Failed. The builder says Escape now closes the picker without closing the canvas. In the lanes panel (no shape selected), opening Background ▸ any colour and pressing Escape, whether focus is on the picker button or in the Hex code box, closes the picker. It also brings up "Leave without keeping your changes?" (r2-02-escape-in-lane-picker.png). Keep drawing gets you back. In the shape Style panel (with a shape selected) Escape is fine.
    - A Transparent shape in a coloured lane on the dark canvas: Failed. "Log the call" (Transparent fill) in the #fff3bf lane shows light words on pale yellow and is almost unreadable (r2-01-canvas-lane-colours.png). The light canvas and the picture are fine. Steve: switch the canvas to dark.
    - Compare versions in words: Passed. It reads Lane "Service Desk" header colour and background colour changed, and Lane "Customer" background colour and text style changed (r2-11-compare-v1-v2.png).
    Seen on the way (not this task): switching this laned flowchart from Top to bottom to Left to right left "Start" on top of "Log the call" and "Confirm it works" under "End" until Tidy up (r2-06-canvas-rows.png, r2-07-read-light-rows.png).
    Screenshots: ~/compass-uat/s6y6p7g/COM-1952/
- id: 01M7RCMM73WHS80JNJQT5825A6
  author: Steve Vine
  at: 2026-11-18T22:32:33.250939Z
  text: |-
    Re-check on staging d6c281fe: all three failed points now Passed.
    - Escape in a lane's colour picker (Header, Background, Name colour; focus on the picker or in Hex code) closes just the picker, with no leave prompt (COM-1979).
    - A Transparent step in the #fff3bf lane on the dark canvas has dark, readable words, as in the picture (COM-1979).
    - Engineer at Size L, Align Left is large and left on the canvas, in the reading view at every zoom, and in the PDF, Word and PNG (COM-1980).
    One thing that's new: in the PDF the Engineer name's italic prints upright now that the house style uses a custom font (see COM-1980).
    Screenshots: ~/compass-uat/s6y6p7g/COM-1979/, COM-1980/
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing on staging, 2026-11-18: allow lanes to have different header and background colours.

**What the author sees**
- Each lane has **Header** and **Background** colour pickers in the lanes panel, and on the lane's own menu on the canvas.
- They use the same picker as shapes (COM-1942): house-style colours first, then any colour, and **Default**. Default keeps today's alternating house-style lane bands.
- The lane name's text turns light or dark automatically, so it stays readable on its header colour.
- A shape's own fill (COM-1942) sits on top of its lane's background. Shapes and lines stay readable on any lane colour.
- Each change is one undoable step.

**What a reader sees**
- The reading view (light and dark), the pinned lane names while panning, PDF, Word and downloads all show the lane colours.
- A flowchart split into parts (COM-1910) shows each lane's colours on every part.

**Done when**
- Every lane's header and background colour can be set and reset to Default, and is kept after Done, publishing and reopening, in both lane directions.
- The colours show on the canvas, in the reading view, PDF, Word, downloads and every split part, with the lane name always readable.
- Compare versions mentions a lane colour change in words.
- Tests cover setting, resetting and text contrast.

Independent unless the stored chart needs new fields the server must accept (then on the chain). Build it with COM-1942's colour picker.