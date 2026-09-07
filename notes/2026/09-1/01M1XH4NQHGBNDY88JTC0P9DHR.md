---
id: 01M1XH4NQHGBNDY88JTC0P9DHR
created: 2026-09-07T08:53:14.609788Z
updated: 2026-09-07T12:40:23.502699Z
type: task
title: Minimum window size
project: 01KY6W9951TW0904DT0GGJVGE7
number: 414
order: 1.0
sprint: segj1dz
assignee: steve
label:
- brief
priority: medium
task_status: active
---
Currently the main window and the new note window can be scaled down to nothing, eventually the note toolbar and top menu start to slide over the right pane.
Set a minimum window size to prevent text overlapping and the window becoming too small to use. Also prevent elements from the centre window overflowing on top of the right pane.

## Agreed scope

Root cause: the note pane's statusbar (`.statusbar`, `NotePane.svelte`) and the
view-tab row (`.tabs`, `ViewTabs.svelte`) are `display: flex` rows with no wrap
and no overflow rule, sitting in a `.panes` container that does not clip, inside
a grid whose side columns are fixed at 248px. As the centre column narrows, the
rows overflow their pane and paint over the Properties panel.

- [ ] `tauri.conf.json`: main window `minWidth: 900`, `minHeight: 600`.
- [ ] `open_capture_window()`: `.min_inner_size(480, 400)` on the builder.
- [ ] `.statusbar` wraps to a second row rather than overflowing (`flex-wrap:
      wrap` + `min-width: 0`). Wrap, not a horizontal scroller — a scroller
      would clip the Insert/Format/Workspace popovers.
- [ ] `.tabs` (ViewTabs) gets the same treatment.
- [ ] `.panes` clipping as belt-and-braces, only if it doesn't clip the board
      overlay or downward popovers.
- [ ] Wrap points measured in the headless-Chrome CSS lab at 1200/900/700px,
      not guessed; lab torn down before commit.