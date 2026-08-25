---
id: 01M0TKCTZGQAQ056FMW78XDEFF
created: 2026-08-24T19:19:14.16084Z
updated: 2026-08-25T09:09:54.187847Z
type: task
title: Checkboxes not triggering a sync
project: 01KY6W9951TW0904DT0GGJVGE7
number: 402
sprint: segj1dz
comments:
- id: 01M0W2ECGE8BN55Y25DGSQM45B
  author: Steve Vine
  at: 2026-08-25T09:01:27.950388Z
  text: |-
    Done — PR #393 (branch brief-402-403-live-checkbox-and-panel-scrollbar), landed alongside NOT-403.

    Cause: the Live-mode toggle was wired through EditorView.domEventHandlers({mousedown}), but CodeMirror's eventBelongsToEditor() refuses any event whose target sits inside a widget with ignoreEvent() === true — and WidgetType.ignoreEvent defaults to true. CheckboxWidget never overrode it, though TableWidget and CalloutWidget both did. So the handler was never reached: nothing called preventDefault, the native input toggled on screen, and the buffer was untouched. The tick looked applied and was gone on the next render — which is why editing the markdown was the only thing that worked.

    Fix: the widget owns its own DOM handlers now (the idiom ImageWidget already uses), so it doesn't depend on CodeMirror's event routing at all. mousedown preventDefaults to keep the caret out of the source — revealing the markers would swap the checkbox for "- [ ]" text mid-click. click preventDefaults (on a checkbox it's the click default that flips the input, not the mousedown one) and dispatches the marker rewrite, letting the re-render redraw the box from the buffer. toggleTasks is now dead and removed.

    Verified with a negative control, in a headless-browser lab mounting the real extension and clicking the boxes as a mouse would:
      before — click #0: doc " x " / dom "xx ";  after — doc "xx " / dom "xx "
    The before row is your bug exactly: the box ticks on screen while the document never changes.

    Ruled out on the way: git-sync itself is fine — your vault's commit 001938f4 at 19:23 on 24 Aug committed and pushed a "- [ ] Server (Ansible)" → "- [x]" flip, which is what pointed at the frontend rather than the sync layer.

    Follow-up filed as NOT-404: renderMarkdown emits live checkboxes on every surface but only the note pane implements a toggle, so stickies and comments have the same lying-control problem. Not folded in here.
- id: 01M0W2XTWB2DSKP6H5PRFCNDDW
  author: Steve Vine
  at: 2026-08-25T09:09:54.187167Z
  text: |-
    Merged — PR #393 squashed onto main as 845de25, alongside NOT-403. Done.

    Takes effect on the next reload of the note pane's editor (the extension set is built when the view is created), so a hot reload may not be enough — restart the app to be sure.
assignee: steve
label: null
priority: medium
task_status: done
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