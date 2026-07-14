---
id: 01KXGXBCG6R01Z0R423HXSH046
created: 2026-07-14T18:13:42.534774978Z
updated: 2026-07-14T18:14:02.984938244Z
type: task
title: Converting non-Word documents
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 152
sprint: ssdk92z
comments:
- id: 01KXGXBQ7G1BDWG7SX5PWKR5CF
  author: Steve Vine
  at: 2026-07-14T18:13:53.520333324Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-04 07:41 UTC]
    **Answer to the question (verified experimentally before any changes):** A4 is *not* the only behaviour — it's just LibreOffice Calc's default print setup (paginate the sheet onto A4 portrait, slicing columns across pages).

    Calc's PDF export filter (`calc_pdf_Export`) accepts a `SinglePageSheets` option (LibreOffice 7.2+; the image ships 7.4) that renders **each sheet as one continuous page sized to its content** — i.e. proper spreadsheet format.

    Measured with a realistic 15-column × 30-row register in a container matching the image:

    | Mode | Pages | Page size |
    |---|---|---|
    | Default (today) | 4 | 595 × 842 pt (A4 portrait, columns split) |
    | `SinglePageSheets` | 1 | 1617 × 465 pt (sized to the sheet) |

    Trade-off to be aware of: a very large sheet becomes one very large PDF page (readers handle this fine — you zoom/scroll like in Excel — but it won't print naturally onto A4). The alternative (forcing landscape + fit-to-width print styles) would still slice big sheets across pages and requires mutating the document before export, so `SinglePageSheets` is the cleaner fix.

    Proposed change: use `SinglePageSheets` for `.xlsx` exports only (docx/pptx keep the page-based render), and bump the renderer cache version so already-cached A4 spreadsheet exports regenerate. PR to follow.
- id: 01KXGXC0F8FM9M7QABZE8TS7RM
  author: Steve Vine
  at: 2026-07-14T18:14:02.984806919Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-04 07:44 UTC]
    PR up: https://github.com/Steve-vine/compass/pull/143 — implements the SinglePageSheets answer above for `.xlsx` only, bumps the renderer cache version so existing A4 spreadsheet exports regenerate, and hardens the smoke test (wide sheet → one page wider than A4). Verified in-container as the runtime uid. Needs merge + image rebuild + helm bump to go live.
---
When converting an xlsx file to a PDF it creates it in A4 format like a Word document so it becomes unreadable as a spreadsheet.  Is this the only behaviour or is it possible to render it in the spreadsheet format?
Answer this question before making any changes.

---
*Migrated from Linear [DEV-809](https://linear.app/stevevine/issue/DEV-809/converting-non-word-documents) · created 2026-07-04 · completed 2026-07-04*