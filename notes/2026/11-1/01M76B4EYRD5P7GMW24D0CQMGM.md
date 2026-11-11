---
id: 01M76B4EYRD5P7GMW24D0CQMGM
created: 2026-11-11T22:19:55.224901Z
updated: 2026-11-11T22:19:55.224901Z
type: task
title: Cancelling or closing an audit shows the kept scope straight away, without a reload
task_status: active
label: bug
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1741
---
Found in the pre-UAT pass of COM-1730 on staging, 2026-11-11.

**Steps:** in E2E Test Company, create an audit, then Cancel audit with a reason.

**Expected:** the Company scope card switches at once to the kept copy: "As it stood when the audit ended, <date>".

**Seen:** the header shows "Cancelled", but the scope card still says "The company's scope as it stands — kept with the audit when it closes" and still has the "Edit on Admin ▸ Companies" link. After a reload it is right. Reproduced on AUD-2 and AUD-3. Screenshot: ~/compass-uat/sprint0-2026-11-11/COM-1730/DEFECT-cancelled-audit-scope-card-not-refreshed.png

**Done when:**
- Cancelling an audit, and closing one, changes the scope card to the kept, dated copy without a reload.
- A frontend test covers it.