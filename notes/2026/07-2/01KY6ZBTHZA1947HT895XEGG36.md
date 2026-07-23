---
id: 01KY6ZBTHZA1947HT895XEGG36
created: 2026-07-23T07:52:11.583109Z
updated: 2026-07-23T11:03:34.374338Z
type: task
title: Add Folder to Imported notes
sprint: s96mm3j
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 93
comments:
- id: 01KY6ZC0CGFB9XRCPB60FDVMXG
  author: Steve Vine
  at: 2026-07-23T07:52:17.551892Z
  text: |-
    Steve Vine · 2026-06-25:

    **Plan, starting build.** Backend-only (the line lives in the note body, visible in the editor — no UI change).

    **Decided with Steve:**
    - Path = **the file's own source folder** (the directory that contained the file). For a nested folder import that's the subfolder — so it preserves the provenance that flattening discards. Single-file imports get their parent dir too.
    - **Only foreign notes** (no Notula id) are stamped. Id-carrying notes (re-imports / exported backups) are left untouched, so the ADR 0014 lossless round-trip holds.

    **Implementation** (`import.rs` + `runtime.rs`):
    - `map_markdown` gains a `source_folder: Option<&str>` param; when `!from_existing_id` it appends `\n\nImported from: <folder>` to the body (after title derivation, before the round-trip validate). New `append_provenance` helper.
    - `import_one` passes `path.parent()` as the source folder, so both file and folder import stamp each note with its actual containing directory.

    **Tests:** foreign note gets the line with the right folder; an id-carrying note does **not** (round-trip body stays identical); folder import stamps each file with its own subfolder.

    Consistent with ADR 0014 (round-trip preserved for id-carrying notes); no ADR change needed. CI run verbatim before push.
- id: 01KY6ZCARYTTS1SKWMP17VG1VC
  author: Steve Vine
  at: 2026-07-23T07:52:28.189502Z
  text: |-
    Steve Vine · 2026-06-25:

    Done — built and PR opened: **[#84](https://github.com/Steve-vine/notula/pull/84)** (branch `steve/dev-643-add-folder-to-imported-notes`).

    **What landed** (backend only):
    - `import.rs` — `map_markdown` gains a `source_folder` param; appends `Imported from: <folder>` as a trailing paragraph (new `append_provenance` helper), but only when `!from_existing_id` (foreign notes).
    - `runtime.rs` — `import_one` passes the file's `path.parent()`, so both file and folder import stamp each note with its own containing directory.

    **Per your two calls:** path = the file's own source folder (its real subfolder, despite flattening); only foreign notes are stamped, so id-carrying backups round-trip byte-identical.

    **Tests (3 new):** foreign note stamped with the right folder; id-carrying note not stamped (round-trip body unchanged); provenance omitted when no source folder.

    **Verification** — full CI matrix verbatim, all green: `cargo fmt --check`, `cargo clippy -D warnings`, `cargo test` (108), `npm run check`, `npm run build`, `npm test` (58).

    No UI surface this time, so nothing extra to sign off — just your merge call.
imported_from: linear
---
Add  "Imported from: <folder path>" to each imported note at the bottom of the note.

---

Linear DEV-643 · M11 - Import/Export capability · created 2026-06-25 · done 2026-06-25