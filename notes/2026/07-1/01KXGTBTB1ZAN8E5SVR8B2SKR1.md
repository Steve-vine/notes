---
id: 01KXGTBTB1ZAN8E5SVR8B2SKR1
created: 2026-07-14T17:21:30.977398852Z
updated: 2026-07-14T17:21:30.977398852Z
type: task
title: Permissions issues
task_status: done
label: brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 82
---
The following permissions issues were detected during testing.
Viewer role

* If they edit details on an assessment control page or raise a gap and click save, or change the Status or Maturity on the main assessment dropdowns, receive a "something went wrong" error rather than a permissions error.
* Can change risk scores on a risk, they don't save but should maybe be unchangable.

Assessor role

* Can reach the as asessment screen, but its empty, presumably because they can see controls.
* Same issue on Gap screen, can see the title but not the control ID

Thinking about it, it would make sense for the assessor to have read access to the library section.

---
*Migrated from Linear [DEV-625](https://linear.app/stevevine/issue/DEV-625/permissions-issues) · created 2026-06-25 · completed 2026-06-25*