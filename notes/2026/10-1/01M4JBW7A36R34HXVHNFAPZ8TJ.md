---
id: 01M4JBW7A36R34HXVHNFAPZ8TJ
created: 2026-10-10T07:36:41.53922Z
updated: 2026-10-10T07:37:17.394439Z
type: task
title: 'Planner sidebar: toolbar row with filter, options popover and New note'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 517
sprint: sqcp1k3
blocked_by:
- 01M4JBVDX4NY25WQ1W0GE4TKVZ
assignee: steve
label:
- feature
priority: medium
task_status: todo
tech: null
---
So that the Planner sidebar reads like the Browse sidebar: one pinned row at the top — the filter box, the options button (popover) and New note — instead of a filter buried inside the Tasks section. The Browse tab's row is `BrowseOptions.svelte` (ADR 0063, NOT-431); this is its Planner twin.

## Agreed work

- [ ] New `PlannerOptions.svelte` rendered by `Main.svelte` in the pinned-tools snippet when `active.mode === "kanban"` (next to the `BrowseOptions` branch). Same three-part row and the same CSS idiom (`.row`, `.filter`, `.tool`, `.tool.new`, the active `.dot`): the filter box, a `sliders` options button opening a popover, and `note-pencil` → `openCapture()`.
- [ ] The filter box narrows every section's rows — the fixed rows (All Initiatives, All Projects, All Tasks, Loose Tasks) and the initiative/project rows alike — with `filterMatch` from `listFilter.ts` (literal, case-insensitive substring, DEV-943), not the main search syntax. Placeholder "Filter". The filter value lives in `KanbanState` (`tabsStorage.ts`) per tab like Browse's `valueFilter`; default empty.
- [ ] The popover holds two toggles: **Show active** (default on) and **Show closed** (default off), persisted in `KanbanState` as `showActive` / `showClosed` with those defaults in `defaultKanban()` and in `reviveTab` for tabs saved before this. Any non-default state lights the button's dot; a Reset line restores the defaults (the BrowseOptions pattern).
- [ ] The toggles filter the sidebar's initiative and project rows by the done flag from NOT-516: active = not done, closed = done. Both off shows no rows (and an empty-state line); both on shows all.
- [ ] Remove the `ListFilter` and `tasksFilter` from `KanbanSidebar.svelte` (and `ListFilter.svelte` itself if nothing else imports it — check `CrossSyncSidebar`, `SchedulesSidebar`, `WorkspacesSection` first).
- [ ] Tests: `tabsStorage.test.ts` for the new fields' defaults and revive; a `KanbanSidebar` or `plannerFilter` unit test for the row filtering if the logic is extracted to a `.ts` helper (preferred).

## Notes

Only the sidebar rows are affected here; the boards' Active/Closed scoping moves to the toggles in NOT-518. Not run in the app without Steve — a visual pass against the Browse row is needed.