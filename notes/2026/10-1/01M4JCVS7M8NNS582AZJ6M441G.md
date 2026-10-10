---
id: 01M4JCVS7M8NNS582AZJ6M441G
created: 2026-10-10T07:53:55.700705Z
updated: 2026-10-10T09:37:57.084417Z
type: task
title: 'Planner: Timeline on an initiative row shows every project, not the initiative''s'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 522
sprint: sqcp1k3
assignee: steve
label:
- bug
priority: high
task_status: review
tech: null
---
Bug. Pick an initiative row in the Planner sidebar (the per-initiative projects board, ADR 0070 / NOT-514), switch to Timeline: the chart shows all projects. Kanban narrows correctly.

## Cause

`Main.svelte` passes `TimelineChart` only `scope` (`active.kanban.sel.scope ?? null`); `sel.initiative` is never passed, and `TimelineChart.svelte` loads the vault-wide project list with no notion of an initiative. `KanbanView.loadBoard` does the narrowing client-side with `initiativeProjects(sel.initiative)`; the Timeline never got the same treatment.

## Agreed work

- [ ] `TimelineChart.svelte`: an `initiative?: string | null` prop; when set, narrow `projects` to the ids returned by `initiativeProjects(initiative)` (same client-side rule as `KanbanView`, applied before the `scope`/done filtering). Refetch when the prop changes, with the `loadSeq` guard idiom so a slow earlier load can't overwrite a later one.
- [ ] `Main.svelte`: pass `initiative={active.kanban.sel.kind === "projects" ? active.kanban.sel.initiative ?? null : null}`.
- [ ] Empty state: an initiative with no projects shows the chart's existing "no projects" state, not a blank grid.
- [ ] `TimelineChart`'s double-click → Gantt and the bar-colour key are unaffected; confirm the status key still lists the full `project_status` pool, not only statuses present.
- [ ] Test: if `TimelineChart` has a `.ts` helper for its row computation, cover the initiative filter there; otherwise a note in the PR that it was checked by hand in the app.

## Notes

Touches the same prop surface as NOT-518 (which removes `scope` from `BoardSel` in favour of the Show active / Show closed toggles). Land this first as a small fix; NOT-518 then replaces the `scope` prop and keeps `initiative`.