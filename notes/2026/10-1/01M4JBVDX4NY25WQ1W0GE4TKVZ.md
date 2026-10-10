---
id: 01M4JBVDX4NY25WQ1W0GE4TKVZ
created: 2026-10-10T07:36:15.524968Z
updated: 2026-10-10T07:36:15.524968Z
type: task
title: 'Planner sidebar: project and initiative rows carry a done flag'
label: feature
task_status: todo
priority: medium
assignee: steve
project: 01KY6W9951TW0904DT0GGJVGE7
number: 516
tech: null
---
So that the Planner sidebar can show or hide initiatives and projects by status (the Show active / Show closed toggles). Today `list_projects` / `list_initiatives` return a bare `NoteSummary` (id, title, note_type) — nothing says whether a project is in a done `project_status` or an initiative in a done `initiative_status`. Backend only; no UI change.

## Agreed work

- [ ] `notuvia-core` `runtime.rs`: `list_projects()` and `list_initiatives()` return rows with `is_done: bool` (a project with no status counts as not done, matching the board's "unstatused is active" rule in `KanbanView.loadBoard`). Either widen to a `BoardRow { id, title, note_type, is_done }` or add `list_project_rows` / `list_initiative_rows` beside the existing summaries — pick whichever disturbs fewer callers (the MCP server and HTTP API also use `list_projects`).
- [ ] Resolve done-ness from the status taxonomies' `is_done` values (`done_ids("project_status")` / `done_ids("initiative_status")`, as `note_stats` does), so custom status pools are honoured.
- [ ] Tauri `lib.rs`: the `list_projects` / `list_initiatives` commands surface the flag; `src/lib/notes.ts` types updated.
- [ ] Rust tests: a project in a done status reports `is_done: true`, unstatused reports `false`; same for an initiative.

## Notes

No `SCHEMA_VERSION` bump — this is a query over existing `note_values` rows, not an index change. The `notuvia-mcp` sidecar is unaffected unless the shared summary type changes shape.