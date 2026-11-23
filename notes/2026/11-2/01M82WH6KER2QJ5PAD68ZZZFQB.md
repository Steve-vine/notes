---
id: 01M82WH6KER2QJ5PAD68ZZZFQB
created: 2026-11-23T00:22:42.542768Z
updated: 2026-11-23T00:48:06.461411Z
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