---
id: 01M84N8M6516MTQTRE4EAAKDMB
created: 2026-11-23T16:54:10.373099Z
updated: 2026-11-23T17:46:30.798926Z
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