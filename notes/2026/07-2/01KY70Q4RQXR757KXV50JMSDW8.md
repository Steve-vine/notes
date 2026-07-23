---
id: 01KY70Q4RQXR757KXV50JMSDW8
created: 2026-07-23T08:15:51.06315Z
updated: 2026-07-23T08:22:32.910701Z
type: task
title: Tasks Section
imported_from: linear
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 164
comments:
- id: 01KY70Q9CHVDRWJ0RGBQJWG53Z
  author: Steve Vine
  at: 2026-07-23T08:15:55.79296Z
  text: |-
    Steve Vine · 2026-07-03:

    **Done building** — PR: https://github.com/Steve-vine/notuvia/pull/146

    **What was done:** In `KanbanSidebar.svelte`: "[All Tasks]" → "All Tasks", "[Ungrouped]" → "Loose Tasks", and an `aria-hidden` divider `<li>` (thin `--border` top rule) now separates the two fixed views from the per-project list.

    **Decisions on the fly:** The divider renders even when the project list is empty ("No projects") — it reads as the boundary of the fixed views either way.

    **Problems:** None. `npm run check` and `npm test` green. Note: same file as DEV-801's PR #145, but non-overlapping hunks — the two PRs merge cleanly in either order.
label: null
---
In kanban mode, in the Tasks section, rename "[All Tasks]" to "All Tasks" and "[Ungrouped]" to "Loose Tasks".

Add a horizontal line under the above 2 entries before the list of projects.

## Agreed work

* In `KanbanSidebar.svelte`, rename the Tasks section's entries: "[All Tasks]" → "All Tasks", "[Ungrouped]" → "Loose Tasks".
* Add a thin horizontal divider under those two fixed entries, before the per-project list.
* Checks: `npm run check`, `npm test`.

Note: touches the same file as DEV-801 but a different section — both branch off `main` and the hunks don't overlap, so they merge cleanly in either order.

---

Linear DEV-802 · Left Panel Improvements · created 2026-07-03 · done 2026-07-04