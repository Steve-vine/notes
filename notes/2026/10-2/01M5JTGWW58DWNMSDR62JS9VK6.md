---
id: 01M5JTGWW58DWNMSDR62JS9VK6
created: 2026-10-22T22:08:20.869344Z
updated: 2026-10-23T08:37:15.986212Z
type: task
title: Bring an existing answer bank into the Q&A library from a spreadsheet — each row becomes a draft entry, ready for approval
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1251
sprint: s5uw2fz
blocked_by:
- 01M5JTGR4C7JKR0VA69QBAT6CZ
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 84, DDQ-1 (ADR in COM-1245). Builds on the library.

**Chain:** on the chain — API

## Why

The team almost certainly has a spreadsheet of standard answers, or last year's completed DDQs. Starting the library from them means the first DDQ already gets suggestions.

## What people see

**Q&A library ▸ Import from spreadsheet** (Manage DDQs): upload an `.xlsx` or `.csv` → pick the sheet → say which column holds the question, the short response (optional), the answer, and optionally tags and classification → a preview of the first rows → **Import**. Each row becomes a **Draft** entry owned by the importer. Blank rows and rows with no answer are skipped and counted. Rows whose question matches an existing entry are flagged rather than duplicated.

Then **Submit all for approval**.

**Done when:** a completed DDQ spreadsheet imports as drafts, duplicates are flagged, and the import is in Activity.