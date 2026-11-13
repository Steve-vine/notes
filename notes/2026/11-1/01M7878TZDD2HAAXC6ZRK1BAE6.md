---
id: 01M7878TZDD2HAAXC6ZRK1BAE6
created: 2026-11-12T15:50:53.165831Z
updated: 2026-11-13T01:59:48.786549Z
type: task
title: A row of fields with no hints has no extra gap between each label and its box
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1764
sprint: spsp226
comments:
- id: 01M78Y6FS1KQ8F5JH2PB3PSJ9R
  author: Steve Vine
  at: 2026-11-12T22:31:33.409268Z
  text: |-
    Built — PR #1771 (auto-merge set; frontend only).

    On the technology asset form, the Hosting row and the Make / Model / Serial number row now look like plain rows: label on its box (gap 14px → 0; row 77px → 56px tall). Rows with hints still line up. On the privacy-request deadline-rule form, rows without a hint lost a 34px gap and every row's boxes still share one top. Light and dark, 1440 and 390px.

    Cause and choice: the row's own spacing (meant to separate one line of fields from the next) was also opening up inside each field; the fix is a small change to the shared row component. Side effect: space between lines of fields in one of these rows, and between stacked fields on a phone, is now 14px rather than 21px.

    Checks: screen-conventions, FieldRow (new test), RecertPage, InventoryPage tests; tsc, eslint, prettier clean. Screenshots ~/compass-uat/spsp226/COM-1764/.
- id: 01M79A3T9JK4NEFGG12ABZ01SF
  author: Steve Vine
  at: 2026-11-13T01:59:48.786247Z
  text: |-
    Pre-UAT on staging (6e988b9d), E2E Test Company: **Passed**.
    New technology asset (Form = Physical so Make shows; cancelled), 1440 and 390, light and dark: Hosting / Form / Hosting detail and Make / Model / Serial number rows have a 0px label-to-box gap. Rows with hints still line up (RTO/RPO both at y=1070; End of support / Review interval both at 1428; SAP Add entry's Start date beside End date with its hint). Privacy-request deadline-rule form (cancelled): Answer within / Counted in share one top. Screenshots ~/compass-uat/spsp226/COM-1764/.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Found by the COM-1757 builder (sprint 116 round 3, 2026-11-12).

**What happens:** a row of fields laid out to stack on a phone (FieldRow with `cols`, COM-1623) shows an extra gap between each field's label and its input when no field in the row has a description (hint). Visible on the technology asset form's Hosting row (Hosting | Form | Hosting detail) and the Make / Model / Serial number row.

**What it should do:** a row where no field has a hint looks like any plain row: label directly above its box. A row where some field has a hint still lines up, as today.

**Done when:** the Hosting and Make rows on the technology asset form show no extra gap; rows with hints still line up; light and dark, desktop and phone width checked; the screen-conventions test still passes. Frontend only, independent (shared FieldRow CSS).