---
id: 01KY6YD3GNA69XB6SRYRKQ1M17
created: 2026-07-23T07:35:24.949797Z
updated: 2026-07-23T11:00:29.013959Z
type: task
title: Live external-change reload + changed-on-disk guard
task_status: done
imported_from: linear
comments:
- id: 01KY6YDBTBBZF7CZQQ91GMYNZ1
  author: Steve Vine
  at: 2026-07-23T07:35:33.450814Z
  text: |-
    Steve Vine · 2026-06-20:

    PR: https://github.com/Steve-vine/notula/pull/25 — In Review. Completes the ADR 0010 arc.

    **Backend** — watcher gains a `SelfWrites` map (note id → sha256 of bytes we wrote) + `content_hash()`; `VaultWatcher::start` takes the map + an `on_external_change` callback. A changed `.md` whose hash matches a recorded self-write is consumed and not reported; any other change fires the callback with the id. Runtime records every `update_note`/`save_note`; `lib.rs` emits `note-changed` (id) to the main window. Index reconcile unchanged; no capability change.

    **Frontend** — a `note-changed` listener dispatches to the open `DocHandle`, which tracks a disk baseline: a clean buffer reloads live; a dirty buffer raises `changedOnDisk` and pauses autosave (no clobber). `NotePane` shows a non-destructive "Changed on disk" banner with **Reload** / **Keep mine**.

    **Tests/gates** — new watcher suppression test + runtime self-write assertion; 42 Rust tests pass; `cargo fmt --check`, `clippy -D warnings`, `npm run check`, `npm run tauri build` all green.

    Holding for your manual sign-off (external edit reloads a clean pane within ~1s, no cursor jump from our own autosave; dirty pane + external change → banner, Reload vs Keep mine both behave) + CI before merge.
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 30
sprint: s6s57kv
---
Implements ADR 0010's external-change handling: panes mirror disk, with a guard for the rare local-dirty conflict.

**Checklist**

- [ ] The file-watcher (DEV-508) emits a `note-changed` event (note id) to the UI on a relevant file change — alongside its index reconcile
- [ ] **Self-write suppression:** the runtime tracks the content (hash) it last wrote per note; a watcher change matching it is **not** broadcast (so our own autosave doesn't reload the editor / jump the cursor)
- [ ] On `note-changed`: a pane whose shared buffer is **clean** (matches last-known disk content) reloads from disk
- [ ] A buffer with **local unsaved edits** + an external change → non-destructive **"changed on disk"** indicator (no overwrite); offer reload-and-discard
- [ ] Cross-window too (capture save → main panes refresh)

**Done when:** editing a note in an external editor (or another machine via a future sync) updates a read-only/clean pane live; a conflicting external change to a dirty editor is surfaced, not silently lost.

**Implements:** ADR 0010 (external-change handling). Depends on DEV-532; builds on DEV-508. No new ADR.

---

Linear DEV-534 · M4 — Main UI · created 2026-06-20 · done 2026-06-20