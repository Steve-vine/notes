---
id: 01M5JTHP41XSMAJNYFY2T11K7J
created: 2026-10-22T22:08:46.721297Z
updated: 2026-10-22T22:08:46.721297Z
type: task
title: Questions from a spreadsheet — say which sheet and columns hold the questions and take the answers, and Compass lists every question with its place in the client's file
task_status: todo
assignee: steve
label: feature
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1255
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