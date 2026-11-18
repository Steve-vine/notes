---
id: 01M7R73HGBXW7Y6M857VAQHBB4
created: 2026-11-18T20:55:50.53972Z
updated: 2026-11-18T20:56:38.677662Z
type: task
title: 'Flowchart font options apply everywhere: free Lines, Group titles and lane names, drawn the same on canvas, reading view and picture'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1980
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Pre-UAT round 2 (tester B, staging cbacf0c2), COM-1957 (and COM-1952 for lane names):
1. **Line toggles:** select a free Line, press Bold/Italic/Underline/Strikethrough or Ctrl+B: the button doesn't light and nothing is saved (size and colour work). The toggle code doesn't look at Lines.
2. **Group title:** Bold, Underline and Size L on a Group's title are saved but the canvas and PDF/SVG still show the plain 13px title. Screenshot: ~/compass-uat/s6y6p7g/COM-1957/r2-08-group-title-text-styled.png
3. **Lane names:** Engineer at Size L, Align Left: PDF, Word and PNG show it large and left; the canvas shows it large but centred; the reading view shows it 11px centred. Screenshots: COM-1952/r2-13-canvas-light-adminB.png, r2-09-read-light-rows-tidied.png, r2-lanes-columns-v2-p2.png
4. **Aligned words touch the outline (minor):** a Start set Left/Top has its word against the rounded corner; a Hand-off set Right/Bottom runs into its slanted edge (canvas and picture). Screenshots: COM-1957/r2-03-canvas-all-styles-wide.png, COM-1942/r2-crop-handoff.png
5. **Compare versions:** "No differences." still appears beneath a list of style changes, and a change to a Line label's style isn't mentioned.

**Done when**
- Every font option (size, colour, B/I/U/S, alignment) works and is drawn on shapes, connection labels, free Line labels, Text, Group titles and lane names, identically on the canvas, the reading view (incl. its lane-name boxes, at every zoom) and the picture/PDF/Word.
- Aligned words keep a clear inset inside every shape's outline (rounded, diamond, slanted, document wave).
- Compare names every style change incl. Line labels, and says "No differences." only when there are none.
- Tests cover each of the five points.

Independent: frontend (+ server diff wording if needed).