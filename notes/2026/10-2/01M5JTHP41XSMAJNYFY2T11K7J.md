---
id: 01M5JTHP41XSMAJNYFY2T11K7J
created: 2026-10-22T22:08:46.721297Z
updated: 2026-10-23T11:18:36.331126Z
type: task
title: Questions from a spreadsheet — say which sheet and columns hold the questions and take the answers, and Compass lists every question with its place in the client's file
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1255
sprint: s5uw2fz
blocked_by:
- 01M5JTHEASHAXPM94X1ZVWWEN3
comments:
- id: 01M5M7QVATYKKAT0FTP27YHWFC
  author: Steve Vine
  at: 2026-10-23T11:18:34.586215Z
  text: |-
    Done — merged in #1271 (15315261, migration 0630_ddq_questions).

    - A spreadsheet DDQ has **Set up questions** (Manage DDQs). Each sheet is shown as it looks in the client's file, with column letters and row numbers. Tick the sheets that hold questions; for each pick the question, short response, detail and reference columns and the first row — filled in for you where there's a header row.
    - A live preview shows what Compass reads: section headings, each question with its number, where its answer goes ("Sheet 'Security', D6 and E6") and the choices from its drop-down.
    - It reads files the way a person would: a question merged over two rows is one question with its number from either row; heading rows become sections; rows without a question are skipped; a label → value sheet (company name, DPO, phone) works with the label column as the question; formulas are never taken as questions; the client's file is never changed.
    - **Create questions** adds a **Questions** card grouped by section with reference, wording, where the answer goes and the choices. Unanswered questions can be edited, merged with the next, or removed; the order can be changed while the DDQ is open. Running the set-up again replaces only questions nobody has started.
    - The register shows each DDQ's question count.

    Tried on your two spreadsheets locally (layout only — nothing from them is in the code): 40 questions in 2 sections with every drop-down read; 34 questions in 9 sections with every two-row merged question read as one, its number right and its answer cell found.

    My calls:
    - A section is a label on each question, not a record of its own.
    - A bare reference like "A.7" with no question is skipped, not made a heading.
    - At most 2,000 questions per DDQ; the preview shows the first 30 columns.
    - Previewing needs only View DDQs.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — migration + API

## What people see

On a spreadsheet DDQ, **Set up questions:**
- Pick one or more **sheets**.
- For each sheet, say which column holds the **question**, which takes the **short response** (Yes/No, often a drop-down in their file) and which takes the **detail** (either may be absent). Optionally pick a **reference** column (their "1.2.3"), and the row where questions start.
- A preview shows the first rows as Compass reads them. Rows without a question are skipped, and rows that look like section headings ("Access control") become **sections**.
- **Create questions.** The questions appear under their sections, each showing its reference and where its answer will go ("Sheet 'Security', D14").

If the short-response cell has a drop-down in their file, its choices are shown and the answer is limited to them.

Questions can be edited, merged (one question split over two rows) or removed before work starts. Re-running the set-up replaces unanswered questions only.

The assistant can do the set-up too (the assistant task).

## Notes (technical)

- openpyxl, read-only pass for set-up; keep data validation lists per cell.
- ddq_question: ddq, section, order, reference, text, sheet, response_cell, detail_cell, allowed responses, status (unanswered / drafted / assigned / answered / approved).

**Done when:** a real two-sheet client questionnaire with Yes/No drop-downs and section headings becomes questions with the right cells; the samples Steve supplies are used as test fixtures.