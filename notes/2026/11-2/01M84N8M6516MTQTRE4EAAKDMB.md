---
id: 01M84N8M6516MTQTRE4EAAKDMB
created: 2026-11-23T16:54:10.373099Z
updated: 2026-11-23T18:54:40.547987Z
type: task
title: A long row in an audit pack's What changed table keeps its headings and says which entry it continues
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2111
sprint: ssj8zkq
comments:
- id: 01M84R8DDT97F1HWSQQZPWKNG6
  author: Steve Vine
  at: 2026-11-23T17:46:29.178656Z
  text: |-
    Fixed and merged to main: PR #2105 (b82a53bb5). No migration or API change. Not on staging yet.

    What people see:
    - A pack's What changed table has its column headings on every page.
    - A row that runs over a page continues marked with its entry's ID, "UOB-8 (continued)". A continuation row shows only the ID and the rest of the text.
    - The wording and redaction are unchanged, and the ordinary register exports are unchanged.

    Small side effects, for Steve to check:
    - The Detail column is 3mm narrower so the Entry column fits "(continued)".
    - One very long unbroken word, such as a long web address, is now cut across rows in both What changed and the pack's entries table. Nothing is lost.

    Checked by rendering a PDF with a 520-word note through the real PDF writer and looking at the pages: the row runs over three pages, with headings on each and all 520 words in order. Tests cover the headings and the unchanged wording. CI green.

    Not checked: a full pack on staging holding a 520-word note. That comes with the re-test.
- id: 01M84W58X3WBYKDRD674XP9KM7
  author: Steve Vine
  at: 2026-11-23T18:54:40.547726Z
  text: |-
    Pre-UAT on staging d8a915977: PASSED for the pack and the PDF export. CSV and Excel exports weren't compared. No defects.

    Steps, as E2E Admin A in E2E Test Company:
    - Restored UOB, linked it to control INS.6, built a SOC 2 pack for CC5.3 covering 1 to 23 Nov 2026, then removed the link and archived UOB again. The link existed for 8 seconds (18:50:47 to 18:50:55). These steps were made through the signed-in browser session's requests rather than by clicking the buttons.
    - Opened "UOB E2E UAT 122 Obligations as at 2026-11-23.pdf" from the zip and looked at the rendered pages (15 pages; What changed is pages 12 to 15).

    Done when:
    1. The 520-word note's What changed row reads clearly across pages: Passed. It starts on page 13 with its date, UOB-8, title, "Changed" and who. Pages 14 and 15 carry "UOB-8 (continued)" and the rest of the text. All 520 numbered words are there, in order, none repeated (1-191, 192-371, 372-520).
    2. Every page of the What changed table has its headings: Passed. When, Entry, Title, What, Detail and Who are on pages 12, 13, 14 and 15, and no heading splits inside a word.
    3. The ordinary register exports are unchanged:
       - PDF: Passed. A fresh export of USH has the same pages and the same text as the export saved before this fix (COM-2106), apart from the export time.
       - CSV and Excel: Couldn't check. Not compared.

    Not exercised: the "another company" and "A Restricted entry" wording, because this register's What changed has no such row.

    Test data: one new audit pack (af7aad7b, downloaded once). UOB is archived again with no controls, its archived time is now 18:50, and its activity shows the restore, link, unlink and archive. USH's activity has one more export line.

    Evidence: ~/compass-uat/sprint-122/COM-2111/ (pages/p12.png to p15.png, uob-register.pdf, pack.zip, ordinary-export-USH.pdf)
assignee: steve
label:
- bug
priority: low
task_status: review
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