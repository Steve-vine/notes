---
id: 01KY71TSFV11KE3C872CPSYSQ8
created: 2026-07-23T08:35:19.163919Z
updated: 2026-07-23T09:18:21.768674Z
type: task
title: API note write endpoints — create, update, delete
assignee: steve
label:
- brief
comments:
- id: 01KY71V1XJRJ4MQ183WEX3ZJZ4
  author: Steve Vine
  at: 2026-07-23T08:35:27.793953Z
  text: |-
    Steve Vine · 2026-07-07:

    ## Done — built and tested

    **What was done**
    - `POST /notes` (201 + view), `PATCH /notes/{id}` (updated view), `DELETE /notes/{id}?delete_children=` (`{"deleted": id}`), all mirroring the MCP write tools.
    - **Locked-note guard**: body writes to encrypted notes → `409` with the same explanatory message MCP gives; metadata patches go through with the envelope preserved (test-covered both ways).

    **Decisions made on the fly**
    - **The write semantics moved into core** (`notuvia-core/src/ops.rs`): taxonomy validation, omit-to-keep/empty-to-clear, sprint/milestone `checked_assignment`, YAML value shaping, and the sealed guard now live in one shared module that **both** MCP and the HTTP API call — MCP's `create_note_impl`/`update_note_impl` are now thin delegations. "Same validation as MCP" is enforced by construction rather than by discipline; MCP's 16 tests pass unchanged as the refactor's safety net. (`mint_sprint_id` + the sprints logic stay in MCP until DEV-897 gives them the same treatment.)
    - `ops::WriteError` is typed (`NotFound`/`Invalid`/`Sealed`) so HTTP maps 404/400/409 without string-matching; MCP flattens it via `Display`.
    - Sealed-body rejection is `409 Conflict` rather than 400 — the request is well-formed; it conflicts with the note's state, and retrying without `body` succeeds.
    - `DELETE` pre-loads the note so an unknown id is a clean 404 (and a double delete doesn't 500).

    **Problems encountered** — none; all 17 router tests passed first run.

    **Testing** — 7 new router tests: create→get round-trip, unknown-taxonomy 400, patch keep/clear semantics, patch-unknown 404, sealed 409 + metadata-through, delete round-trip, cascade-vs-orphan children. Full workspace green; clippy `-D warnings` clean.

    PR: [#222](https://github.com/Steve-vine/notuvia/pull/222)
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 243
sprint: s70xwrb
---
Note mutation over the HTTP API (ADR 0031, DEV-889), mirroring the MCP write tools (`create_note`, `update_note`, `delete_note`). Sequenced after the read endpoints — same notes router and DTOs.

## Scope

- [ ] `POST /notes` — create memo/task/project with optional title, body, taxonomy `values`, and `project` link; same validation as MCP (type-scoped taxonomies, project-family invariant ADR 0027); returns the new note id + view
- [ ] `PATCH /notes/{id}` — patch semantics matching MCP `update_note`: omitted fields keep their value, empty string clears; covers title, body, type, project, due, sprint, milestone, taxonomy values
- [ ] `DELETE /notes/{id}?delete_children=<bool>` — permanent delete including attachments; children handling as MCP `delete_note`
- [ ] **Locked-note guard** (ADR 0028/0030): body updates to encrypted notes rejected with a clear error; metadata updates preserve the envelope untouched
- [ ] Integration tests: create→get round-trip, patch semantics, delete with/without children, encrypted-note guards

## Definition of done

A remote client can run the full note CRUD cycle with parity to MCP behaviour, and the app's watcher/UI reflects API-made changes live.

---

Linear DEV-896 · API Server · created 2026-07-07 · done 2026-07-07