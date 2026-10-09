---
id: 01M4H03TJNN8VAXA9HKHDB3EDK
created: 2026-10-09T18:51:53.301752Z
updated: 2026-10-09T21:30:59.706174Z
type: task
title: 'Initiative type: Tauri commands, MCP server and HTTP API'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 512
sprint: sqcp1k3
blocked_by:
- 01M4H03HKT0422T4X531FPPSPJ
assignee: steve
label:
- feature
priority: high
task_status: active
tech: null
---
So that the frontend, the MCP server and the HTTP API can create initiatives, link projects to them and list them. Builds on the core-model task.

## Agreed work

- [ ] Tauri (`src-tauri/src/lib.rs`): `list_initiatives` and `initiative_projects` commands registered alongside `list_projects` / `project_tasks`; `initiative` param on `update_note` and on `NewNote` / `save_note`.
- [ ] MCP (`crates/notuvia-mcp/src/main.rs`): `initiative` on the create and update params (valid for a project); every type list in tool descriptions and `server_instructions` includes `initiative`; `delete_children` wording covers initiatives (projects are orphaned, not deleted). `search_notes type:initiative` and `status:` already work via the index change — add a test proving it.
- [ ] HTTP API (`api_spec.rs`, `api_server.rs`): the `initiative` field on create/patch, type enum extended, docs regenerated.
- [ ] Tests: MCP create initiative → create project linked to it → get_note shows the link; update_note moving a project between initiatives and clearing the link; a non-initiative target is rejected. API equivalents.

## Notes

Keep this a thin layer — the rules live in `ops.rs` from the core task; this is plumbing and docs. Rebuild and reinstall the `notuvia-mcp` sidecar after merging so the Claude Code session uses the new schema.