---
id: 01M1XH2VQRR0RD74VJB6B05XQA
created: 2026-09-07T08:52:15.224471Z
updated: 2026-09-07T15:05:44.782904Z
type: task
title: Pop-out notes
project: 01KY6W9951TW0904DT0GGJVGE7
number: 413
order: 2.0
sprint: segj1dz
comments:
- id: 01M1Y62R7EXSP0VDVQ3SSEMSPA
  author: Steve Vine
  at: 2026-09-07T14:59:11.723698Z
  text: |-
    Built on brief-413-pop-out-notes — PR #410. ADR 0058 records the decision.

    Shipped as agreed: a statusbar button opens the note in its own window, carrying the note pane plus the Properties panel; the window label `note-<id>` is the routing key, so re-popping focuses the window already open on that note; both windows stay editable and mirror each other.

    Decisions made on the fly, beyond the agreed scope sketch:

    1. Cross-window freshness needed three signals, not one. `note-written` (planned) keeps buffers in step, but note-derived *lists* refresh off bumpNotes(), which is a call inside one webview — so archive, restore and trash from a pop-out left the main window stale. bumpNotes() now broadcasts `notes-bumped` too; that one choke point covers every in-app write, including the ones that never touch a DocHandle. Deletion still needed its own `note-deleted`, for the overlay-slot tidy-up (NOT-383) no bump can express.

    2. The `note-changed` listener bumps locally rather than calling bumpNotes(). Now that the backend broadcasts that event, routing it back through bumpNotes would multiply one disk change by the number of open windows.

    3. Added `core:window:allow-destroy` to the capability (not in the sketch). Closing intercepts the close request to flush first, then destroys — calling close() again would re-enter the handler.

    4. Window title comes from the frontend, not Rust: a placeholder at build time, overwritten from the live buffer, so renaming a note renames its window without a disk round trip.

    Checks: npm run test (317 pass, incl. 5 new label round-trip tests), npm run check (0 errors, 0 warnings), npm run build, cargo fmt --check, cargo clippy --all-targets -D warnings — all clean.

    Not verified: anything that needs the running app. The visual/behavioural pass is outstanding — in particular popping out, typing in one window and watching the other catch up, editing both at once to see the changed-on-disk guard rather than a silent revert, and closing a pop-out mid-keystroke.
assignee: steve
label:
- brief
priority: medium
task_status: done
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