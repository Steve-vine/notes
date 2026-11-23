---
id: 01M82WH6KER2QJ5PAD68ZZZFQB
created: 2026-11-23T00:22:42.542768Z
updated: 2026-11-23T00:22:45.398926Z
type: task
title: 'Register export: show the last review on the PDF cover and the Excel Register sheet'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2101
sprint: s64t54m
assignee: steve
label:
- bug
priority: medium
task_status: active
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