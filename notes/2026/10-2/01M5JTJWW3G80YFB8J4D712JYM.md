---
id: 01M5JTJWW3G80YFB8J4D712JYM
created: 2026-10-22T22:09:26.403067Z
updated: 2026-10-23T09:59:38.475609Z
type: task
title: Get the completed questionnaire — the client's own spreadsheet with the answers filled in, the email reply ready to copy, or a record of an online questionnaire
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1261
sprint: s5uw2fz
blocked_by:
- 01M5JTJP4RN3WZKJPF2KFQH3ER
comments:
- id: 01M5KTVFW7RG08EZ35FNJGE8J0
  author: Steve Vine
  at: 2026-10-23T07:33:22.439231Z
  text: |-
    Scope change from Steve's samples (COM-1271, ADR 0124 §12):
    - **Word document:** Download completed file — their document with answers written into the response and detail cells and the matching YES/NO tick box ticked; their prompt in the notes cell is kept above the answer.
    - **Merged cells** (sample 2): where the answer cell lies inside the question's merged cells, the merge is narrowed to the question's own columns so the answer has a cell; the formula sheet is untouched.
    Tests use look-alike files of the samples' layouts, never the real files (they are client documents).
assignee: steve
label:
- feature
priority: high
task_status: active
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