---
id: 01M7HXYYGDDDRV1AERF0XE3CGG
created: 2026-11-16T10:20:36.237723Z
updated: 2026-11-16T23:03:23.072279Z
type: task
title: 'Workflow builder: the whole canvas flickers while it''s being changed, e.g. dragging a block'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1864
sprint: s7nqsy0
comments:
- id: 01M7J7AGPDFGSV120GJAWYSGNM
  author: Steve Vine
  at: 2026-11-16T13:04:12.493284Z
  text: |-
    Done — PR #1860, merged to main (9bb37a11). Not on staging yet.

    - Cause: after every change (each step of a drag, each keystroke, a new reading from Compass), the canvas forgot the size of every block. It hid each block and its lines until it had measured them again, so everything blinked.
    - Fix: blocks keep their measured size, so only the block being changed redraws.
    - Moving a block no longer makes Compass re-read the workflow, because where a block sits doesn't change what it does. Changing a block, a field or a join still updates the sentences and problems.
    - An automated test proves it: no block is hidden or rebuilt during a drag, a join change or a new reading. The same test fails on the old code.

    To check on staging: this has only been proved in tests, so staging is the first real-browser look. Drag blocks in light and dark mode; type in side-panel fields; add, remove and join blocks. Nothing should flicker.
- id: 01M7JEAN97Q38S9R4ENKECE0BQ
  author: Steve Vine
  at: 2026-11-16T15:06:37.222769Z
  text: |-
    **Pre-UAT: Passed** (staging 43d03f09, E2E Test Company, E2E Admin A, real headless Chromium)

    Method: on a 4-block workflow I recorded every animation frame (about 150–460 frames per action). For each frame I noted whether any other block or line was hidden or see-through, and whether any block was removed and re-added. I also logged every request the page sent.
    - Dragging a block in light mode, two drags: it moved (e.g. translate(0,300) → (-96,348)). No other block or line was hidden in any frame, no block was re-added, and no request was sent.
    - Dragging in dark mode: the same, with the other blocks' background steady throughout.
    - Changing a field in the side panel (Compliant ↔ Non-compliant): one reading request each time, and the block's wording updated. Nothing hidden, nothing re-added.
    - Joining two blocks from the side panel: one reading, nothing hidden.
    - Adding a block from the palette: only the new block was hidden, for its first 3 frames while it was measured. Nothing else was hidden.
    - Removing a block: only that block went; nothing else blinked.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1864/ (mid-drag-light.png, mid-drag-dark.png). Worth a quick look by eye on a real screen, since this check was done by measurement.
assignee: steve
label:
- bug
priority: medium
task_status: done
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