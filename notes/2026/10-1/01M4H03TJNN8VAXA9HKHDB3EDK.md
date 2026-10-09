---
id: 01M4H03TJNN8VAXA9HKHDB3EDK
created: 2026-10-09T18:51:53.301752Z
updated: 2026-10-09T21:53:23.026135Z
type: task
title: 'Initiative type: Tauri commands, MCP server and HTTP API'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 512
sprint: sqcp1k3
blocked_by:
- 01M4H03HKT0422T4X531FPPSPJ
comments:
- id: 01M4HAG52JEW748024BNEV3HMT
  author: Steve Vine
  at: 2026-10-09T21:53:23.025702Z
  text: |-
    Built and merged (squash, PR #495), CI green. The branch is deleted.

    What landed:
    - Tauri: list_initiatives, initiative_projects and set_initiative commands. Per ADR 0070 the link is a dedicated write, not a new param on update_note / NewNote — that item of the agreed work changed shape, not scope.
    - MCP: `initiative` on create_note and update_note (omit keeps, empty string clears); every type list, the scope docs, the delete-cascade wording and the server instructions name the sixth type.
    - HTTP API: `initiative` on POST/PATCH bodies and the NoteView schema.

    Verification: MCP 28/28 (new round-trip test: create with link, bad targets rejected, update moves then clears, type:initiative search), shell 43/43 (new initiative_link_over_http: POST, 400 on a bad target, PATCH clears, permanent delete of the initiative orphans the project), fmt and clippy clean.
assignee: steve
label:
- feature
priority: high
task_status: done
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