---
id: 01KY6Z949WBYF1N77S40P1KDJQ
created: 2026-07-23T07:50:43.260929Z
updated: 2026-07-23T12:24:56.742479Z
type: task
title: Import markdown file(s)
task_status: done
label: null
comments:
- id: 01KY6Z9B9J3SBMXKMBEMWGS00Z
  author: Steve Vine
  at: 2026-07-23T07:50:50.418072Z
  text: |-
    Steve Vine · 2026-06-25:

    **Plan agreed (plan-mode), starting build.**

    **Backend** (`src-tauri/src/import.rs` + `runtime.rs`):
    - Mapping engine with a *lenient* frontmatter split (since `Note::parse()` requires `id`+`type`, which imported files often lack). Applies ADR 0014 derivation: `id` keep-valid-or-mint, `created`/`updated` existing→mtime→now, `type` validate-or-`memo`, `title` frontmatter→first `# H1`→filename stem. All other keys preserved verbatim.
    - `VaultRuntime::import_paths(paths) -> ImportSummary`. Per file: collision check via `shard_path(id).exists()` → skip; else `write_note` + `record_self_write` + `index.reconcile_path` + `git_touch`. Returns `{ imported, skipped[{path,reason}], failed[{path,error}] }`.
    - `#[tauri::command] import_files(paths)` in `generate_handler!`.

    **Frontend** (`src/lib/Main.svelte`):
    - **Entry point: Import action in the main-UI sidebar, beside Settings** (decided with Steve — keeps the tray capture-focused; DEV-640's folder import becomes a sibling here).
    - File picker `open({ multiple: true, filters: [md/markdown] })` → `import_files` → small auto-clearing result line ("Imported N · skipped M") since there's no toast component yet. Refresh browse/search after.

    **Tests:** mirror the `runtime()` fixture — round-trip re-import + idempotent skip; foreign `tags`/no-id → Memo with tags preserved + derived title; plain markdown → fresh id.

    CI run verbatim locally before push.
- id: 01KY6Z9MAZDEJBE3RGRB99C310
  author: Steve Vine
  at: 2026-07-23T07:50:59.678684Z
  text: |-
    Steve Vine · 2026-06-25:

    Done — built and PR opened: **[#81](https://github.com/Steve-vine/notula/pull/81)** (branch `steve/dev-639-import-markdown-files`).

    **What landed**
    - `src-tauri/src/import.rs` — pure mapping engine (`map_markdown`): lenient frontmatter split, ADR 0014 core-field derivation, foreign keys preserved verbatim, round-trip validated via `Note::parse`. 8 unit tests.
    - `runtime.rs` — `import_files`/`import_one`: read → collision check (`shard_path(id).exists()` → skip) → `write_note` + `record_self_write` + `index.reconcile_path`; one `git_touch` per run. Added `file_mtime_rfc3339`. 5 integration tests.
    - `lib.rs` — `import_files` command, registered.
    - Frontend — `importNotes.ts` (multi-select picker + invoke), an `import` Icon glyph, sidebar Import action beside Settings, and an auto-clearing "Imported N · skipped M" notice; refreshes the active tab after import.

    **Decisions on the fly**
    - `Note::parse()` requires `id`+`type`, which imported files often lack — so the engine uses its own lenient frontmatter split and only relies on `Note::parse` at the end to validate the *finished* note. Mirrors `save_note`'s round-trip check.
    - A non-ULID foreign `id:` can't be the note id (the slot demands a ULID), so it's replaced with a minted one. Edge case, noted in a test; not preserved under a sidecar key (kept simple — out of ADR scope).
    - Result feedback is a small inline sidebar notice rather than a new toast system (none exists yet) — lowest-footprint, matches the existing inline `error` pattern. A real toast component is a reasonable future follow-up if other surfaces want one.

    **Verification** — full CI matrix run verbatim locally, all green: `cargo fmt --check`, `cargo clippy -D warnings`, `cargo test` (98), `npm run check`, `npm run build`, `npm test` (58).

    **Note for review:** the picker/notice is the UI surface that wants your manual sign-off per our cadence — happy to demo or tweak placement.
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 90
sprint: s96mm3j
---
The import mapping engine plus a UI entry point to pick one or more `.md` files. This is the foundation the folder import (bulk) brief builds on. Rules are pinned by ADR 0014 (DEV-638).

## Mapping engine (backend, `src-tauri/src/`)

For each selected file, map markdown → a Notula note:

- [ ] Read the file; parse frontmatter with `Note::parse()` if present (preserves unknown keys verbatim — ADR 0014).
- [ ] Ensure core fields per ADR 0014 derivation rules:
  - `id`: keep existing valid Notula id, else mint a fresh ULID.
  - `created`: keep existing, else file mtime, else now. `updated`: now.
  - `type`: default `memo` if absent/invalid.
  - `title`: frontmatter `title` → first `# H1` → filename stem.
- [ ] **Id-collision → skip:** if the file's id already exists in the vault, skip and record it (no overwrite).
- [ ] Write preserving id/created via `note::write_note()` + `index.reconcile_path()` + `git_touch()` (not `save_note()`, which mints a fresh id).
- [ ] Return a structured result: imported count, skipped (with reason), and any parse failures.

## Command surface

- [ ] New `#[tauri::command] import_files(paths: Vec<String>) -> Result<ImportSummary, String>`, registered in `lib.rs` `generate_handler!`.

## Frontend (`src/`)

- [ ] Entry point (tray menu and/or main-UI action) → file picker via `@tauri-apps/plugin-dialog` `open({ multiple: true, filters: [{ name: "Markdown", extensions: ["md", "markdown"] }] })`.
- [ ] Invoke `import_files`, surface the result summary (imported / skipped / failed) as a toast or small dialog.
- [ ] Refresh the affected browse/search views so imported notes appear.

## Tests / DoD

- [ ] Round-trip: an exported Notula note re-imports with id/created/taxonomies intact; a second import of the same file is skipped (idempotent).
- [ ] Foreign note (Obsidian-style `tags`/`aliases`, no `id`) imports as a Memo with those keys preserved verbatim and a derived title.
- [ ] Plain markdown with no frontmatter imports with a sensible title and a fresh id.
- [ ] CI green (verbatim CI commands run locally before pushing).

Follow-ups discovered during the brief become parent-linked `follow-up` issues, not scope creep.

---

Linear DEV-639 · M11 - Import/Export capability · created 2026-06-25 · done 2026-06-25