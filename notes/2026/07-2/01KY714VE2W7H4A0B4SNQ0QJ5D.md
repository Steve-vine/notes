---
id: 01KY714VE2W7H4A0B4SNQ0QJ5D
created: 2026-07-23T08:23:20.258445Z
updated: 2026-07-23T11:04:51.993313Z
type: task
title: Add filter and sort to ToDo list
assignee: steve
comments:
- id: 01KY7152ZMRRQ30AC4YGR3AWFE
  author: Steve Vine
  at: 2026-07-23T08:23:27.987969Z
  text: |-
    Steve Vine · 2026-07-05:

    Built as agreed — PR: https://github.com/Steve-vine/notuvia/pull/183

    **What was done**

    - The kanban's `BoardFilterMenu` + `BoardSortMenu` now render on the tab strip while the dashboard is visible (hidden while a note overlay is open, like the kanban's).
    - Sort: Priority / Date Created / Date Due via a new `options` prop on the sort menu; within-group ordering uses the board's own `sortCards`, extracted from `KanbanView` into `board.ts` and shared. Default Priority/Ascending, persisted per-machine (`notuvia:todoSort`).
    - Filter: Status, Priority, and single-value user taxonomies via a new `showSprints={false}` prop hiding the Sprints section; no Assignee section since the list is pinned to "me". Filters go backend-side through the existing `task_board` filter param alongside the `assignee=me` spec. Transient state, pruned when a taxonomy disappears (same effect as the board's).

    **Decisions made on the fly**

    - The ToDo list's default order changed subtly: it used to be priority → due → title; it's now exactly the board's Priority sort (priority → title), so the sort menu behaves identically to the kanban's. Flag if you want due back as a secondary key on the Priority axis.
    - The filtered-and-empty state reads "No open tasks match the filters" instead of "Nothing to do".

    **Problems encountered**

    None — both menus took clean prop additions with kanban defaults, so board behaviour is untouched. Needs the usual visual pass: funnel tint when a filter is active, menu placement on the strip, and a due-date sort sanity check.
- id: 01KY71574P3QWC26SSHHFNGHKZ
  author: Steve Vine
  at: 2026-07-23T08:23:32.245738Z
  text: |-
    Steve Vine · 2026-07-05:

    Revised in review: the filter/sort menus moved off the shared tab strip into the **ToDo panel's own header** (right-aligned next to the count), since more dashboard panels are coming and each should carry its own controls. Their state — filters, sort, and the menu sections (now built from `applicableTaxonomies("task")`) — moved from `Main` into `Dashboard.svelte` accordingly; `Main` is back to its pre-DEV-848 shape. Menu behaviour is unchanged.
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 200
sprint: sjgxe93
---
Add Filter and Sort icons to the ToDo section, same as on the Kanban

## Agreed work

Reuse the kanban's tab-strip menus (`BoardFilterMenu`, `BoardSortMenu`) for the Dashboard, shown in the ViewTabs actions row while the dashboard is visible (and no note overlay is open) — the same spot they occupy on the kanban.

**Menu tweaks (kanban unchanged):**

* `BoardSortMenu` gains an optional `options` prop; the dashboard offers Priority / Date Created / Date Due — Assignee (everything is "me") and Manual (no drag order on a list) don't apply. Direction section as on kanban.
* `BoardFilterMenu` gains an optional `showSprints` prop; the dashboard hides the Sprints section (sprints are per-project). Sections offered: **Status, Priority**, then the single-value user taxonomies — **no Assignee section** (the list is pinned to "me" by definition).

**Behaviour:**

* Filters ride the existing `task_board` filter param alongside the `assignee=me` spec — same OR-within-section / AND-across-sections semantics as the board (DEV-839/843), including "No …" entries. Dashboard filter state is its own (transient, like the kanban's — every launch starts clean); stale axes prune the same way.
* Sort applies within each project group, mirroring the kanban's within-column sort exactly: `sortCards` moves from `KanbanView` into `board.ts` and is shared. Default Priority / Ascending, persisted per-machine (`notuvia:todoSort`, like `notuvia:kanbanSort`).
* When filters are active and nothing matches, the empty state says so rather than "Nothing to do".

Checks: `npm run check`, `npm test`.

---

Linear DEV-848 · Dashboard · created 2026-07-05 · done 2026-07-05