---
id: 01M05DE2J6MQ0414FAS2CZ2MER
created: 2026-08-16T13:51:00.166979Z
updated: 2026-08-16T13:51:17.744397Z
type: task
title: 'Approval areas: guard against approvers who lack the assessor role'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 225
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Deciding an approval needs **both** the `vendor_assessor` role (gate: `_VENDOR_ASSESS`, `models/user.py:93`) **and** membership of the approval's area (`VendorApprover` row). Nothing warns when the two diverge: adding an area approver without the role configures a person who can never actually decide — their approvals just sit pending.

- [ ] Approval Areas admin UI: adding (or listing) an area approver who lacks `vendor_assessor` shows a clear warning badge/hint ("cannot decide — missing the Vendor Assessor role"). Warn, don't block (decided 2026-08-16): role assignment is the admin's next step, not an error.
- [ ] Backend: approver rows in the areas payload carry the role fact so the UI needn't join client-side.
- [ ] Tests: warning renders for role-less approvers, absent otherwise.

(Role sets shift in the portal-assessor task — the guard checks whatever `_VENDOR_ASSESS` then contains, not a hard-coded role name.)