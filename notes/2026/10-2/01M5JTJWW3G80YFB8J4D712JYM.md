---
id: 01M5JTJWW3G80YFB8J4D712JYM
created: 2026-10-22T22:09:26.403067Z
updated: 2026-10-22T22:09:26.403067Z
type: task
title: Get the completed questionnaire — the client's own spreadsheet with the answers filled in, the email reply ready to copy, or a record of an online questionnaire
priority: high
label: feature
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1261
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — API

## What people see

**Completed questionnaire** on the DDQ (once In review or later; until everything is approved it's marked DRAFT):
- **Spreadsheet:** **Download completed file**: their file, unchanged except that the response and detail cells are filled in. Held-back and unanswered questions are left blank and listed beside the button. Named `<their file> — completed <date>.xlsx`.
- **Email:** **Copy reply**: each question followed by its answer, numbered as theirs were, as plain text and as rich text for Outlook. It ends with a line about any attached evidence pack.
- **Online:** **Download record**: a spreadsheet of every question and the answer given, kept as the record of what was entered in their system (and handy for the assistant to type from).

Only approved, givable (or released) answers are included in a non-draft output.

## Notes (technical)

- openpyxl write into a copy of the original; preserve styles and data validation; refuse to write into a cell that holds a formula, and list it instead.
- Round-trip test on Steve's sample files: opening the output in Excel/LibreOffice shows their formatting intact.

**Done when:** a sample client spreadsheet comes back with answers in the right cells and its drop-downs and formatting intact.