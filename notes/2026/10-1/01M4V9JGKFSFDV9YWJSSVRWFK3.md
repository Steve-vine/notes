---
id: 01M4V9JGKFSFDV9YWJSSVRWFK3
created: 2026-10-13T18:49:36.111322Z
updated: 2026-10-13T21:00:30.933312Z
type: task
title: The groups a person should have are worked out with the membership rules applied — on a joiner, a mover, a leaver, a role edit and an individual grant
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 948
sprint: s192kdq
blocked_by:
- 01M4V9H6K7M4H479HV0DB006NN
- 01M4V9HRMNCFJ38F3SM10MP90Y
comments:
- id: 01M4VH24QVSF9HGXM1ANC7E1AJ
  author: Steve Vine
  at: 2026-10-13T21:00:28.283042Z
  text: |-
    Merged to main (PR #943, 2026-10-13). Not on staging until all seven tasks in this batch are in review.

    What to look at, with a rule "If in group E3 then drop group F3", a role that gives F3 and another that gives E3:
    - Raise a joiner with both roles: the account is created with E3 and without F3. With the F3 role alone, they get F3.
    - Move somebody who has the F3 role into the E3 role as well: the move form shows E3 being added and F3 being removed before you raise it. Approve it and they have E3 and not F3.
    - Move them back out of the E3 role: F3 comes back.
    - Give somebody with the F3 role the E3 group by itself (Change access): F3 goes in the same request. The outcome line reads "Removed by a membership rule: …". Take E3 away again and F3 comes back.
    - Edit a role to add the E3 group: the edit screen counts F3 being removed from the holders the rule now covers, in the same request.
    - Switch the rule off and none of this happens.
    - With no rules at all, everything behaves as it did.

    Different from the task text:
    - A removal made in a recertification does not give a group back in the same step. A recertification removal has no request and no approver beyond the reviewer, and a grant should have both. The person is left out of line with the rules; the Membership rules card shows that and raises the request that puts it right (COM-949).
    - A rule cannot name a group that grants directory roles, so there is no Access Admin gate to add.
    - Nothing extra is stored about which rule gave a group. It is worked out from the rules, roles and grants as they stand, the same way the reason for any membership is.

    One thing to know: a group somebody was added to directly in the directory, outside Compass, does not set a rule off until it has been accepted. That was my call, recorded in ADR 0105.

    Technical: core/membership_rules.evaluate is the one function. The joiner, mover, individual grants, role edits, adding and removing a role's holders, the reason recorded for each membership, and what counts as governed for leavers and change detection all go through it. 10 unit cases, 11 end-to-end tests against real Postgres, and the 185 existing access tests pass unchanged. Not tried against a real directory.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Part of the POC Tweaks sprint. Needs the decision record (COM-946) and the rules card (COM-947). This is the task that makes a rule do anything: from here on, every request that changes somebody's roles, or gives or takes away a group individually, leaves them with the groups those add up to *after the rules*. People who are already out of line are brought in by the task after this one.

## What people see

Using the rule "If in group E3 then drop group F3", where the PA role gives F3 and the PA Plus role gives E3:

- **A joiner raised as PA and PA Plus** is created with E3 and without F3. Raised as PA alone, they get F3 as now.
- **A mover who gains PA Plus** gets E3 and loses F3, although they still hold PA. The summary beside the form shows both before it is raised.
- **A mover who gives up PA Plus** loses E3 and gets F3 back, because the rule no longer applies to them.
- **A PA who is given E3 individually** (a membership change for that one person, not a role) loses F3 in the same request. The request says so before it is raised and the approver sees both. *(Decided by Steve, 2026-10-13.)*
- **When that individual E3 is taken away again** they get F3 back, in the same request that removes it: a membership change, a mover that names the manual group for removal, or a removal that comes out of recertification.
- **Adds are made before removals** within one person's change, so nobody is without a licence in between.
- **Editing a role** (ADR 0064) works out what its holders should gain and lose with the rules applied. Adding the E3 group to a role takes F3 away from the holders the rule now covers, in the same request.
- **An "add group" rule gives its groups the same way**: somebody whose roles or individual grants meet the condition gets them, and loses them when the condition stops being true.
- **A group a rule gives is governed like one a role gives.** A leaver takes it away, a mover can take it away, and Validation does not report it as a change nobody asked for.
- **A group a rule withholds is not explained by the role.** Somebody who is in it anyway (added in the directory behind Compass's back) reads as unexplained, and where Compass watches that kind of group it is raised on Validation like any other unrequested change.
- **A rule never removes a group somebody was given individually.** F3 given to one person as a one-off stays, whatever else they have. A dynamic group is untouched.
- **A membership nobody has explained does not set a rule off.** Somebody added to E3 in the directory, outside Compass, keeps F3 until that E3 is accepted on Validation. Accepting it leaves them out of line with the rules, which the catch-up task (COM-949) shows and puts right through a request.
- **A rule that is switched off, or whose group has left the directory, does nothing.**
- **With no rules, nothing changes** for anybody.

## Notes (technical)

- **One function, and everything goes through it.** `core/membership_rules.py`: given a company, a set of role ids and the set of groups the person has been given individually, return the groups they should have through roles and rules, each with why (which role, or which rule on account of which role or individual grant), and separately the groups a rule withheld and which rule. Pure over what it is handed, so it can be unit-tested without a database; a thin loader beside it.
- **Semantics are COM-946's**: a condition looks at the roles' own groups plus the individually given ones, never at another rule's result; adds then drops, drop wins; "not in group" only for somebody with at least one role; a drop only withholds what a role or a rule would give.
- **"Given individually" is `membership_provenance.standing_exceptions`** (approved, unrevoked, for that person and group), not the provenance column, which is derived and can read role-derived for a group that is also a standing exception.
- **Every reader of "what should this person have" moves to it.** Today that question is answered by reading `BusinessRoleGroup` directly in about a dozen places. The ones that decide a write: `membership_provenance.role_group_map` and `_role_grants`, `business_role_holdings.plan_mover` and `preview_mover`, `access_execute._managed_group_ids`, `_grant_join_roles`, `_execute_mover` and `_execute_leaver`, `role_propagation.plan`, `plan_holder_change` and `_other_role_grants`. The ones that report: `coverage_proposals`, `tasks/recert.py`, `tasks/directory_sync.py`, `core/actions/access.py`, `api/v1/directory.py`, `api/v1/business_roles.py`. Go through all of them; one left reading the table directly is a place where Compass disagrees with itself.
- **The individual-grant paths are new triggers**, and each must evaluate before and after and carry the difference: the membership-change request (adding or removing an exception; its raise-time preview and its execution), a mover's `drop_group_ids` (ADR 0094), and the recertification removals (`_recert_v1_remove`, `_recert_instance_remove_group`, `_recert_remove_one`). A recertification removal that gives a group *back* (F3, when a reviewer removes the one-off E3) is a grant the reviewer did not ask for by name: it goes in the same change, recorded against the rule.
- **A change is a difference of two answers**, not "the groups of the roles they lost": the function for what they have now, against the function for what they will have. `plan_mover` removes by `business_role_id in lost_roles` today, which cannot express "kept the role, lost the group".
- **Provenance** (`membership_provenance._derive`, ADR 0063): role-derived becomes "in the function's answer for this person". A group a rule gives is role-derived, attributed to the role that met the condition where there is one, with the rule recorded beside it (a nullable `membership_rule_id` on `governed_memberships`, set null if the rule is deleted). A withheld group falls through to exception or unexplained as the existing order has it, so an F3 that is itself a standing exception still reads as one.
- **Managed groups** (`_managed_group_ids`, the boundary of what Compass governs) gains the groups enabled "add group" rules name.
- **Order of writes.** Check what `_execute_mover` and the membership-change path do today and make it adds first for one person.
- **Privileged groups.** A rule adding a role-assignable group needs the same Access Admin approval on the request as a role mapping it does (`_writable_group_ids`). The request must be marked as needing it when a rule is what brings the group in.
- **Tests.** Unit: the function over a table of cases (in and not-in, add and drop, drop wins, no chaining, an individual grant meeting a condition, an individually given group never dropped, disabled, vanished group, no roles). Integration, against real Postgres: the joiner, both movers above, the individual E3 given and taken away by each of the three paths, the role edit, the leaver removing a rule-given group, an unexplained E3 not setting the rule off, provenance for a given and a withheld group, and that with no rules every existing access test passes unchanged.

**Done when:** on staging, with the E3 rule saved, a new joiner raised as PA and PA Plus has E3 and not F3; moving an existing PA into PA Plus and back out swaps the two groups each way; and giving a PA the E3 group individually takes F3 away, and removing it gives F3 back.