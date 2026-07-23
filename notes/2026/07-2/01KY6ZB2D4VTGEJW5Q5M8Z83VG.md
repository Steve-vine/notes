---
id: 01KY6ZB2D4VTGEJW5Q5M8Z83VG
created: 2026-07-23T07:51:46.852702Z
updated: 2026-07-23T07:51:46.852702Z
type: task
title: Export current tab to a folder
label: brief
task_status: done
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 92
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