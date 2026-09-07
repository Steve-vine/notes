---
id: 01M1XH4NQHGBNDY88JTC0P9DHR
created: 2026-09-07T08:53:14.609788Z
updated: 2026-09-07T12:54:12.010685Z
type: task
title: Minimum window size
project: 01KY6W9951TW0904DT0GGJVGE7
number: 414
order: 1.0
sprint: segj1dz
comments:
- id: 01M1XYXQSD6Z65C1M95YASX1JP
  author: Steve Vine
  at: 2026-09-07T12:54:07.402529Z
  text: |-
    Built on brief-414-minimum-window-size — PR #409.

    Measured the overflow in a throwaway headless-Chrome CSS lab rather than guessing (the real tokens + the real .statusbar / .tabs / .app rules at 1400/1200/1000/900/800/700px):

    - Natural widths: statusbar 541px, view-tab row 529px. With 248px side columns they fit down to a ~1200px window.
    - At 1000px they spill +72px / +43px into the Properties panel; at 700px, +372px / +343px.
    - With flex-wrap: wrap the spill is the padding value (-15px / -7px) at every width down to 700px; the rows take a second line below ~1065px, a third at 700px.
    - flex-wrap alone is sufficient — min-width: 0 changed nothing (the row is a stretched item in a column flex container).

    Changes: main window minWidth 900 / minHeight 600; capture window min_inner_size(480, 400); flex-wrap: wrap on .statusbar and .tabs.

    Decision made on the fly: dropped the planned .panes clipping. It was belt-and-braces only, and with the rows wrapping nothing reaches the panel — while overflow: hidden there would clip the board overlay and any downward popover. Chose wrap over a horizontal scroller for the same reason: a scroll container clips the Insert / Format / Workspace popovers that open out of the statusbar.

    Checks: npm run test (312 pass), npm run check (0 errors), cargo fmt --check, cargo clippy --all-targets -D warnings — all clean. Lab torn down. Visual pass on the real app still outstanding.
assignee: steve
label:
- brief
priority: medium
task_status: review
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