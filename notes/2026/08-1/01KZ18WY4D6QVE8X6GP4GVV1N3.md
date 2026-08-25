---
id: 01KZ18WY4D6QVE8X6GP4GVV1N3
created: 2026-08-02T12:59:04.717605Z
updated: 2026-08-25T09:01:11.535965Z
type: task
title: Editing Schedule notes
project: 01KY6W9951TW0904DT0GGJVGE7
number: 383
sprint: segj1dz
comments:
- id: 01KZ1BEY0ZK65Z8ND8E8G9R3V1
  author: Steve Vine
  at: 2026-08-02T13:43:51.582892Z
  text: |-
    Fixed on branch sprint-35 (commit 4d8d659).

    Root cause: an opened note in the board-style views (Schedules, Search, Dashboard, Workspace, Planner cards) is shown as an overlay driven by transient Main-level state (boardOverlayNoteId). A single effect nulled it on every change of the active saved tab (active.id) OR view mode (active.mode), so switching any top tab closed the open note and returned you to the list.

    Fix (src/lib/Main.svelte): replaced that reset with a per-view stash/restore. The open overlay is remembered under a key of (saved tab + view mode, plus the board scope on the Planner) and restored when you come back, so a note stays open until you close it yourself (the strip's X or Esc). Covers both the view-mode tabs (Schedules ↔ Search ↔ …) and the saved tabs, so it fixes the Schedules case and the Search case you mentioned. Runtime-only (like editingLeaves — a restart still reopens closed), and deleted notes are purged from the stash so a view switch can't reopen a trashed note.

    Verified: npm run check clean (0/0); npm test 224/224 passing.

    Note: no screen-capture here for a visual pass — please sanity-check in the app: open/edit a schedule (or a Search hit), switch to another top tab and back, confirm it's still open; and that closing with X/Esc still works. Moving to Review.
- id: 01KZ8DTKDJJEW4712K9XKTTZYS
  author: Steve Vine
  at: 2026-08-05T07:39:52.114045Z
  text: 'Shipped: PR #374, released in 0.13.0. Moving to Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
If I create a new schedule note and start editing it, then click on one of the top tabs to check information on another note, when I come back to the tab I was on, the note has been created and the edit screen closed showing the schedule list.
Notes being displayed shouldn’t be closed when changing top tabs but only when the user closes them. This behaviour also exists on the Search tab.