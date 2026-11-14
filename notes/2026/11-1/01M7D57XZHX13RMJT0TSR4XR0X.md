---
id: 01M7D57XZHX13RMJT0TSR4XR0X
created: 2026-11-14T13:51:38.481471Z
updated: 2026-11-14T13:51:42.065958Z
type: task
title: 'A check''s sample table keeps every column readable: a short header no longer squeezes a column of long values into a few characters a line'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1822
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: active
---
## What happened

Found in Claude's pre-UAT pass of COM-1813 on staging 53965a3b (2026-11-14), E2E Test Company, as E2E Admin A, at 1440 × 900.

On the review page for CHK-1 (Checks ▸ Review ▸ New checks ▸ CHK-1, ACC.13), the sample table's `id` column is squeezed to about 53 px because its header is short. Its long values (e.g. `PIM_3f7f72a0-…_134382049631256470`) break a few characters per line, so each row is about 410 px tall and only about two rows fit on screen. The same shared table (`collection/SampleTable.tsx`) is used inline on the control's Evidence tab, in held captures, in "What it collected last", in Change the fields it keeps and on a no-rule check's page, so it shows there too.

Also: with real field names (`initiatedBy.app.servicePrincipalId`, about 285 px as a header), ten columns need about 1749 px against the 1382 px available, so COM-1813's "10 fields fit at 1440" holds only for short names. Scrolling sideways beyond the page width is expected; unreadable columns are not.

Screenshots: ~/compass-uat/spsp226/COM-1813/COM-1813-02-sample-table.png, COM-1813-03-sample-table-head.png.

## What people see

- Every column is at least wide enough to read a value without it breaking every few characters (a sensible minimum width), and no wider than a sensible maximum. Long values wrap at word boundaries and punctuation first; only a value with no break points wraps inside the word, and only beyond the maximum width.
- A long field name in a header can wrap onto two lines (at dots and underscores) rather than forcing a very wide column. COM-1814's display name with the raw field beneath, and COM-1816's "name · code" cells, keep working.
- Rows stay a normal height for typical data, so a screen shows a useful number of rows.
- Beyond the page width the table scrolls sideways, with its first column and header still in view (as now).

## Done when

- On CHK-1's review page at 1440 px, the `id` column shows each value on one or two lines and at least ten rows fit on screen.
- A header like `initiatedBy.app.servicePrincipalId` wraps onto two lines instead of taking ~285 px.
- The same holds wherever SampleTable is used.
- A vitest covers the column sizing (min/max widths, header wrapping), and the Browser smoke still passes.

**Independent** (front end only). Fix-forward from COM-1813.