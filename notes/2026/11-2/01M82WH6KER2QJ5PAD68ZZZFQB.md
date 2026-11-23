---
id: 01M82WH6KER2QJ5PAD68ZZZFQB
created: 2026-11-23T00:22:42.542768Z
updated: 2026-11-23T01:21:28.104064Z
type: task
title: 'Register export: show the last review on the PDF cover and the Excel Register sheet'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2101
sprint: s64t54m
comments:
- id: 01M82XZMERQ4C6J0VY19XQBE4P
  author: Steve Vine
  at: 2026-11-23T00:48:04.056825Z
  text: |-
    Fixed and merged to main (PR #2085, 8a79f7ec1).

    What changed for people
    - A register's PDF cover and Excel Register sheet show Last review: its date and who did it.
    - An export as at a past day shows the last review on or before that day, so it never mentions a review that hadn't happened yet.
    - A register with no review by then shows no Last review line.

    Checked by automated tests so far, on the Excel export for today, a day after the review and a day before it. I'll re-test the PDF and Excel in the browser once it's on staging.
- id: 01M82ZWSH83NRPZW3Q0WGEDG1W
  author: Steve Vine
  at: 2026-11-23T01:21:28.103863Z
  text: |-
    Re-test on staging 29d0849fc: Passed.

    As E2E Admin A, exporting ZMA with Export ▸ PDF and Export ▸ Excel, and reading the files.

    - A reviewed register's PDF and Excel exports show its last review: Passed. Exported as at today, 23 Nov 2026. The PDF cover and the Excel "Register" sheet each read "Last review: 22 Nov 2026 by E2E Admin A". COM-2101/retest-export-today.pdf, retest-export-today.xlsx
    - An export as at a day before the review doesn't show that review: Passed. As at 21 Nov 2026, neither file has a Last review line, and both read "As at 21 November 2026" and 0 entries. Limit of this check: ZMA had no entries on 21 Nov, so it doesn't cover a day when a register held entries but hadn't yet been reviewed. COM-2101/retest-export-as-at-21-nov.pdf, retest-export-as-at-21-nov.xlsx

    Seen in passing, for Steve to decide: with As at set to 21 Nov, the register page's heading still says "Last reviewed 22 Nov 2026" and "9 entries", while the list below says 0. The heading describes the register today and only the list and exports follow the date. No task raised.

    Files are under ~/compass-uat/s64t54m/.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in the pre-UAT pass of sprint "Registers" on staging f73af7daf. Fix-forward for COM-2082.

## What's wrong
COM-2082 lists the last review among the register's details on the PDF cover. An ordinary Export ▸ PDF or Excel leaves it out, even for a register that has been reviewed. Only the PDF filed by Mark as reviewed shows it.

Files: `~/compass-uat/s64t54m/COM-2082/export-as-at-22-nov.pdf`, `export-as-at-22-nov.xlsx`, `export-today-status-not-met.pdf`.

## What people see
- The PDF cover and the Excel Register sheet show **Last review**: its date and who did it.
- An export as at a past date shows the last review on or before that date, so it never mentions a review that hadn't happened yet.
- A register with no review by then shows no Last review line.

## Done when
- A reviewed register's PDF and Excel exports show its last review.
- An export as at a day before the review doesn't show that review.

Independent: no migration, no API change.