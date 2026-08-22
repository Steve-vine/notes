---
id: 01M0MBNCTRB7YWK3268TM0F6GK
created: 2026-08-22T09:08:39.384394Z
updated: 2026-08-22T10:09:57.207711Z
type: task
title: Area approver lists grant and revoke vendor_approver automatically
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 347
sprint: sbph5q5
blocked_by:
- 01M0MBMZQNB1AKDM4KDXX5264N
comments:
- id: 01M0MF5E81HH95SXPQQR28Y0H4
  author: Steve Vine
  at: 2026-08-22T10:09:50.848969Z
  text: |-
    Done — merged as #349 (a9a3f22).

    All five checkboxes: grant on add, revoke on leaving the last list, `can_decide` removed from the picker *and* from `ApprovalAreaApproverOut`, activity-log lines for both, and the tests.

    **On "only if the grant is otherwise redundant for them":** implemented as *only `vendor_approver` is ever touched*. A `vendor_admin` named as an approver gains `vendor_approver` on the way in and loses it on the way out, keeping `vendor_admin` throughout — the list confers one role and takes back one role. It never has to reason about whether a user "needs" the grant, which would be a rule that goes wrong the moment the capability sets change.

    **Activity log:** written by hand rather than by the `before_flush` listener — `user_roles` has a composite PK, which ADR 0023's listener can't record. Same reason `sso_group_role_mapping_roles` notes for its own role rows.

    **The frontend replacement for COM-225's warning** is one line of `description` copy under the picker: "Naming someone here lets them decide this area, from the portal." The orange `ApproverRoleWarning` component and the per-option "cannot decide" badge are both gone.

    **Worth flagging:** someone whose only role was `vendor_approver` ends up with *no* roles when they come off their last list. That is the honest result — the list was the whole of their access — but it means an admin removing an approver can silently leave an account that can sign in and reach nothing. I did not special-case it (any floor role would be a decision the ADR doesn't make); the activity-log line at least makes it visible. Say the word if you'd rather it left them somewhere.

    Note the approvals **queue** keeps its own `can_decide` — a different question ("may this caller decide this row"), still server-only, and now also carrying COM-346's self-approval rule.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Closes the "listed but can't decide" state (COM-225 currently *marks* it in the picker rather than preventing it): being on an area's approver list and being able to reach the decide surface become the same fact. Precedent: `recertifier` is auto-granted (ADR 0047 §6).

- [ ] `PUT /approval-areas/{id}/approvers` (`api/v1/approval_areas.py`): grant `vendor_approver` to any added user who lacks it, in the same transaction.
- [ ] On removal, revoke `vendor_approver` from a user no longer on **any** area's approver list — but only if the grant is otherwise redundant for them (a vendor_admin keeps their role either way; don't strip roles the list didn't confer).
- [ ] The picker (`list_assignable_users`) no longer needs the `can_decide` marker — remove it and the frontend warning affordance.
- [ ] Activity log lines for the grant/revoke, so role changes made as a side effect are as visible as direct ones.
- [ ] Tests: add → role appears; remove from one of two areas → role stays; remove from the last → role goes; adding an existing vendor_approver/vendor_admin is a no-op on roles.