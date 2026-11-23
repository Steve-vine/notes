---
id: 01M84ESHDXP51FMA3BD2DT53FB
created: 2026-11-23T15:01:04.573143Z
updated: 2026-11-23T15:01:06.560064Z
type: task
title: A register's Links column in an audit pack stays readable — short links, column headings on every page, whole words
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2107
sprint: ssj8zkq
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Sprint "Registers - Phase 2". Found in the pre-UAT pass of COM-2093 on staging e2248892e (23 Nov 2026). Screenshots: `~/compass-uat/sprint-122/COM-2093/uob-register-p2.png`, `-p3.png`, `-p4.png`.

## The problem
With one entry linked to 22 records, each control prints its full wording, so that one row fills pages 2 and 3 and runs onto page 4. Pages 2 and 3 have no column headings, the entry's ID isn't repeated, and headings split mid-word ("Regulat/ed", "Archive/d").

## What people see
- Each link in the Links column is short: its ID and a short title, never a control's full wording.
- Column headings repeat on every page.
- Headings and short values break between words, never inside one.
- A row that runs over a page can still be told apart: its entry's ID is at the top of what continues, or the row stays together where it fits on a page.

## Done when
- The 22-link entry reads clearly in the PDF, checked by looking at the rendered pages.
- Every page of the entries table has its headings.
- No heading splits mid-word on a wide register.
- Hidden wording ("A Restricted entry" and the like) is unchanged.

No migration or API change expected.