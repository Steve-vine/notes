---
id: 01M84ESHDXP51FMA3BD2DT53FB
created: 2026-11-23T15:01:04.573143Z
updated: 2026-11-23T16:53:10.884469Z
type: task
title: A register's Links column in an audit pack stays readable — short links, column headings on every page, whole words
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2107
sprint: ssj8zkq
comments:
- id: 01M84JRKV6RCDTQ4NED0DERZY9
  author: Steve Vine
  at: 2026-11-23T16:10:28.582744Z
  text: |-
    Fixed and merged to main: PR #2103 (c9257d559). No migration or API change. Not on staging yet.

    What people see:
    - Each link in a pack's Links column is short: its ID and a title cut at a word within 32 characters, or 64 for a record with no ID, such as a vendor or document.
    - Column headings repeat on every page and never split inside a word.
    - A row too tall for a page continues under the headings, marked "UOB-1 (continued)".
    - A register with too many columns for A4 gets a wider page rather than broken words.
    - Hidden wording ("A Restricted entry" and the like) is unchanged, and the ordinary exports look as they did.

    For Steve to check: a 20-field register came out about 614mm wide. It reads fine on screen but shrinks a lot if printed.

    Checked by rendering real PDFs and looking at the pages: a real pack with 22 linked controls takes about half a page; 22 mixed links fit one row on one page; 88 links and a very long note keep their headings; a 20-field register has no split headings. Tests cover headings on every page, no split headings and the hidden wording. CI green.

    Not covered: the What changed table and the pack's review copies are still on the old layout, so a very long What changed row could lose its headings on that page. Row height is estimated, so an unusual row, such as one enormous unbroken word, could still run over a page.

    Not yet checked on staging: that comes with the re-test.
- id: 01M84N6DZNEWTPQ183Q076PC7B
  author: Steve Vine
  at: 2026-11-23T16:52:58.485Z
  text: |-
    Pre-UAT on staging f6abe2fd5: PASSED, except one line I couldn't check. One small defect remains in What changed.

    Account: E2E Admin A, E2E Test Company. Register UOB, 12 columns in the PDF, with UOB-1 linked to 22 records again (12 controls, 2 gaps, 2 risks, 6 register entries). SOC 2 pack for CC5.3, 1 to 23 Nov. I opened the real PDF and looked at the rendered pages.

    - The 22-link entry reads clearly: PASSED. UOB-1 is now one row on one page (page 2), with UOB-2 under it. Each link is short, e.g. "Control: AIG.14 · An AI system is verified and…".
    - Every page of the entries table has its headings: PASSED, on pages 2 and 3 of this pack. In a second pack I gave UOB-8 a 520-word note: pages 2 to 12 all have the headings.
    - A row that runs over is marked: PASSED. UOB-8 runs from page 4 to page 12, and each page after the first reads "UOB-8 (continued)". The numbered words run on from page to page with none missing.
    - No heading splits mid-word: PASSED on this 12-column register. "Regulated" and "Archived" are whole, and "Added later" wraps between its words. A much wider register (the 20-field case) wasn't tried.
    - Hidden wording is unchanged: COULDN'T CHECK. Among the test accounts only an administrator can build a pack, and an administrator can open every register, so the pack showed URS-1 by name as it should for them.

    Defect (low), already noted as not covered in the fix's comment: a very long change in What changed still has the old layout. With the 520-word note, the row starts at the top of page 14 with no column headings, and page 15 has neither headings nor the entry's ID. See long-row-p15.png.

    Files: ~/compass-uat/sprint-122/COM-2107/ (uob-register-p2.png, -p3.png, long-row-p5.png, long-row-p15.png)
assignee: steve
label:
- bug
priority: medium
task_status: review
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