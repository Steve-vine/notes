---
id: 01M7QC4HH0QQ1TMV0FCK691Y01
created: 2026-11-18T13:04:31.776576Z
updated: 2026-11-18T16:12:07.070365Z
type: task
title: Each flowchart lane can have its own header and background colour
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1952
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: active
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