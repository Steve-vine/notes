---
id: 01KY71CF96K1SENKMPGJ4TVB5N
created: 2026-07-23T08:27:29.958123Z
updated: 2026-07-23T08:27:42.265939Z
type: task
title: Add a Statistics section to the dashboard
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 216
comments:
- id: 01KY71CMK89GSXT71XVPVPPJHZ
  author: Steve Vine
  at: 2026-07-23T08:27:35.400469Z
  text: |-
    Steve Vine · 2026-07-06:

    **Planned work (Claude, 2026-07-06):** a new "Statistics" Dashboard panel, first-class alongside To Do/Favourites/Recents — registered in `PANEL_IDS`/`PANEL_LABELS` so it's drag-reorderable, collapsible, and tickable in the right pane's Panels section (DEV-857/858/859; `sanitizePanelOrder` surfaces it automatically for existing arrangements). Backend: new `note_stats` command — totals per type from the index, with Open/Complete for tasks and projects resolved against the status pools' `is_done` values (unstatused counts as open, the same rule as sprint counts). Layout as specified: All Notes → Total; Memos → Total; Projects → Open / Complete; Tasks → Open / Complete. Refreshes on any note write (noteRev) and taxonomy change (is_done edits move the split). One branch + PR.
- id: 01KY71CV9SXXKVVQ8WG8RERMCX
  author: Steve Vine
  at: 2026-07-23T08:27:42.265481Z
  text: |-
    Steve Vine · 2026-07-06:

    **Build complete — PR [#200](https://github.com/Steve-vine/notuvia/pull/200)**, branch `steve/dev-869-add-a-statistics-section-to-the-dashboard`.

    New Statistics panel with the layout as specified: All Notes → Total, Memos → Total, Projects → Open/Complete, Tasks → Open/Complete. Backend `note_stats` command counts from the index, resolving Complete against the status pools' terminal (`is_done`) values from the registry — custom done values count correctly, unstatused notes count as open (the sprint-count rule, matching the project sprint bars).

    It's a first-class Dashboard panel: drag-reorderable, foldable (the header shows the total when folded), and tickable on/off in the right pane's Panels section — for your existing saved arrangement it appears at the end, drag it to taste. Counts refresh live on any note write and on taxonomy edits.

    **Tests:** 213 backend (1 new covering totals, the done split, non-terminal statuses, and the empty vault) + 129 frontend (panel-order tests updated); fmt/clippy/svelte-check/build clean. Manual pass: check the numbers against your vault, complete a task and watch it move columns, and try the Panels tick.
---
Add the new section to show statistics about the current notes.

All Notes

* Total: xxxx

Memos

* Total: xxxx

Projects 

* Open: xxxx     Complete: xxxx

Tasks

* Open: xxxx     Complete: xxxx

---

Linear DEV-869 · Backlog · created 2026-07-06 · done 2026-07-06