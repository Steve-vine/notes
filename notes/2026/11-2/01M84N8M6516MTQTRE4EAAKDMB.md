---
id: 01M84N8M6516MTQTRE4EAAKDMB
created: 2026-11-23T16:54:10.373099Z
updated: 2026-11-23T16:54:12.175616Z
type: task
title: A long row in an audit pack's What changed table keeps its headings and says which entry it continues
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2111
sprint: ssj8zkq
assignee: steve
label:
- bug
priority: low
task_status: active
---
Sprint "Registers - Phase 2". Found re-testing COM-2107 on staging f6abe2fd5 (23 Nov 2026). Screenshots: `~/compass-uat/sprint-122/COM-2107/long-row-p14.png`, `long-row-p15.png`.

## The problem
With a 520-word note on an entry, its What changed row starts on page 14 with no column headings, and page 15 has neither headings nor the entry's ID. The entries table handles the same note correctly since COM-2107.

## What people see
- What changed behaves like the entries table: column headings on every page, and a row that runs over a page continues marked with its entry's ID, "UOB-8 (continued)".
- Headings never split inside a word.
- What the table says is unchanged: same rows, same redaction ("another company", "A Restricted entry").

## Done when
- The 520-word note's What changed row reads clearly across pages, checked by looking at the rendered pages.
- Every page of the What changed table has its headings.
- The ordinary register exports are unchanged.

No migration or API change expected.