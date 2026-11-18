---
id: 01M7QCXTR7NEJQE2WZ24SWVQ1H
created: 2026-11-18T13:18:20.423542Z
updated: 2026-11-18T13:20:18.725584Z
type: task
title: 'A Text shape: free text anywhere on the flowchart canvas'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1956
sprint: s6y6p7g
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Steve, testing on staging, 2026-11-18: add a Text shape so people can put free text on the canvas. In effect it's a shape that starts off transparent. (COM-1942 also gains a Transparent colour option, so any shape can be made like this.)

**What the author sees**
- **Adding text:** Text joins the shape buttons (click or drag, COM-1946). It's just words: no fill and no border by default (Transparent, from COM-1942), with its text selected for typing straight away (COM-1941).
- **Editing:** it resizes like other shapes (COM-1940), with its text wrapping to the width, and its text is never hidden. It can be moved, nudged (COM-1943), copied, pasted and deleted.
- **Text style:** size, colour, bold, italic, underline and alignment come from the shared font options (COM-1957), the same as every other shape. Text starts left-aligned at Normal size.
- **Styling:** a fill or border can be added later (COM-1942, COM-1951) if wanted.
- **Not part of the flow:** like a Note, it isn't a step. It can't be connected to, has no links, and doesn't appear in the plain-text steps. A free Line (COM-1955) can point at it.
- **Lanes and groups:** it sits in whichever lane or Group (COM-1954) it's placed in and moves with a Group.

**Note vs Text:** a Note stays the boxed comment it is today. Text is bare words, for titles, labels on areas and short explanations.

**What a reader sees**
- **Pictures:** the reading view, PDF, Word and downloads show Text exactly as placed.
- **Search:** its words are kept with the flowchart's notes, so search finds them.
- **Compare versions:** it mentions Text added, removed or reworded.

**Done when**
- Text can be added, typed, resized with wrapping, moved, styled (through COM-1957's options, plus an optional fill and border) and deleted.
- It's never a step, never connected, and absent from the plain-text steps, but searchable.
- It shows the same on the canvas, in the reading view, PDF, Word and downloads.
- Tests cover adding, wrapping, styling and the plain text staying the same.

On the chain: the stored flowchart gains a new kind of item, which the server checks. Builds on COM-1942 (Transparent) and COM-1957 (font options).