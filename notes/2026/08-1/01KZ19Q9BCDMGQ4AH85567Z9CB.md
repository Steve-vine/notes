---
id: 01KZ19Q9BCDMGQ4AH85567Z9CB
created: 2026-08-02T13:13:28.172439Z
updated: 2026-08-25T09:01:11.600636Z
type: task
title: Scheduled notes left hand pane
project: 01KY6W9951TW0904DT0GGJVGE7
number: 386
sprint: segj1dz
comments:
- id: 01KZ1GKPGBSFY3YJCR5NJ1TQ02
  author: Steve Vine
  at: 2026-08-02T15:13:50.601351Z
  text: |-
    Done on branch not-386-scheduled-notes-pane — PR #376 (commit 3a58a4e).

    The Schedules view now has a left pane: a "Scheduled Notes" section built like the Planner's Tasks section —
    - a Filter box
    - three views: All Scheduled Notes / Unscheduled Notes / Completed Notes (these narrow the main schedules table; Unscheduled/Completed use the NOT-385 fire-state)
    - a divider
    - the list of notes created by schedules, newest first, click to open.

    Provenance (the "notes created from schedules" list needed a back-reference, which didn't exist): a minted note now records scheduled_from = its schedule id, indexed as an edge. New list_scheduled_notes command returns them newest-first (trashed excluded). It refreshes live off note-changed, so a fire shows up immediately.

    SCHEMA_VERSION bumped again 9→10 for the new edge — so the debug MCP needs rebuilding before in-app testing (same as NOT-384). New Rust test covers provenance + ordering + trash-drop.

    Verified: cargo test -p notuvia-core all pass (incl. new test); npm run check 0/0; npm test 224 pass; cargo check --workspace + npm run build clean.

    Note: visual pass is yours (no screen-capture here) — worth checking the sidebar, the three filter views, and that a fired schedule's created note appears in the list. Moving to Review — say the word and I'll squash-merge #376. That completes Sprint 35.
- id: 01KZ8DV0Q9X8AHX2QCKP1DYM3M
  author: Steve Vine
  at: 2026-08-05T07:40:05.735026Z
  text: 'Shipped: PR #376 (plus the rustfmt follow-up #378), released in 0.13.0. Moving to Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
On the left hand pane of the scheduled notes page, create a section called ‘Scheduled Notes’.  In here show something similar to the ‘Tasks’ section on the planner left hand pane, with the following elements.
[Filter…]
All Schedules Notes
Unscheduled Notes
Completed Notes
————————————
Then show a list of all notes that were created from scheduled notes newest at the top