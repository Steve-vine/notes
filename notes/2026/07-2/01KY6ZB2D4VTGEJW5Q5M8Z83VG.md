---
id: 01KY6ZB2D4VTGEJW5Q5M8Z83VG
created: 2026-07-23T07:51:46.852702Z
updated: 2026-07-23T12:24:56.711739Z
type: task
title: Export current tab to a folder
label: null
task_status: done
comments:
- id: 01KY6ZB9EQYXHDENVD2357HFNY
  author: Steve Vine
  at: 2026-07-23T07:51:54.071506Z
  text: |-
    Steve Vine · 2026-06-25:

    **Plan, starting build.** The export counterpart; reads the active tab's note set and writes round-trippable `.md` files.

    **Frontend** (`Main.svelte`) — resolve the current tab to a deduped id set:
    - **Search** → `results` ids · **Browse** → ids under the expanded value(s) (`Object.values(expanded).flat()`) · **Board** → all card ids across `boardColumns`.
    - A `$derived` count drives an **Export action** in the sidebar (sibling of the import actions) — disabled when the set is empty. Picks a destination via `pickFolder()`, calls `export_notes`, flashes a shared "Exported N" notice (reusing the import status line), shows a transient "Exporting…" state.

    **Backend** (`runtime.rs` + `lib.rs`):
    - `export_notes(ids, dest)` — read-only: for each id, `read_note` (full on-disk content, round-trip frontmatter per ADR 0014) and write to `dest`. No index/git writes.
    - **Filenames:** slug of the note title, numeric suffix on collision, fallback to the id when titleless. New `slugify` + `export_filename` helpers (none exist today).
    - `#[tauri::command] export_notes(ids, dest)`.

    **Tests** (`runtime.rs`): exported file re-imports losslessly (id/created preserved); two same-title notes get distinct filenames; a titleless note exports under its id; a bad id is reported as failed.

    **For your sign-off (UI):** the Export action sits as a 4th sidebar footer button beside the two import actions — consistent home, but it's tab-contextual, so happy to move it into the tab/pane area if you'd prefer. CI run verbatim before push.
- id: 01KY6ZBHT2QDX7KF0GAY8A1VCV
  author: Steve Vine
  at: 2026-07-23T07:52:02.626208Z
  text: |-
    Steve Vine · 2026-06-25:

    Done — built and PR opened: **[#83](https://github.com/Steve-vine/notula/pull/83)** (branch `steve/dev-641-export-current-tab-to-a-folder`). This closes out M11.

    **What landed**
    - `runtime.rs` — `export_notes`/`export_one` (read-only: `read_note` → write full content to dest) + `slugify`/`export_filename` helpers. `ExportSummary`/`ExportFailure` structs.
    - `lib.rs` — `export_notes` command, registered.
    - Frontend — `exportNotes.ts`, an `export` Icon glyph, `currentTabNoteIds()` (search results / expanded browse value(s) / board cards, deduped) + a `$derived` count that disables Export when empty, and the sidebar Export action with an "Exporting…" state. Refactored the shared status line into `flashNotice`.

    **Tests (4 new):** round-trip (export → re-import into a fresh vault preserves id+created); same-title disambiguation + id fallback; bad id → failed; slugify cases.

    **Decisions on the fly**
    - **Filename length** capped by *char* count (not bytes) so a multibyte title can't panic `String::truncate`.
    - **Status line** generalised: `importNotice`/`importTimer` → `ioNotice`/`ioTimer` + a shared `flashNotice`, reused for both import and export messages.
    - **Browse-tab scope** = the *expanded* value(s) (what's visibly shown), per ADR 0014; Export is disabled when nothing is expanded.

    **Verification** — full CI matrix verbatim, all green: `cargo fmt --check`, `cargo clippy -D warnings`, `cargo test` (105), `npm run check`, `npm run build`, `npm test` (58).

    **For review:** Export sits as a 4th sidebar footer button beside the import actions — the UI surface wanting your manual sign-off (placement/icon). Easy to relocate if you'd rather it lived in the tab/pane area.
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 92
sprint: s96mm3j
---
Export the notes shown by the **current browser tab** to `.md` files in a chosen folder, written with full Notula frontmatter so they round-trip back via import (ADR 0014 / DEV-638). Independent of the import briefs.

## Current note set (frontend, `src/lib/Main.svelte`)

Resolve the active tab to a set of note ids:

- [ ] **Tab 2 (Search):** the current `results` (`SearchHit[]` → ids).
- [ ] **Tab 1 (Browse):** notes under the currently expanded value(s) of the selected axis (`expanded` / `browseNotes(axisId, valueId)`).
- [ ] (If a board view is in scope) the board's current filtered set.
- [ ] Define behaviour when the set is empty (disable the export action / no-op with a message).

## Backend (`src-tauri/src/`)

- [ ] New `#[tauri::command] export_notes(ids: Vec<String>, dest: String) -> Result<ExportSummary, String>`, registered in `lib.rs`.
- [ ] For each id, write the note's **full file content** (complete frontmatter, round-trip) into `dest`.
- [ ] **Filenames:** slugify the title; resolve collisions with a numeric suffix; fall back to the note id when there's no usable title. `.md` extension.
- [ ] Return an `ExportSummary` (written count, destination path, any failures). Export reads only — no index/git writes.

## Frontend

- [ ] Export entry point on the active tab → destination folder via `open({ directory: true })` (or a save dialog).
- [ ] Pass the resolved id set + destination to `export_notes`; surface the result summary.

## Tests / DoD

- [ ] Export from the search tab writes exactly the result set; from the browse tab writes the expanded value's notes.
- [ ] Exported files re-import cleanly (lossless round-trip with DEV-639): ids/created/taxonomies preserved.
- [ ] Title collisions produce distinct filenames; a titleless note exports under its id.
- [ ] CI green (verbatim CI commands run locally before pushing).

Follow-ups → parent-linked `follow-up` issues, not scope creep.

---

Linear DEV-641 · M11 - Import/Export capability · created 2026-06-25 · done 2026-06-25