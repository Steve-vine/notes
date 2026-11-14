---
id: 01M7D57XZHX13RMJT0TSR4XR0X
created: 2026-11-14T13:51:38.481471Z
updated: 2026-11-14T16:52:29.763637Z
type: task
title: 'A check''s sample table keeps every column readable: a short header no longer squeezes a column of long values into a few characters a line'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1822
sprint: spsp226
comments:
- id: 01M7D6J7HGQB7VX5NEW9CZE4SN
  author: Steve Vine
  at: 2026-11-14T14:14:44.528488Z
  text: |-
    Built — PR #1818 (cea871ad), auto-merge on. Frontend only.

    What you now see, wherever the shared sample table is used (Review, Evidence tab, held captures, What it collected last, Change the fields it keeps, a no-rule check's page):
    - Each column sits between a minimum (10 characters) and a maximum (44 characters) width, sized to its longest value; a long id reads in about two lines.
    - Values wrap at spaces and punctuation first; they break inside a word only when one piece is longer than the maximum.
    - A long field name in a header wraps at dots/underscores ("initiatedBy.app." / "servicePrincipalId"); short ones (≤16 characters) stay on one line beside their menu or tick.
    - COM-1814's display name + field beneath still works; COM-1816's "name · code" keeps the code on the name's line.
    - Still scrolls sideways with the first column in view.

    Measured in headless Chromium at 1440 × 900 (real components, sample data with a PIM-style id and real Entra field names): id column 53 → 281 px, 13 → 2 lines per value; row height 263 → 77 px (58 px without 120-character list cells); ten rows 2683 → 846 px incl. header; initiatedBy.app.servicePrincipalId header 285 px on one line → 177 px on two. Screenshots ~/compass-uat/spsp226/COM-1822/ (before-review, after-review, after-review-right, after-fields).

    Choices: values now sit at the top of their cell (rows hold different numbers of lines); a column of long ids is ~280 px, so as a first column it covers more while scrolling than before; list cells cut at 120 characters take up to three lines.

    Tests: new SampleTable/SampleReview tests; full vitest 4,169 passed; eslint/tsc/prettier clean. CHK-1's own page on staging to be re-checked after deploy.
- id: 01M7DBTW0DWS0C7AFAMGJSA2E3
  author: Steve Vine
  at: 2026-11-14T15:46:50.509559Z
  text: |-
    Pre-UAT re-check on staging 55b58a1b (E2E Test Company, 1440×900): **Failed, narrowly** → small follow-up in a new task.

    Seen on CHK-1's review page: rows 77 px (were ~410), values wrap at punctuation, columns 93–350 px; initiatedBy.app.servicePrincipalId wraps onto two lines in 169 px (was ~285 px on one); still scrolls sideways with the first column in view. Same on ACC.13's Evidence tab (CHK-1/CHK-3 tables).

    Misses the letter of Done when: the ~85-character PIM ids take 3 lines even at the 350 px (44-character) maximum — they can't fit in two at that width; and with a 77 px header row and the 70 px top bar, 9 full rows plus most of the 10th fit at 900 px. Minor: inheritsPermissionsFrom@odata.context (CHK-3 roleDefinitions table) can only break at the dot, so its first piece runs under its menu chevron into the next header; allow_forking (13 characters) wraps "allow_ / forking" beside its tick in Change the fields it keeps; some headers take three lines (initiatedBy.user.homeTenantId). Screenshots ~/compass-uat/spsp226/COM-1822/COM-1822-01…05.
- id: 01M7DFK2Y3C2FA5SC33QY6QB7D
  author: Steve Vine
  at: 2026-11-14T16:52:29.76337Z
  text: 'Its Done when is now met through COM-1829 (staging 4bdc9be2): on CHK-1''s review page at 1440×900 the PIM ids read in 2 lines and 10 full rows fit on screen; long headers wrap onto two lines; the same holds on the Evidence tab and in Change the fields it keeps. See COM-1829''s re-check comment.'
assignee: steve
label:
- bug
priority: medium
task_status: review
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