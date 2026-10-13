---
id: 01M4V9JGKFSFDV9YWJSSVRWFK3
created: 2026-10-13T18:49:36.111322Z
updated: 2026-10-13T18:49:36.111322Z
type: task
title: What a person's roles give is worked out with the membership rules applied — on a joiner, a mover, a leaver and a role edit
assignee: steve
task_status: todo
label: feature
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 948
---
Part of the POC Tweaks sprint. Needs the decision record (COM-946) and the rules card (COM-947). This is the task that makes a rule do anything: from here on, every request that changes somebody's roles gives them the groups their roles add up to *after the rules*. People who already hold the roles are brought in line by the task after this one.

## What people see

Using the rule "If in group E3 then drop group F3", where the PA role gives F3 and the PA Plus role gives E3:

- **A joiner raised as PA and PA Plus** is created with E3 and without F3. Raised as PA alone, they get F3 as now.
- **A mover who gains PA Plus** gets E3 and loses F3, although they still hold PA. The summary beside the form shows both before it is raised.
- **A mover who gives up PA Plus** loses E3 and gets F3 back, because the rule no longer applies to them.
- **Adds are made before removals** within one person's change, so nobody is without a licence in between.
- **Editing a role** (ADR 0064) works out what its holders should gain and lose with the rules applied. Adding the E3 group to a role takes F3 away from the holders the rule now covers, in the same request.
- **An "add group" rule gives its groups the same way**: a joiner or mover whose roles meet the condition gets them, and loses them when the condition stops being true.
- **A group a rule gives is governed like one a role gives.** A leaver takes it away, a mover can take it away, and Validation does not report it as a change nobody asked for.
- **A group a rule withholds is not explained by the role.** Somebody who is in it anyway (added in the directory behind Compass's back) reads as unexplained, and where Compass watches that kind of group it is raised on Validation like any other unrequested change.
- **A rule only shapes what roles give.** A group somebody was given individually, a manual group named on a mover, and a dynamic group are untouched.
- **A rule that is switched off, or whose group has left the directory, does nothing.**
- **With no rules, nothing changes** for anybody.

## Notes (technical)

- **One function, and everything goes through it.** `core/membership_rules.py`: given a company and a set of role ids, return the groups those roles give after the rules, each with why (which role, or which rule on account of which role), and separately the groups a rule withheld and which rule. Pure over what it is handed, so it can be unit-tested without a database; a thin loader beside it.
- **Semantics are COM-946's**: conditions look at the roles' own groups only, adds then drops, drop wins, no chaining, only for somebody with at least one role.
- **Every reader of "what do these roles give" moves to it.** Today that question is answered by reading `BusinessRoleGroup` directly in about a dozen places. The ones that decide a write: `membership_provenance.role_group_map` and `_role_grants`, `business_role_holdings.plan_mover` and `preview_mover`, `access_execute._managed_group_ids`, `_grant_join_roles`, `_execute_mover` and `_execute_leaver`, `role_propagation.plan`, `plan_holder_change` and `_other_role_grants`. The ones that report: `coverage_proposals`, `tasks/recert.py`, `tasks/directory_sync.py`, `core/actions/access.py`, `api/v1/directory.py`, `api/v1/business_roles.py`. Go through all of them; one left reading the table directly is a place where Compass disagrees with itself.
- **A mover is a difference of two answers**, not "the groups of the roles they lost": the groups after the rules for the roles they hold now, against the same for the roles they will hold. `plan_mover` removes by `business_role_id in lost_roles` today, which cannot express "kept the role, lost the group".
- **Provenance** (`membership_provenance._derive`, ADR 0063): role-derived becomes "in the answer for the roles they hold". A group a rule gives is role-derived, attributed to the role that met the condition, with the rule recorded beside it (a nullable `membership_rule_id` on `governed_memberships`, set null if the rule is deleted). A withheld group falls through to exception or unexplained as the existing order has it.
- **Managed groups** (`_managed_group_ids`, the boundary of what Compass governs) gains the groups enabled "add group" rules name.
- **Order of writes.** Check what `_execute_mover` and the membership-change path do today and make it adds first for one person.
- **Privileged groups.** A rule adding a role-assignable group needs the same Access Admin approval on the request as a role mapping it does (`_writable_group_ids`). The request must be marked as needing it when a rule is what brings the group in.
- **Tests.** Unit: the function over a table of cases (in and not-in, add and drop, drop wins, no chaining, disabled, vanished group, no roles). Integration, against real Postgres: the joiner, both movers above, the role edit, the leaver removing a rule-given group, provenance for a given and a withheld group, and that with no rules every existing access test passes unchanged.

**Done when:** on staging, with the E3 rule saved, a new joiner raised as PA and PA Plus has E3 and not F3, and moving an existing PA into PA Plus and back out swaps the two groups each way.