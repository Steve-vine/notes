---
id: 01M5S9Z949N2K5XZDZCF4M7S7Q
created: 2026-10-25T10:33:47.401145Z
updated: 2026-10-25T16:24:33.586956Z
type: task
title: 'DDQ: the completed spreadsheet hides most answers — written cells don''t wrap and rows keep the client''s fixed heights'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1301
sprint: ssgnel8
comments:
- id: 01M5SHT4M909MMZS996DT70Z12
  author: Steve Vine
  at: 2026-10-25T12:50:47.561715Z
  text: |-
    Done — merged to main (PR #1313, 9c45ebad).

    - Every cell Compass writes into the client's spreadsheet now wraps, aligned to the top: answers, other fields, evidence lists and cover fields. The client's font, fill, border and horizontal alignment are kept.
    - Each row written into grows to fit its longest text. It never shrinks, and stops at Excel's maximum (409pt).
    - Column widths, and the rows Compass doesn't write into, stay as the client designed them.
    - The completed file's name drops a trailing "BLANK" or "Template": "… 3rd party supplier — completed 2026-10-25.xlsx".

    My calls (awaiting you):
    - "BLANK"/"Template" is dropped in any case, after a space, dash or underscore, or in brackets.
    - A row inside a merged block grows at the block's last row.

    Deviation: the height estimate adds no padding, so a one-line answer doesn't nudge the client's 16pt rows taller.
assignee: steve
label: null
priority: high
task_status: done
---
## What I found

Steve asked me to review DDQ-4's completed file ("2020 Business Continuity Due Diligence - 3rd party supplier - BLANK — completed 2026-10-25.xlsx"). Compared cell by cell with the client's original:

- **Right:**
  - all 29 responses are in column C;
  - the 5 evidence lists are in column E;
  - the cover fields are in C1 and E1;
  - none of the client's text is changed;
  - their fonts, fills, borders, merged cells, column widths and sheets are kept;
  - no DRAFT sheet.
- **Wrong:** **30 of the 34 written cells are cut off when the file is opened.** The client's template has a narrow response column (width 21) and fixed row heights: 16pt for most rows (one line), 32–96pt for the rest. Rows 16–30 also have wrapping switched off. So a 400-character answer shows its first line or so, and the reader has to resize every row to read it. Examples:
  - C8 needs about 20 lines and shows 4;
  - C26 needs about 16 and shows 2;
  - C16–C30 show one line, unwrapped.

## Behaviour

- Every cell Compass writes an answer, field, evidence list or cover field into is set to **wrap text, aligned to the top**. The client's font, fill, border and number format are kept.
- Each row Compass writes into is made **tall enough for the longest thing written in it**, estimated from the column's width (or the merged block's) and the font size. It's only ever raised, never lowered, and capped at Excel's maximum row height. Rows Compass doesn't write into keep the client's height.
- Column widths are not changed, so the client's layout stays as they designed it.
- The same applies to a DRAFT file.
- A Word questionnaire is unaffected, because table rows grow with their text.

## Minor, same task

- **The completed file's name** drops a trailing "BLANK" or "Template" from the client's file name: "2020 Business Continuity Due Diligence - 3rd party supplier — completed 2026-10-25.xlsx". It's otherwise unchanged. (My call.)

## Not a problem (checked)

The client's SharePoint document metadata (customXml) and the printer-driver blob are dropped when the file is rewritten. The page setup itself (A4, portrait) is kept, so the client sees no difference.

## Implementation notes

- The spreadsheet writer (`core/ddq_output.py` / `ddq_sheets`):
  - after writing a cell, copy its alignment with `wrap_text=True, vertical='top'`;
  - per written row, compute the needed height: Σ over paragraphs ⌈chars ÷ chars-per-line⌉ × line height (font size × ~1.3pt). Chars-per-line comes from the column width, or the summed widths of a merged block;
  - set `row_dimensions[r].height = max(current, needed)`, capped at 409.
- Filename: strip a trailing `BLANK` / `TEMPLATE` (any case, with its separator) before " — completed".
- Tests:
  - with a fixed 16pt row and a 400-character answer, the written cell wraps and the row grows;
  - an unwritten row keeps its height;
  - the client's fill and border survive;
  - the filename drops "BLANK".
- Independent: no migration, no API change.
