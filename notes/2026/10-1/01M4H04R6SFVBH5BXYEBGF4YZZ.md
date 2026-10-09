---
id: 01M4H04R6SFVBH5BXYEBGF4YZZ
created: 2026-10-09T18:52:23.641925Z
updated: 2026-10-09T21:55:14.803436Z
type: task
title: 'Initiative note view: project list, delete prompt and stats'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 515
sprint: sqcp1k3
blocked_by:
- 01M4H045JSJANCCPDDYH5N9RSE
comments:
- id: 01M4HAGPZQFGJMZ0D0VGJ2J90G
  author: Steve Vine
  at: 2026-10-09T21:53:41.367378Z
  text: |-
    Built, PR #498 open and awaiting CI before the squash-merge.

    What landed:
    - NotePane: a Projects section on an initiative — one row per linked project (icon, title opening in place, identifier, status dot + label), an "N of M complete" count, an empty card pointing at the project's Initiative field. Refetched on note/taxonomy changes and in-app edits like the task list.
    - Trash prompt on an initiative with projects: informational only (nothing cascades, ADR 0070); without projects it trashes straight away.
    - Dashboard: an Initiatives open / complete tile beside Projects — the stats grid is auto-fit, so no layout change.

    Not built: a separate back-link in the project note view — the Initiative picker on the properties pane (NOT-513) already shows it; and no priority chip on the project rows (status, identifier and title are enough at that width). Timeline by initiative stays a follow-up.

    Verification: npm run check 0 errors, npm test 536/536. Not run in the app.
- id: 01M4HAKJ7K105M74JXYJFB7PAP
  author: Steve Vine
  at: 2026-10-09T21:55:14.802863Z
  text: 'Merged (squash, PR #498), CI green. The branch is deleted. All five Initiatives sprint PRs (#494–#498) are on main.'
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
So that opening an initiative shows what's in it. A project's note view shows its sprints and a jump to the board; an initiative's shows its projects. Builds on the frontend plumbing task; independent of the Planner task.

## Agreed work

- [ ] `NotePane.svelte`: an `isInitiative` branch that fetches `initiativeProjects()` when the note is an initiative (next to the project fetch) and renders a Projects section — one row per project with its status dot, priority chip and a click-through to the project note, plus an open/done tally.
- [ ] Delete / trash prompt for an initiative with projects says the projects are kept and unlinked (no "trash projects too" — the core task orphans, it doesn't cascade).
- [ ] A project's note view and properties pane show its initiative as a link back up (like a task's display of its project).
- [ ] Dashboard: `initiatives_open` / `initiatives_done` in `NoteStats` (core + Tauri) and a tile beside the projects tile, only if the dashboard already has room for it without a layout change — otherwise drop this item and note it.
- [ ] Tests: `noteDocs.svelte.test.ts` for the back-link; a Rust test for the stats counts if they're added.

## Notes

The Timeline / Gantt is out of scope — a portfolio timeline grouped by initiative is a follow-up once the type has been used for a while.