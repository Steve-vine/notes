---
id: 01M4JD9ASMB7CTMSQ546TNBX2A
created: 2026-10-10T08:01:19.66848Z
updated: 2026-10-10T09:49:03.484191Z
type: task
title: 'Initiative link on memos and schedules: reference notes for an initiative'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 523
sprint: sqcp1k3
assignee: steve
label:
- feature
priority: medium
task_status: review
tech: null
---
So that an initiative can have reference material, the way a project does (ADR 0038): a memo (or schedule) linked to an initiative lists in the initiative's Reference section. Today the `initiative` edge is allowed on a Project only (ADR 0070) — `update_note_with_target` strips it from any other type and `INITIATIVE_LINK_TYPES = ["project"]`. This widens the link to the same types that may link to a project, and gives the new-note window the dropdown.

## Agreed work

- [ ] ADR 0071 (short, extends 0070): the `initiative` edge may also sit on a Memo and a Schedule, meaning "reference material for this initiative" — the ADR 0038 reading of a memo's `project` link, one level up. A note may carry both `project` and `initiative`; neither implies the other. No cascade on delete (orphan, as 0070).
- [ ] `notuvia-core` `runtime.rs`: `update_note_with_target` keeps `initiative` for `Project | Memo | Schedule` (the set `PROJECT_LINK_TYPES` + Project), strips it otherwise; `set_initiative` accepts those types. `index.rs`: `initiative_memos(initiative_id)` — `child_memos` generalised over the edge kind (`kind = 'initiative'`, live memos, title order) — and `runtime.initiative_memos()`.
- [ ] Tauri `lib.rs`: `initiative_memos` command; `src/lib/notes.ts` `initiativeMemos()`.
- [ ] MCP (`notuvia-mcp`) and HTTP API (`api_spec.rs` / `api_server.rs`): the `initiative` param descriptions say "for a project, memo or schedule"; `create_note`/`patch_note` in `ops.rs` already carry it, so only the up-front type check (project-only today) widens. One MCP round-trip test for a memo.
- [ ] Frontend: `initiativeLink.ts` `INITIATIVE_LINK_TYPES = ["project", "memo", "schedule"]` — `Capture.svelte`'s Initiative picker and `NoteProperties.svelte`'s Initiative field already gate on `linksInitiative`, so they appear for memos and schedules without further wiring; `noteDocs.svelte.ts` `setType` loads/clears the same way. Confirm `capturePrefill` passes `initiative` for a memo.
- [ ] `NotePane.svelte`: the initiative note view gets a Reference section listing `initiativeMemos()` below its Projects section — the project note's Reference section (ADR 0038) one level up.
- [ ] Tests: Rust — a memo's initiative link survives save and lists in `initiative_memos`; a task's does not. `initiativeLink.test.ts` updated (it currently asserts no type links both ways — a memo now does; rewrite the invariant as "a task never links an initiative").

## Notes

`SCHEMA_VERSION` stays at 13: the edge rows already index for any type that carries the key. The MCP sidecar needs its usual restart to see the widened types. Capture's `Initiative` picker currently sits before the Sprint field — for a memo it should sit next to the Project picker; check the field order reads well with both shown.