---
id: 01M07TFGJ4S28CBNZC07B53SXG
created: 2026-08-17T12:17:27.620308Z
updated: 2026-08-24T20:30:01.712395Z
type: task
title: Better Tables
project: 01KY6W9951TW0904DT0GGJVGE7
number: 399
sprint: segj1dz
comments:
- id: 01M0TMEDVD9P8P18XFPCV987FB
  author: Steve Vine
  at: 2026-08-24T19:37:34.8288Z
  text: |-
    Done — PR #392 (branch brief-399-editable-tables), ADR 0054.

    Decisions made on the fly:

    - Cells reveal source on focus rather than always showing raw markdown. Always-raw is simpler but would make a table the one place in Live mode that doesn't render. Reveal-on-focus is the idiom the rest of Live mode already uses, just moved from line to cell granularity.

    - Controls sit in a gutter row/column, not an absolutely-positioned overlay. An overlay looks tidier but would have to track column widths, scrolling and zoom to stay aligned; a gutter is part of the same table layout and cannot drift.

    - Serialisation normalises cell padding, so the first edit tidies a hand-aligned table to "| cell | cell |". Preserving original spacing would mean carrying formatting trivia through the model for a diff-cosmetic benefit.

    Problem solved along the way: a cell edit dispatches a change, which rebuilds the decoration — so the naive version dropped focus out of the cell on every keystroke. Fixed by keeping the markdown the widget currently shows on the element (dataset.source) and having updateDOM return true when the incoming widget matches, preserving the DOM and the focus with it. dataset.from is refreshed on the way through because an edit above the table moves it without changing its text.

    That leans on two CodeMirror behaviours, both verified in the installed source and recorded in the ADR as dependencies: readMutation returns null for widget tiles (so typing in a cell is never reconciled away), and updateSelection only writes the DOM selection when .cm-content is itself the active element (so the caret isn't yanked out of a focused cell). A major CM upgrade should re-check both — the failure mode would show immediately as focus loss while typing.

    Not verified by me: the widget's focus/contenteditable behaviour can't be exercised headlessly (no DOM env configured for vitest, and jsdom wouldn't model editing-host focus faithfully anyway). The model has 23 unit tests; the integration wants an eyeball. Worth checking: typing across several cells without losing focus, Tab/Enter navigation, the row/column buttons, alignment cycling, and the </> escape hatch.

    Verified: npm run check (0 errors), npm test (270), npm run build.
- id: 01M0TPCD2YZQGG28DXV8471VN4
  author: Steve Vine
  at: 2026-08-24T20:11:25.66157Z
  text: /Users/steve/Library/Application Support/CleanShot/media/media_mwc9JyAf10/CleanShot 2026-08-24 at 21.10.17@2x.png
- id: 01M0TQEEZG9QWCRJ2W4XV0QDYM
  author: Steve Vine
  at: 2026-08-24T20:30:01.711751Z
  text: |-
    Reworked the controls after the screenshot — second commit on brief-399-editable-tables, PR #392 updated.

    The screenshot showed two separate problems.

    1. Layout: the table was being squeezed to the pane width, so the browser distributed the space evenly and wrapped "Column 1" mid-word. Now width: max-content inside an overflow-x: auto wrapper — columns fit their contents and a wide table scrolls. A single cell is capped at 22rem so one long paragraph can't push the rest off-screen.

    2. Controls: the per-cell +/×/align clusters are gone, replaced with the model you described. A grip above each column and left of each body row — click to select, drag to reorder. One + down the right edge for a column, one along the bottom for a row. Deleting goes through the selection: the selected grip swaps its bar for that axis's actions (delete, plus alignment cycling for a column), and Delete/Backspace does the same from the keyboard. The header row has no grip — a GFM table has exactly one, movable and deletable by nobody.

    New in the model: moveRow / moveColumn, with tests. The drop target during a drag is read from the grips' live geometry, so it's correct whatever the column widths are, and previewed by tinting the grip it would land on.

    Two implementation notes worth keeping: grips build their action buttons up front and CSS reveals them, so selecting toggles classes rather than rebuilding — a redraw triggered by clicking into a cell would destroy the element about to take focus. And press-without-move is handled in mouseup, not a click listener, which would otherwise fire after every drag too.

    Not done: cell-range selection ("highlighting cells" to clear them). A row or column can be selected; a rectangle can't. That's spreadsheet territory and the markdown behind it has no notion of it, so it's recorded as out of scope in ADR 0054 rather than half-built — worth its own task if you want it.

    ADR 0054 updated, including why the cluster-of-buttons version was rejected. npm run check, npm test (274), npm run build all green.
assignee: steve
priority: medium
task_status: review
---
In Live view, tables appear as markdown tables, a better approach would be the same way Obsidian show tables as actual tables that can be edited (add/remove row/column) with the mouse.

## Discussed and agreed

Full Obsidian-style editable widget (rather than a toolbar-only middle ground):
cells become editing hosts writing back into the markdown buffer, with mouse
controls for rows, columns and alignment. Needs an ADR — it is the first place
a Live widget mutates the buffer rather than merely revealing its source.

## Agreed work

- `src/lib/table.ts`: pure GFM model — parse/serialise plus insert/delete
  row/column, set cell, set alignment. No DOM, no CodeMirror; unit-tested.
- Rewrite `TableWidget` in `livePreview.ts`: editable cells, gutter controls,
  keyboard navigation, and a `</>` escape hatch back to raw markdown.
- Keep the DOM across the widget's own edits (`updateDOM` + `dataset.source`)
  so focus survives each keystroke's transaction.
- Cells render inline markdown off-focus, raw source on focus.
- ADR 0054 recording the model and the two CodeMirror behaviours it leans on.