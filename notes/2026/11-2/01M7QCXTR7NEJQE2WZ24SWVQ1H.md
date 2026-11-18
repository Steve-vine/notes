---
id: 01M7QCXTR7NEJQE2WZ24SWVQ1H
created: 2026-11-18T13:18:20.423542Z
updated: 2026-11-18T19:52:20.877763Z
type: task
title: 'A Text shape: free text anywhere on the flowchart canvas'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1956
sprint: s6y6p7g
comments:
- id: 01M7R3F89TBD7ZPWEB7W01X1MY
  author: Steve Vine
  at: 2026-11-18T19:52:20.026302Z
  text: |-
    Done — PR #1955, merged cbacf0c2.
    - Text joins the shape buttons (click it, or drag it in from the bar). It lands as the word "Text", open on the canvas with the word selected, so typing replaces it.
    - It's bare words: no fill and no border, starting at the left at Normal size. The Style panel's size, colour, bold, italic, underline, strikethrough and alignment apply, and a fill or border can be added. On the canvas a bare Text is faintly outlined so it can be found; the picture shows no outline.
    - It resizes like other shapes. Its words wrap to its width and it deepens to show them all, so they're never hidden. It can be moved, nudged, copied, pasted and deleted, sits in a lane or Group, and moves with its Group.
    - It isn't part of the flow: it has no connection points, can't be connected (a step changed to Text loses its connections), and has no description or links.
    - Reading view, PDF, Word and downloads draw it as on the canvas. The plain-text steps never change; its words are read with the notes, so search finds them. Compare versions names Text added, removed or reworded.
    - A text box imported from draw.io or Lucidchart now comes in as Text (it used to be a Note).
    Assumptions: a new Text starts with the word "Text" selected to type over. Imported text boxes become Text rather than Notes.
    To check on staging: add a Text, type a long sentence, narrow it and check it deepens. Give it a fill, a border, a larger size and centre alignment, then check the reading view, the PDF and the plain-text export.
assignee: steve
label:
- feature
priority: medium
task_status: review
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