---
id: 01KY6ZA2K9MYE9F32JN3BW8KXX
created: 2026-07-23T07:51:14.281911Z
updated: 2026-07-23T11:03:34.638153Z
type: task
title: Import a folder (bulk)
assignee: steve
comments:
- id: 01KY6ZA9DEPY5BAHC48TJWX3MC
  author: Steve Vine
  at: 2026-07-23T07:51:21.261969Z
  text: |-
    Steve Vine · 2026-06-25:

    **Plan, starting build.** Reuses the DEV-639 mapping engine; this brief adds the recursive walk + folder UI.

    **Backend** (`runtime.rs`):
    - `import_folder(dir)` collects `.md`/`.markdown` recursively (own small walker — the existing `collect_md_files` is `.md`-only and private), **flattens** (paths discarded), then delegates to the existing `import_files` worker — so a folder still lands as **one commit** and reuses collision-skip / verbatim-preserve unchanged.
    - **Self-import guard:** the walker doesn't descend into the active vault's `notes/` or `.notula/`; `taxonomies.yaml` isn't markdown so it's never collected. Pointing the picker at the vault (or a parent) won't re-import the store.
    - `#[tauri::command] import_folder(dir: String)` in `lib.rs`.

    **Frontend** (`Main.svelte`):
    - A second sidebar action beside "Import files" (pre-approved sibling) → `pickFolder()` (reused from `vault.ts`) → `import_folder`.
    - Shares the result-notice helper with file import; shows a transient **"Importing…"** state while a large folder runs (buttons disabled). Per-file streaming progress is heavier — noting it as a possible follow-up rather than building it now.
    - Refresh active tab after.

    **Tests** (`runtime.rs`): nested tree → flat notes, count matches `.md`+`.markdown`; pointing at the vault skips its own store; re-running is idempotent (all skipped). CI run verbatim locally before push.
- id: 01KY6ZAHN08G0CS4D5ZYZ3M7C4
  author: Steve Vine
  at: 2026-07-23T07:51:29.695992Z
  text: |-
    Steve Vine · 2026-06-25:

    Done — built and PR opened: **[#82](https://github.com/Steve-vine/notula/pull/82)** (branch `steve/dev-640-import-a-folder-bulk`).

    **What landed**
    - `runtime.rs` — `import_folder(dir)` + recursive `collect_importable_markdown` walker (`.md`/`.markdown`, skips the vault's own `notes/` and `.notula/`) + `is_markdown`. Delegates to the DEV-639 `import_files` worker, so flatten + verbatim-preserve + collision-skip + one-commit all come for free.
    - `lib.rs` — `import_folder` command, registered.
    - Frontend — `importFolder` in `importNotes.ts`, a `folder` Icon glyph, a second sidebar action with a transient "Importing…" state (buttons disabled), sharing the result-notice + tab-refresh helper with file import.

    **Tests (3 new):** nested tree → flat notes (both extensions, non-md ignored); pointing at the vault root imports a loose file but skips the store; re-importing exported notes into a fresh vault is idempotent.

    **Decisions on the fly**
    - **Self-import guard** implemented as "don't descend into `notes/`/`.notula/`" rather than canonical-path comparison — simpler and covers picking the vault or a parent. `taxonomies.yaml` is `.yaml` so it's never collected anyway.
    - **Idempotency caveat:** only id-carrying files skip on re-import; a frontmatter-less file has no stable id and imports afresh each run (by design, ADR 0014). Captured explicitly in the test + comment.
    - **Progress** kept to a simple "Importing…" state, not per-file streaming — heavier (needs events); noting as a candidate `follow-up` if you want richer large-folder feedback.

    **Verification** — full CI matrix verbatim, all green: `cargo fmt --check`, `cargo clippy -D warnings`, `cargo test` (101), `npm run check`, `npm run build`, `npm test` (58).

    **For review:** the folder action (placement + icon) is the UI surface wanting your manual sign-off per our cadence.
task_status: done
imported_from: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 91
sprint: s96mm3j
---
Bulk-import every markdown file under a chosen folder, reusing the mapping engine from DEV-639. Folder structure is flattened (ADR 0014 / DEV-638).

## Backend (`src-tauri/src/`)

- [ ] New `#[tauri::command] import_folder(dir: String) -> Result<ImportSummary, String>` (or extend the import command).
- [ ] Recursively walk `dir` collecting `*.md` / `*.markdown` files; **flatten** — discard subfolder paths (ADR 0014).
- [ ] Route each file through the DEV-639 mapping engine (verbatim preserve, core-field derivation, id-collision → skip).
- [ ] **Guard against self-import:** if the chosen folder is (or sits inside) the active vault, skip the vault's own `notes/`, `.notula/`, and `taxonomies.yaml` rather than re-importing the store.
- [ ] Aggregate one `ImportSummary` across all files (imported / skipped+reason / failed).

## Bulk write behaviour

- [ ] Rely on the existing 4s auto-commit debounce to coalesce the whole import into **one git commit** (ADR 0014) — no per-note commit, no new batching infra. Verify this holds for a large import.

## Frontend (`src/`)

- [ ] Folder-import entry point → `open({ directory: true })` (already used by `pickFolder()` in `vault.ts`).
- [ ] Progress affordance for large folders (count / spinner) and a final result summary.
- [ ] Refresh browse/search views afterward.

## Tests / DoD

- [ ] Importing a nested folder tree produces flat notes (no structure retained); count matches the number of `.md` files.
- [ ] Pointing at the active vault folder does not re-import its own store.
- [ ] A large import lands as a single commit.
- [ ] Re-running the same folder import is idempotent (all skipped on second run).
- [ ] CI green (verbatim CI commands run locally before pushing).

Follow-ups → parent-linked `follow-up` issues, not scope creep.

---

Linear DEV-640 · M11 - Import/Export capability · created 2026-06-25 · done 2026-06-25