---
id: 01M1XH2VQRR0RD74VJB6B05XQA
created: 2026-09-07T08:52:15.224471Z
updated: 2026-09-07T14:48:29.647581Z
type: task
title: Pop-out notes
project: 01KY6W9951TW0904DT0GGJVGE7
number: 413
order: 2.0
sprint: segj1dz
assignee: steve
label:
- brief
priority: medium
task_status: active
---
Add a button to a note that allows it to be opened in a separate window.

## Agreed scope

A pop-out window carries the note pane **and** the Properties panel, so a task
can be fully edited in it. Both windows stay live-editable and mirror each
other — no "ownership" transfer, no silent clobber.

- [ ] ADR 0058 — pop-out note windows: multiple note windows over one vault
      process, one doc store per window, `note-<id>` label as the routing key,
      and the in-app broadcast that keeps buffers in step.
- [ ] Rust `open_note_window(app, id)` alongside `open_capture_window` — label
      `note-<id>`, title from the note, 820×640, `min_inner_size(640, 420)`,
      drag-drop off, remembered geometry. Existing label ⇒ show + focus.
      Exposed as a command.
- [ ] `capabilities/default.json`: `note-*` window glob +
      `core:window:allow-set-title`.
- [ ] The watcher's `emit_to("main", "note-changed")` becomes a broadcast, so a
      git-sync pull or an MCP write reaches pop-outs too.
- [ ] `window.ts`: `noteWindowLabel` / `noteIdFromLabel`, unit-tested.
- [ ] `+page.svelte`: third branch rendering the new `NoteWindow`.
- [ ] `NoteWindow.svelte`: NotePane + PropertiesPanel, collapsed-rail idiom,
      `onOpenNote`/`onOpenSprint` route to the main window, `onDeleted` closes,
      close request flushes first.
- [ ] `NotePane.svelte`: pop-out button in the statusbar (`Icon name="open"`),
      hidden when already in a pop-out.
- [ ] Cross-window mirror: `DocHandle.flush()` and `noteWrittenInApp()`
      broadcast `note-written` `{id, from}`; the listener ignores its own label
      and routes to `onExternalChange()` — clean buffer reloads, dirty buffer
      raises the existing changed-on-disk guard.