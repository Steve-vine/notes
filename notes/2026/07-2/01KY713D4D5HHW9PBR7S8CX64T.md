---
id: 01KY713D4D5HHW9PBR7S8CX64T
created: 2026-07-23T08:22:32.845634Z
updated: 2026-07-23T11:00:29.156173Z
type: task
title: ToDo Section
comments:
- id: 01KY713N86ECYZTB5WZNW50A36
  author: Steve Vine
  at: 2026-07-23T08:22:41.158303Z
  text: |-
    Steve Vine · 2026-07-05:

    Built as agreed — PR: https://github.com/Steve-vine/notuvia/pull/182

    **What was done**

    - `is_me` flag on taxonomy values (Rust + TS + yaml round-trip test), settable via a "me" tick in Settings → Taxonomies (Assignee only, one per pool) and via the ToDo section's first-run picker.
    - `BoardCard.project` (parent project id) added end-to-end, with a runtime test; the ToDo query is the existing `task_board` + assignee filter — no new commands.
    - `Dashboard.svelte` placeholder replaced with the ToDo section: open tasks assigned to me, grouped by project (sidebar order, "No project" last), sorted priority → due → title. Rows show display-id, title, status pill, priority letter, due date; click opens the task over the dashboard.
    - Grouping/sorting is pure (`dashboard.ts`, Vitest-covered); `prioLetter`/`dateLabel` extracted from `KanbanBoard` into `cardFormat.ts` rather than duplicated.

    **Decisions made on the fly**

    - The kanban note overlay (`boardOverlayNoteId`) was generalised to serve the dashboard too, rather than a second overlay: Esc and the tab-strip X work identically, and the properties panel follows the open task for free.
    - Tasks in board-hidden status columns still show on the ToDo list — hiding is a Kanban display preference, not a "not a to-do" statement. Flag in review if you'd rather they hide here too.
    - A priority id no longer in the pool sorts as "no priority" (with due/title tiebreaks) rather than erroring.

    **Problems encountered**

    None of note — the DEV-839 assignee filter and DEV-841 status-pill data meant the backend needed only the one `project` field. Not visually verified (screen capture is off-limits here), so worth a quick look at the empty states: no assignee values → Settings pointer; values but no "me" → picker; all clear → "Nothing to do".
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 198
sprint: sjgxe93
---
Create a ToDo section in the Dashboard main pane.  This should include all tasks assigned to me.  It should be in a clear list format.  The principle of the dashboard pane is to gain a quick insight into the state of things.

## Agreed work

**"Me" concept** — there is no current-user identity today; assignee is a pool of people values. Agreed: a per-value `is_me` flag on taxonomy values (same pattern as `is_default`/`initials`), set on at most one Assignee pool value. Vault data (`taxonomies.yaml`), so it syncs.

* `TaxonomyValue` (Rust + TS) gains optional `is_me`; YAML round-trip like `initials`.
* Settings → Taxonomies: the Assignee pool's value editor gains a "Me" radio column (one per pool, like Default).
* The ToDo section offers an inline picker when assignee values exist but none is marked "me"; when the pool is empty it points at Settings → Taxonomies.

**Board data** — `BoardCard` gains `project` (parent project id, null when unparented/projects board), populated from the task-board rows, so a flattened board can be regrouped by project. No new commands: the ToDo query is `task_board` filtered on the assignee axis (DEV-839 filters).

**ToDo section** (replaces the `Dashboard.svelte` placeholder):

* All **open** tasks assigned to me — cards from non-`is_done` status columns (a task with no status counts as open).
* **Grouped by project**, "No project" last; within each group sorted by priority pool order, then due date, then title. Pure grouping/sorting logic in a new `dashboard.ts` with Vitest coverage.
* Rows show display-id, title, status pill, priority letter, and due date, reusing the kanban card pill styles.
* Click opens the task note over the dashboard — same `NotePane` overlay pattern as the kanban board (Esc / tab-strip X closes; properties panel follows).
* Refreshes via `noteRev`/`taxonomyRev`; empty state when everything's done.

Checks: `npm run check`, `npm test`, `cargo test`.

---

Linear DEV-846 · Dashboard · created 2026-07-05 · done 2026-07-05