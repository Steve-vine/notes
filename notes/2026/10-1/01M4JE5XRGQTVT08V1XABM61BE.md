---
id: 01M4JE5XRGQTVT08V1XABM61BE
created: 2026-10-10T08:16:56.592039Z
updated: 2026-10-10T16:47:21.960077Z
type: task
title: Back to top
project: 01KY6W9951TW0904DT0GGJVGE7
number: 526
sprint: s9peyxr
comments:
- id: 01M4KB6K5DTR755BJP3MH7VZ2W
  author: Steve Vine
  at: 2026-10-10T16:44:07.212561Z
  text: |-
    Done in PR #513 (branch brief-526-back-to-top).

    What was done: a round up-arrow button at the bottom centre of the note pane, shown only once the note's title has scrolled above the column's top edge, in Read, Live and MD alike; clicking it smooth-scrolls the column back to the top. The button is a sibling of the scrolling column (so it floats over the pane rather than scrolling away) and the visibility test reads the title's on-screen rect rather than a fixed pixel offset, so a wrapped title or the meta line above it make no difference. Added the Phosphor arrow-up glyph.

    Decisions: no fade transition, just present/absent, to keep it out of the tab order when hidden. Threshold is the title's bottom edge, which is what "the top of the note" means for both the read heading and the edit-mode title box.

    Not run in the app: a visual pass is owed (long note, short note, split pane, pop-out window).
assignee: steve
priority: medium
task_status: done
tech: null
---
Add a back to top button in the form of an upward pointing arrow at the bottom centre of note.
Only show it once the top of the note has scrolled off the top of the screen, clicking it should scroll back to the top.