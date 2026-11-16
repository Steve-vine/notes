---
id: 01M7HXYYGDDDRV1AERF0XE3CGG
created: 2026-11-16T10:20:36.237723Z
updated: 2026-11-16T13:04:01.011042Z
type: task
title: 'Workflow builder: the whole canvas flickers while it''s being changed, e.g. dragging a block'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1864
sprint: s7nqsy0
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found by Steve while testing sprint "Automation - Workflows" on staging (building the CHK-26 workflow).

## What was seen

Changing the workflow on the canvas makes the whole workspace flicker, not just the block being changed. Dragging a block is the clearest case.

## Look at

Find what redraws, and why, before changing anything. Suspects:
- A block's position is saved in the workflow itself. Each move counts as a change, so the canvas asks Compass to read the whole workflow again (sentences, problems) and redraws every block and line when the answer arrives.
- The canvas, palette or side panel may be rebuilt rather than updated on each change, e.g. new keys, or the canvas re-measuring itself.
- The "Unsaved changes" state flips on every move, re-rendering the page header and builder.

## Done when

- Dragging a block moves only that block and its lines. Nothing else on screen blinks, jumps or redraws visibly, in light or dark mode.
- Moving a block doesn't make Compass read the workflow again. Only a change to what the workflow does (a block, a field, a join) does that, and the sentences and problems still update after it.
- Editing a field in the side panel, adding or removing a block, and joining two blocks don't flicker either.
- A test covers it: moving a block doesn't trigger a new reading, and the other blocks aren't re-mounted.

Independent (frontend only).