---
id: 01M5JTGWW58DWNMSDR62JS9VK6
created: 2026-10-22T22:08:20.869344Z
updated: 2026-10-23T18:06:19.654939Z
type: task
title: Bring an existing answer bank into the Q&A library from a spreadsheet — each row becomes a draft entry, ready for approval
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1251
sprint: s5uw2fz
blocked_by:
- 01M5JTGR4C7JKR0VA69QBAT6CZ
comments:
- id: 01M5M2J0YNNHRNTWQ7Z7TCEJV0
  author: Steve Vine
  at: 2026-10-23T09:48:00.853331Z
  text: |-
    Done — merged in #1268 (af874098, no migration).

    - Q&A library ▸ **Import from spreadsheet** (beside Add an entry, Manage DDQs): an .xlsx or .csv (an .xls is refused with "Save it as .xlsx first"; 5 MB max) → pick the sheet, which columns hold the question, short response, answer, tags and classification, and the first row (guessed when there's a "Question" header) → **Preview** shows what happens to each row → **Import** adds each row as a Draft owned by you → **Submit all for approval**.
    - **Possible duplicates** — already in the library (drafts included) or repeated in the sheet — are listed with what they match and left out unless you tick "Import anyway".
    - A completed DDQ imports sensibly: the Yes/No column becomes the short response and the comments the answer; a bare Yes/No with no comment is answered "Yes"/"No".
    - A summary says what was imported, left out, skipped and left unclassified; Activity has one line for the import.

    My calls:
    - A question merged across the answer column (like your second sample) reads as "no answer" and is skipped — such a sheet usually holds questions, not answers.
    - Duplicate = the same question or another wording once numbering, case and punctuation are set aside, or a very close match.
    - Imported entries' History starts at their next step (e.g. submitted); the import itself is the one Activity line.
    - Classification is matched to a level by name; anything else leaves the entry unclassified and is counted.
    - Limits: 2,000 rows, 40 sheets.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 84, DDQ-1 (ADR in COM-1245). Builds on the library.

**Chain:** on the chain — API

## Why

The team almost certainly has a spreadsheet of standard answers, or last year's completed DDQs. Starting the library from them means the first DDQ already gets suggestions.

## What people see

**Q&A library ▸ Import from spreadsheet** (Manage DDQs): upload an `.xlsx` or `.csv` → pick the sheet → say which column holds the question, the short response (optional), the answer, and optionally tags and classification → a preview of the first rows → **Import**. Each row becomes a **Draft** entry owned by the importer. Blank rows and rows with no answer are skipped and counted. Rows whose question matches an existing entry are flagged rather than duplicated.

Then **Submit all for approval**.

**Done when:** a completed DDQ spreadsheet imports as drafts, duplicates are flagged, and the import is in Activity.