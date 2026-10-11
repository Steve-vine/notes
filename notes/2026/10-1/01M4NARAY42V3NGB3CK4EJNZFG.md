---
id: 01M4NARAY42V3NGB3CK4EJNZFG
created: 2026-10-11T11:14:48.900619Z
updated: 2026-10-11T11:39:39.048243Z
type: task
title: 'Roadmap entries: Tauri commands, MCP tool and HTTP API'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 529
sprint: sn8d5g8
blocked_by:
- 01M4NAQY0Q6PMR3N1F47KXXZCN
assignee: steve
label:
- feature
priority: medium
task_status: active
tech: null
---
So that the roadmap model from the core task is reachable from the app, from Claude over MCP, and over the HTTP API, the way sprints are (`set_project_sprints` → `ops`, `PUT /projects/{id}/sprints`). Thin wrappers only; the rules live in `ops::set_roadmap`.

## Agreed work

- [ ] Tauri commands in `src-tauri/src/lib.rs` (registered ~L2333): `set_roadmap(note, entries)` returning the saved list; `note_roadmap(note)` returning the current list (the Planner toolbar needs it to decide whether to show the Roadmap button without loading the whole note); `project_sprint_progress(project)` returning `[{sprint, title, done, total}]` per sprint, built from `project_tasks` — the note view uses it per project for an initiative's cross-project sprint lists. `get_note`/`load_note` already return `roadmap` via `NoteView`.
- [ ] `src/lib/notes.ts`: `RoadmapEntry`, `RoadmapSprintRef`, `SprintProgress` interfaces and the three wrappers. `src/lib/taxonomy.ts`: `date_mode?: "single" | "range"` on `TaxonomyValue`.
- [ ] MCP (`notuvia-mcp/src/main.rs`): `set_roadmap` tool with `RoadmapEntryInput` params mirroring `SprintEntry` (~L389) and `SetProjectSprintsParams` (~L413); description says it works on a project or an initiative, that omitted fields keep and empty strings clear, that an entry left out is deleted, and how sprint refs are shaped. `date_mode` on the add/update taxonomy value params (~L459–524) and in the tool descriptions. `get_note` already serialises `roadmap`. Test beside the `set_project_sprints` one (~L1714).
- [ ] HTTP API: `PUT /notes/{id}/roadmap` in `api_server.rs` beside the sprints route (~L371, routed ~L668), spec types in `api_spec.rs`, `date_mode` on the taxonomy value spec types (~L176, L303, L316).
- [ ] Docs: `docs/mcp-server.md` (sprints section ~L280, taxonomy values ~L285) and `docs/api.md` (~L188).
- [ ] Update the MCP server instructions string if it enumerates tools.

## Notes

Rebuild the `notuvia-mcp` sidecar and restart Claude Code after merging — the running sidecar predates `roadmap` and would drop it on its next save of a project note.