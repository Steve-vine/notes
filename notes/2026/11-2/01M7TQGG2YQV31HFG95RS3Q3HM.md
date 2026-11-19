---
id: 01M7TQGG2YQV31HFG95RS3Q3HM
created: 2026-11-19T20:21:01.150801Z
updated: 2026-11-19T20:21:03.550808Z
type: task
title: Flowcharts, diagrams and images stay the same size when "Show as on paper" is switched on or off
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2000
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Steve's smoke test of round 2: flowcharts, diagrams and images change size in the document editor when "Show as on paper" is switched on or off. They should stay the same size.

Likely cause: a picture's width is kept as a share of the column it sits in. With "Show as on paper" off, that column is the editor's full width. With it on, the column is the page's text width (e.g. 166 mm on the built-in A4 style). So the same 50% is a different size in each mode. A picture with no width set is stretched or capped differently too, and a flowchart always fills the column.

**Done when**
- An image, drawing, text diagram or flowchart is the same size on screen with "Show as on paper" on and off, at the same browser zoom. Switching back and forth doesn't change its size or its shape.
- A picture's size means a share of the page's text width in both modes, as it is in the PDF and Word. So 50% is half the printed text width everywhere: the editor, the Read tab, the PDF and Word.
- With "Show as on paper" off, a picture is never wider than the editor column. On a narrow window it shrinks to fit, keeping its proportions.
- With "Show as on paper" on and the sheet shrunk to fit a narrow window, pictures shrink with the sheet as now.
- A picture with no size set (an image at its natural size, or a flowchart at its own size per COM-1998) is also the same size in both modes.
- Resizing a picture in either mode gives the same result when you switch to the other mode, and in the PDF.
- Pictures already in documents keep their saved size. Only how the editor and the Read tab show it changes.
- Tests cover a picture with a set width, one with no width, and a flowchart: the same size on screen in both modes, and matching the share of the page text width.

Relates to:
- COM-1997 (corner resize handle);
- COM-1998 (flowchart sizing);
- COM-1999 (settings panel).

Independent: frontend document editor and Read tab only.