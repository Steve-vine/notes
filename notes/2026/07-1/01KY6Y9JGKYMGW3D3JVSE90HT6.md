---
id: 01KY6Y9JGKYMGW3D3JVSE90HT6
created: 2026-07-23T07:33:29.235871Z
updated: 2026-07-23T11:00:29.418276Z
type: task
title: Real Open-in-UI hand-off from capture
comments:
- id: 01KY6Y9SSDTES5YPA638GVT8TY
  author: Steve Vine
  at: 2026-07-23T07:33:36.685014Z
  text: |-
    Steve Vine · 2026-06-20:

    **Done building — in review.**

    **What was done** (frontend + capability):
    - `Capture.svelte`: `persist()` returns the new note id; `openInUi()` → `emitTo("main", "open-note", id)` → show/focus main → close capture.
    - `Main.svelte`: `onMount` listens for `open-note` → `openNote(id)` (opens into the focused pane).
    - `capabilities/default.json`: added `core:event:default`.

    No backend change — `save_note` already returns the id.

    **Verification** — `npm run check` (0/0), fmt, clippy `-D warnings` (exit 0), `cargo test` (41, Rust unchanged), `npm run tauri build` (validates the new capability). **Interactive hand-off needs your manual sign-off** (restart `tauri:dev`).

    **Please verify:** Option+Space → type a note → **Open in UI** → capture closes, main comes to front with that note open in the focused pane. Plain **Save** still just closes; **Cancel** discards.

    **Scope:** last *planned* M4 brief. Remaining: DEV-527 (split polish), DEV-529 (concurrent-edit bug), DEV-530 (markdown render). No new ADR.

    **PR:** https://github.com/Steve-vine/notula/pull/21 · commit `82fe89d`
    Holding the merge for your sign-off.
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 22
sprint: s6s57kv
label: null
---
Wire the capture window's **Open in UI** button to actually open the just-saved note in the main window (it currently only shows the main window — the M3 placeholder).

**Checklist**

- [ ] On Open-in-UI: save the note, then focus the main window **and open that note** in the viewer (a pane)
- [ ] Pass the new note id to the main window (e.g. event/`emit` to the `main` window, or a pending-open command the main UI reads on focus)
- [ ] Main window opens/loads the note (reuse the DEV-513 viewer; a pane if DEV-516 has landed)

**Done when:** clicking Open-in-UI in capture shows the just-created note open in the main UI.

**Scope:** completes the capture↔main hand-off deferred in DEV-510. Depends on DEV-513 (viewer); composes with DEV-516 if present.

---

Linear DEV-517 · M4 — Main UI · created 2026-06-20 · done 2026-06-20