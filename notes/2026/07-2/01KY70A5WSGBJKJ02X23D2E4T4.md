---
id: 01KY70A5WSGBJKJ02X23D2E4T4
created: 2026-07-23T08:08:46.233444Z
updated: 2026-07-23T11:04:50.87648Z
type: task
title: 'Note-level due date: data model + plumbing'
assignee: steve
comments:
- id: 01KY70AFF0WWX3CZ7JAPE16J4A
  author: Steve Vine
  at: 2026-07-23T08:08:56.032601Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/129

    **What was done**
    - `index.rs`: `due` added to RESERVED (11 keys now); `due TEXT` on the notes table, written by `index_note`, returned by both board-row queries. No migration — the index rebuilds on startup per ADR 0022.
    - `runtime.rs`: `due` on `NoteView` (read in `load_note`) and `BoardCard` (populated in `board()`/`task_board()`); `update_note` gains the `due` param, trimmed set-or-remove like `identifier`.
    - `lib.rs`: command signature extended; all ten `update_note` test call sites updated.
    - Frontend: `NoteView`/`updateNote` (notes.ts); `NoteDoc.due` (`""` = unset, the identifier convention) through `snapshot()`/`loadFromDisk`/`flush` so dirty-detection and autosave cover it; `BoardCard.due` (board.ts).
    - Tests: index rebuild picks `due` off frontmatter + it's excluded from the taxonomy value space; runtime round-trip (set → load_note + task-board card; blank clears the field).

    **Decisions made on the fly**
    - `due` sits on the buffer as a plain string with `""` = unset (identifier convention) rather than `string | null` — simpler binding for the DEV-768 date input.
    - Blank/whitespace input removes the field from frontmatter entirely rather than storing an empty value — files stay clean.
    - The `due` set/clear in `update_note` is unconditional for any note type (per ADR 0022: any note may carry one; only the UI scopes it to tasks/projects).

    **Problems encountered**
    - The pre-push gate caught a rustfmt nit on the first push (long line in the new test); fixed and amended. Otherwise clean: cargo 149/149, clippy, svelte-check 0 errors, vitest 109/109. App behaviour unchanged until DEV-768/769 surface the field — review is the Rust diff + the buffer plumbing.
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 144
sprint: sa8cznq
---
R7 of the Revamp UI milestone (parent DEV-754). Implements ADR 0022 — the `due` field end-to-end, no visible UI yet.

* `src-tauri/src/index.rs`: add `"due"` to the RESERVED keys (else it indexes as a taxonomy), `due TEXT` column on `notes`, include in `index_note` INSERT and both board-row SELECTs. Startup full rebuild = no migration.
* `src-tauri/src/runtime.rs` + `lib.rs`: `due: Option<String>` on `NoteView` and `BoardCard`; read in `load_note`; set/remove param on `update_note` (like `identifier`); populate in `board()` / `task_board()`.
* Frontend plumbing: `notes.ts` (NoteView/updateNote), `noteDocs.svelte.ts` (NoteDoc, `snapshot()`, `loadFromDisk`, flush), `board.ts` (BoardCard).
* Tests: index rebuild picks up `due`; update round-trip.

Depends on: DEV-761 (R1). Parallelizable with the shell briefs.

Checklist:

- [ ] due indexed + RESERVED
- [ ] due through NoteView/BoardCard/update_note
- [ ] Frontend types + doc buffer plumbing
- [ ] Round-trip tests

---

Linear DEV-767 · Revamp UI · created 2026-07-02 · done 2026-07-02