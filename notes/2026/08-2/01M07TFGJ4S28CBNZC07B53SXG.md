---
id: 01M07TFGJ4S28CBNZC07B53SXG
created: 2026-08-17T12:17:27.620308Z
updated: 2026-08-24T19:37:34.829242Z
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