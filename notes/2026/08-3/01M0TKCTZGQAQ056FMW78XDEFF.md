---
id: 01M0TKCTZGQAQ056FMW78XDEFF
created: 2026-08-24T19:19:14.16084Z
updated: 2026-08-25T08:54:36.121222Z
type: task
title: Checkboxes not triggering a sync
project: 01KY6W9951TW0904DT0GGJVGE7
number: 402
sprint: segj1dz
assignee: steve
priority: medium
task_status: active
---
Ticking (or unticking) a checkbox doesn’t trigger a sync, therefore ticking things off on a list gets lost, only editing the MD seems to work.

Confirmed with Steve: this is **Live view**, clicking the rendered checkbox with
the mouse.

## Cause

Live mode renders the checkbox as a `CheckboxWidget`, and the toggle is wired
through `EditorView.domEventHandlers({ mousedown })` (`toggleTasks`). But
CodeMirror's `eventBelongsToEditor()` refuses any event whose target sits inside
a widget with `ignoreEvent() === true` — and `WidgetType.ignoreEvent` **defaults
to true**. `CheckboxWidget` never overrides it (`TableWidget` and
`CalloutWidget` both did), so the handler is never reached.

Nothing then calls `preventDefault`, so the native `<input>` toggles on screen
and the buffer is untouched — the tick looks applied, is never written, and
vanishes on the next render. The read view's own handler is unaffected, which is
why editing the markdown works.

## Agreed work

Give the widget its own DOM handlers in `toDOM()` rather than relying on
CodeMirror's event routing — the idiom `ImageWidget` already uses:

- `mousedown` → `preventDefault` so the caret doesn't move into the source.
- `click` → `preventDefault` (this is what actually cancels a checkbox's native
  toggle; on `mousedown` it does not) then dispatch the marker rewrite.

`toggleTasks` is then dead and goes.

Verified end-to-end in a headless-browser lab that mounts the real extension,
clicks the checkbox and reads back the document text.