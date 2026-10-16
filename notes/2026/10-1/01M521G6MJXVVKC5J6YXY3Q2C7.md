---
id: 01M521G6MJXVVKC5J6YXY3Q2C7
created: 2026-10-16T09:43:12.786053Z
updated: 2026-10-16T09:43:15.530264Z
type: task
title: A table always fits its section and the page — column widths are shares of the width, so dragging a column never pushes the table off the right edge, on screen, in the PDF or in Word
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1004
sprint: s2ufsxd
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found in Steve's smoke test of sprint 71 (COM-988 / COM-989), 2026-10-16.

## What is wrong

1. **In the editor,** dragging a column border can make a table wider than its section, so it runs out past the section's right edge.
2. **In the PDF (and Print preview),** as soon as any column width has been changed, the table runs off the right-hand side of the page. It can look fine on a wide screen and still not fit on paper. A new table whose widths have never been touched fits, because it simply fills the width.

**Why:** a dragged width is saved in screen pixels, for example 380 px. The PDF uses those pixels as they are. A page's text area is only about 640 px wide, so widths dragged on a wide screen add up to more than the page. Nothing in the editor stops the columns adding up to more than the section, either.

## What people see

- **A table is always exactly the width of its section, and on paper the width of the page's text area.**
- **Dragging a column border moves width between the two columns either side of it,** as in a Word table set to the page width. One gets wider and its neighbour narrower, and the table as a whole doesn't change width. The right-hand edge of the table can't be dragged out past the section.
- **Column widths keep their proportions everywhere.** A column that takes a third of the section on screen takes a third of the page in the PDF and in Word, whatever the screen size.
- **Each column has a sensible minimum,** so dragging can't crush one to nothing.
- **Tables already on staging** that were dragged wider than the page fit straight away, in their current proportions. Nothing needs re-editing, and no data changes.
- A table whose widths have never been touched is unchanged: equal shares, full width.

## Technical

- **Stored widths stay as they are** (`colwidth`, pixels, on each cell: the Tiptap/prosemirror-tables format, and the lossless Markdown's `data-colwidth`). They're read as **proportions** wherever they're used, so no migration and no Markdown change.
- **PDF / Print preview:** `core/render/html.py` `_table` (≈197–211) writes `<col style="width:{w}px">`.
  - Write percentages instead: each known width ÷ the total, where a column with no width counts as the average of the known ones (or the minimum, if none are known).
  - Keep `table.rt-table { width: 100% }` and add `table-layout: fixed`, so WeasyPrint honours the `<col>` shares.
  - Unit-test: widths [600, 600, 200] → 42.9% / 42.9% / 14.3%, and the table fits the frame.
  - Render a real PDF with a dragged table and check no box overflows the page.
- **Word:** `core/render/word.py` (≈331) builds the table with no widths, so Word auto-fits.
  - Set each column's width to its share of the text width (the picture code at ≈385 already works out `text_width`);
  - turn autofit off, so Word keeps the shares.
- **Editor** (`content/richtext/extensions.ts:315`, `TableKit.configure({ table: { resizable: true } })`):
  - prosemirror-tables' column resizing grows one column and the table with it; it has no "keep the total" mode.
  - Add a small plugin (an `appendTransaction` on `colwidth` changes): after a resize, take the width added to the dragged column from the column to its right, so the sum stays at the section's content width (read from the editor DOM). Floor every column at `cellMinWidth`.
  - Belt and braces in `richtext.css`: `.rt-doc .tableWrapper { overflow-x: auto; }` and `.rt-doc table { max-width: 100%; }`, so a table carried over from before this fix can never spill outside the card.
  - Render the editor's `<col>`s as percentages too, by overriding the TableView's `updateColumns`, so a table edited on a wide screen looks the same on a narrow one.
- **Read tab** (`RichTextView`) uses the same proportional rule as the PDF.
- **Tests:**
  - Python: html.py percentages, and a Word table's widths add up to the text width.
  - Vitest: the plugin keeps the total when a column's width changes.
  - The Playwright harness: drag a border on a 1,600 px-wide screen, then check the table is still no wider than its section, and that its PDF fits the page.

## Done when

- [ ] Dragging a column border can't make a table wider than its section.
- [ ] A table with dragged widths fits the page in Print preview, the PDF and Word, in the same proportions as on screen.
- [ ] Tables already on staging that run off the page now fit, with nothing re-edited.
