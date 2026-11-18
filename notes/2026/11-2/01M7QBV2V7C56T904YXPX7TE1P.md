---
id: 01M7QBV2V7C56T904YXPX7TE1P
created: 2026-11-18T12:59:21.831258Z
updated: 2026-11-18T12:59:25.214017Z
type: task
title: A light/dark toggle for the flowchart canvas background
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1947
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Steve, testing on staging, 2026-11-18: add a toggle to change the canvas background between light and dark.

**What people see**
- The canvas toolbar has a **light/dark** toggle (sun/moon icon) that switches the canvas between a light and a dark background, whatever Compass's own theme is.
- Shapes, lines, lane bands and labels switch with it and stay readable on either background. Chosen colours (COM-1942) stay the colours they are, and their text stays readable.
- The same toggle is on a flowchart's full-screen view when reading.
- The choice is remembered for that person, on any device, like their other preferences. Until they choose, the canvas follows Compass's theme, as now.

**What doesn't change**
- The toggle is only for viewing. It doesn't change the flowchart itself, so nothing is saved to the draft.
- The published picture, PDF, Word and downloads always use the light house style (COM-1910).

**Done when**
- The toggle switches the canvas and the reading full-screen view between light and dark, and everything stays readable in both.
- The choice is remembered for the person, and it never creates draft changes or alters exports.
- Tests cover the toggle, readability in both, and exports staying light.

Independent: frontend, plus the person's saved preferences if that needs a new setting.