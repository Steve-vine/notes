---
id: 01KY6Y8KMTTPV5D2XXP2R03J7Q
created: 2026-07-23T07:32:57.626102Z
updated: 2026-07-23T11:03:35.001318Z
type: task
title: Note editing (read/edit toggle + save)
assignee: steve
comments:
- id: 01KY6Y8TWDA3HH0GZQPYM4BS6B
  author: Steve Vine
  at: 2026-07-23T07:33:05.037337Z
  text: |-
    Steve Vine · 2026-06-20:

    **Done building — in review.**

    **What was done**
    - **Backend:** `Note::set_title` (set/clear) + `Note::touch_updated`; `runtime::update_note(id, title, body)` → load → set body/title → touch `updated` → write → reconcile. Unknown frontmatter preserved (DEV-482 format-preserving model). Command `update_note` wired.
    - **Frontend:** `notes.ts` `updateNote`; `Main.svelte` viewer status bar with a **read / edit** toggle — edit mode = title input + body textarea + Save/Cancel; save → reload → read.

    **Verification** — `npm run check` (0/0), fmt, clippy `-D warnings` (exit 0), `cargo test` (**41 pass**, 2 new: edit preserves unknown keys + bumps `updated`; update reindexes), `npm run tauri build`. **Interactive edit needs your manual sign-off** (restart `tauri:dev` for the new command).

    **Please verify:** open a note → **Edit** → change body/title → **Save** → reopen/search reflects it; **Cancel** discards.

    **Scope:** body + title only this brief. **Taxonomy-value editing** (incl. Task Status) deferred → filed **DEV-519** (M5). Splits = DEV-516; Open-in-UI = DEV-517. No new ADR.

    **PR:** https://github.com/Steve-vine/notula/pull/19 · commit `61fe569`
    Holding the merge for your sign-off.
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 20
sprint: s6s57kv
---
Make the note viewer editable (`brief/ui.md` read/edit toggle).

**Checklist**

- [ ] A **read / edit** toggle on the note view
- [ ] Edit the body (and the title / applicable taxonomy values — reuse the scope-driven selectors from DEV-511 where practical)
- [ ] Save: update the note on disk (touch `updated`), preserving unknown frontmatter (format-preserving model, DEV-482), and reindex
- [ ] Read IPC: `update_note(id, …)` command on the runtime (write via the `Note` model + `reconcile_path`)

**Done when:** toggling to edit, changing a note, and saving persists the change to disk and the index reflects it.

**Scope:** the per-pane status bar that hosts this toggle is finalised in the split-panes brief; here it can live on the single pane. Depends on DEV-513.

---

Linear DEV-515 · M4 — Main UI · created 2026-06-20 · done 2026-06-20