---
id: 01M05DE2J6MQ0414FAS2CZ2MER
created: 2026-08-16T13:51:00.166979Z
updated: 2026-08-25T18:43:14.723178Z
type: task
title: 'Approval areas: guard against approvers who lack the assessor role'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 225
sprint: sbph5q5
comments:
- id: 01M05F6525SBPG5XS2D25RKVY4
  author: Steve Vine
  at: 2026-08-16T14:21:37.733753Z
  text: |-
    Shipped as PR #224 (branch feature/com-225-approver-role-guard) — awaiting CI.

    **Backend:** `ApprovalAreaOut.approver_ids` → `approvers: [{user_id, name, can_decide}]`; `AssignableUserOut` gains `can_decide`. Both resolved server-side, because the client cannot join the fact itself: roles live on the admin-only user surface (ADR 0026). One extra join in `_assemble`, batched for the whole page.

    **Frontend:** the Approvals tab names the role-less approvers under the picker ("… cannot decide — missing the Vendor Assessor role. Approvals for this area will wait until an admin grants it.") and badges them in the picker dropdown, so the mismatch shows before it is saved as well as after.

    Warn, not block, as decided. The guard reads whatever `_VENDOR_ASSESS` contains rather than a hard-coded role name, so it survives COM-226/227.

    **Tests:** backend `test_approvers_carry_the_role_fact` (payload + picker report `can_decide` per user; a vendor-manager correctly reads as unable to decide); frontend — warning names only the role-less approver, and is absent when every approver holds the role.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
---
Deciding an approval needs **both** the `vendor_assessor` role (gate: `_VENDOR_ASSESS`, `models/user.py:93`) **and** membership of the approval's area (`VendorApprover` row). Nothing warns when the two diverge: adding an area approver without the role configures a person who can never actually decide — their approvals just sit pending.

- [ ] Approval Areas admin UI: adding (or listing) an area approver who lacks `vendor_assessor` shows a clear warning badge/hint ("cannot decide — missing the Vendor Assessor role"). Warn, don't block (decided 2026-08-16): role assignment is the admin's next step, not an error.
- [ ] Backend: approver rows in the areas payload carry the role fact so the UI needn't join client-side.
- [ ] Tests: warning renders for role-less approvers, absent otherwise.

(Role sets shift in the portal-assessor task — the guard checks whatever `_VENDOR_ASSESS` then contains, not a hard-coded role name.)