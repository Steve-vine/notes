---
id: 01KY71VE3FN1BH6DE2XNY620AB
created: 2026-07-23T08:35:40.271234Z
updated: 2026-07-23T08:35:48.38025Z
type: task
title: API sprint, comment & dependency endpoints
label: brief
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 244
comments:
- id: 01KY71VP0WFYXYK0N216EWRXMS
  author: Steve Vine
  at: 2026-07-23T08:35:48.379833Z
  text: |-
    Steve Vine · 2026-07-07:

    ## Done — built and tested

    **What was done**
    - `PUT /projects/{id}/sprints` — full replacement in display order (ADR 0024): `id` keeps/retitles, omitted `id` mints (`s` + 6 random chars), unknown ids and duplicates refused, dropped sprints deleted. Returns the persisted list.
    - `POST /notes/{id}/comments`, `PATCH`/`DELETE /notes/{id}/comments/{comment_id}` — backend stamps author/timestamp, updates keep them, each returns the full comment list (MCP parity). Confirmed working on locked encrypted notes.
    - `PUT /notes/{id}/blocked-by` — full replacement (ADR 0026): task-only target, every blocker validated to exist and be a task. Returns the dependency info.

    **Decisions made on the fly**
    - Completed the DEV-896 pattern: sprint replacement rules (+ `mint_sprint_id`) and blocker validation moved into the shared `notuvia-core/src/ops.rs`; MCP's `set_project_sprints_impl` and `set_blocked_by_impl` are now thin delegations. All MCP write semantics are now single-sourced in core.
    - Comments got no ops layer — they're already bare `VaultRuntime` calls with no validation logic to share (MCP does the same), so an abstraction would add nothing.
    - PUT bodies are bare JSON arrays (`[{"title": …}]`, `["<task-id>"]`) rather than wrapper objects — the path already names the entity.
    - Comment errors map to 404 (unknown note or unknown comment id both read as "not found" from the runtime's errors).

    **Problems encountered** — none; all 22 router tests passed first run.

    **Testing** — 5 new router tests: sprint mint/keep/drop + unknown-id and memo rejections; the comment lifecycle (add→update→delete→404); comments on a sealed note; blocked-by set/validate/clear with non-task blocker and non-task target rejections. Full workspace green; clippy `-D warnings` clean.

    PR: [#223](https://github.com/Steve-vine/notuvia/pull/223)
---
The project-management surface of the HTTP API (ADR 0031, DEV-889), mirroring the MCP tools `set_project_sprints`, `add_comment`, `update_comment`, `remove_comment`, `set_blocked_by`. Sequenced after note writes — extends the same notes router.

## Scope

- [ ] `PUT /projects/{id}/sprints` — full-replacement sprint list in display order (parity with MCP `set_project_sprints`, ADR 0024)
- [ ] `POST /notes/{id}/comments` — add comment; backend stamps author + timestamp (ADR 0029)
- [ ] `PATCH /notes/{id}/comments/{comment_id}` — replace text in place, author/timestamp kept
- [ ] `DELETE /notes/{id}/comments/{comment_id}` — remove comment
- [ ] `PUT /notes/{id}/blocked-by` — full-replacement blocker list (parity with MCP `set_blocked_by`, ADR 0026), with the same cycle/validity checks as core
- [ ] Integration tests for each, including validation failures (non-task blockers, unknown ids)

## Definition of done

Sprints, comments, and task dependencies are fully manageable remotely with the same semantics as over MCP.

---

Linear DEV-897 · API Server · created 2026-07-07 · done 2026-07-07