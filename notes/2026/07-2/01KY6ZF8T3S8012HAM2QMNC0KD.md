---
id: 01KY6ZF8T3S8012HAM2QMNC0KD
created: 2026-07-23T07:54:04.483298Z
updated: 2026-07-23T11:00:29.540561Z
type: task
title: Attach from the editor (picker + drag-drop + paste)
task_status: done
imported_from: linear
comments:
- id: 01KY6ZFFJTDGR2FGC36FCZ0PHB
  author: Steve Vine
  at: 2026-07-23T07:54:11.418247Z
  text: |-
    Steve Vine · 2026-06-26:

    **Agreed plan (planned with Steve):**

    Three input routes into both the NotePane editor and the Capture window, inserting the right markdown at the cursor (`![name](ref)` for images, `[name](ref)` otherwise):
    - **File picker** (`@tauri-apps/plugin-dialog`) → path → `attach_file` (DEV-648).
    - **Paste** (clipboard image) → bytes → new `attach_bytes` command.
    - **Drag-drop** → **HTML5 DnD, keep `dragDropEnabled:false`** → File bytes → `attach_bytes` (same path as paste, element-scoped so we know which editor).

    **Capture id (decided): front-mint.** Capture generates a ULID up front; `save_note` gains an optional `id` so the attach folder and the saved note share one id. Attach-then-cancel leaves an orphan folder that DEV-652 will GC.

    **Build:**
    - Backend: `attach_bytes(note_id, name, bytes)` command + `VaultRuntime::attach_bytes`; refactor `attachment::store` to share with a bytes variant; add optional `id` to `NewNote`/`save_note`.
    - Frontend: a shared `$lib/attach.ts` (pure helpers: `isImageName`, `referenceMarkdown`, `spliceAtCursor`; plus `attachPath`/`attachBytes`/`pickAndAttach`) unit-tested; wire an Attach button + paste + drop handlers into NotePane and Capture.

    Both forks chosen as recommended. Moving to In Progress.
- id: 01KY6ZFTH93F95A5K515X8NW1B
  author: Steve Vine
  at: 2026-07-23T07:54:22.63291Z
  text: |-
    Steve Vine · 2026-06-26:

    Built and opened [PR #88](https://github.com/Steve-vine/notula/pull/88). Branch `steve/dev-650-attach-from-the-editor-picker-drag-drop-paste`.

    **Checklist — all done:**
    - ✅ "Attach file" picker → `attach_file` → reference inserted at the cursor.
    - ✅ Drag-drop onto the editor → File bytes → `attach_bytes` → inserted. (Kept `dragDropEnabled:false` / HTML5 DnD per the plan, **not** the Tauri-event path the checklist originally suggested — drop and paste share one code path and we know which editor was targeted.)
    - ✅ Paste an image → bytes → `attach_bytes` → inserted.
    - ✅ `![name](ref)` for images / `[name](ref)` otherwise; triggers `markEdited` autosave.
    - ✅ Wired into **both** NotePane and Capture; Capture front-mints the note id (`new_note_id`) so a pre-save attachment shares it.

    **Decisions on the fly:**
    1. **`new_note_id` backend command** rather than a JS ULID lib (none in the frontend deps) — Capture front-mints a real, valid id.
    2. **Drop & paste unified** via `attach_bytes` + a shared `filesFrom()` (HTML5 DnD), so both are element-scoped; the picker stays path-based via `attach_file`.
    3. **Capture window needed `disable_drag_drop_handler()`** — programmatically-built windows default to Tauri's native drag-drop (which would swallow the HTML5 drop). Caught and fixed.
    4. **Paste/drop bytes cross IPC as a JSON number array** — fine for typical images; a known v1 limit for very large files (a raw-body command could be a later optimisation).

    **CI:** `cargo fmt --check`, `clippy -D warnings`, `cargo test` (119 ✓, +2), `npm run check` (0 errors), `npm test` (69 ✓, +5), `npm run build` — green. Release `tauri build` bundle skipped.

    **⚠️ Manual verify (UI brief).** Now end-to-end testable without hand-editing files:
    1. **Main editor:** edit a note → **Attach** a file (picker); **drag** an image onto the body; **paste** a screenshot. Each should insert markdown at the cursor; switch to read mode → image inline, file link opens externally.
    2. **Capture window:** open via hotkey/tray, attach the same three ways, Save, then open the note → attachments present (confirms front-minted id is reused, one note, no dupe).

    Moving to In Review for your check + merge call. After this, DEV-651 (import/export round-trip) and DEV-652 (orphan cleanup) remain.
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 98
sprint: sy430a6
label: null
---
The capture side: let the user add an attachment while editing, by three routes, inserting the correct markdown at the cursor. Calls `attach_file` (DEV-648) and uses the reference form from ADR 0015. Covers **both** the main `NotePane` editor and the lightweight **Capture** window.

## Checklist

- [ ] "Attach file" affordance using `tauri-plugin-dialog` file picker → `attach_file` → insert reference at the textarea cursor
- [ ] Drag-and-drop a file onto the editor: flip `dragDropEnabled` in `tauri.conf.json` and handle Tauri's drag-drop events → copy via `attach_file` → insert at drop point
- [ ] Paste an image from the clipboard → write to a temp file / pass bytes → `attach_file` → insert
- [ ] Insert `![name](ref)` for images, `[name](ref)` for other types (per ADR 0015 embed-vs-link rule); trigger the autosave/markEdited path so the body persists
- [ ] Wire the same affordances into `Capture.svelte` (note: capture mints the note id on save — define how an attachment added before first save gets its `<note-id>` folder)

## Done when

- [ ] A user can attach via picker, drag-drop, and paste in the main editor, and the reference renders (with DEV-649) in read mode
- [ ] Attaching works in the Capture window
- [ ] CI green (verbatim CI commands run locally), PR opened

---

Linear DEV-650 · M12 - Attachments · created 2026-06-25 · done 2026-06-26