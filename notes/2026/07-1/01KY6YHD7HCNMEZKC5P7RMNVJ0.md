---
id: 01KY6YHD7HCNMEZKC5P7RMNVJ0
created: 2026-07-23T07:37:45.969836Z
updated: 2026-07-23T11:04:51.19418Z
type: task
title: Update Main UI Edit
task_status: done
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 36
comments:
- id: 01KY6YHN1RDDSME2YFDWVZ3JPT
  author: Steve Vine
  at: 2026-07-23T07:37:53.975917Z
  text: |-
    Steve Vine · 2026-06-21:

    PR: https://github.com/Steve-vine/notula/pull/34 — In Review.

    Editor now matches the capture form, with the meta header (Type/Project/Taxonomy) **above the title**, editable in both read and edit modes; title/body borderless and edit-only. **Autosave unchanged** (ADR 0010) — every change persists automatically. **Absorbs DEV-519**.

    Backend: `update_note` extended to type/project/taxonomy (full-replace of the classification); `load_note`/`NoteView` surface project + values; `note.rs` gains `set_type`/`remove_field`. Frontend: `DocHandle` now holds + autosaves all fields with the baseline/changed-on-disk guard spanning them; `NotePane` reworked; `TaxonomyEditor` gains an `onchange` hook.

    Gates green: 44 cargo tests (new type/project/taxonomy round-trip), 31 vitest, `npm run check` clean, `clippy -D warnings`, `npm run tauri build`.

    Suggest closing **DEV-519** as absorbed by this. Holding for your manual sign-off + CI before merge.
sprint: sevsjkn
---
Update the main UI edit feature to work in the same way, look and feel as the new issue form.  Same layout, taxonomy settings etc.

---

Linear DEV-545 · M5 — Tasks & projects · created 2026-06-21 · done 2026-06-21