---
id: 01M19GB00DY722JVCMVWC1NJ0C
created: 2026-08-30T14:14:24.525385Z
updated: 2026-08-30T14:35:10.872349Z
type: task
title: A business role says who holds it, and lets you change that
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 534
sprint: sz42uhw
assignee: steve
company:
- moneypenny
label:
- feature
priority: medium
task_status: backlog
---
A business role's page shows its name, its owner and the security groups it maps. It does not say who holds it, and there is nowhere else to find out — the Access Graph will draw it, and that is the only answer.

The data has been there since COM-448: `directory_user_business_roles` records who holds what, with the request that put it there and when. Nothing has ever read it back to a reader. The one place a holder count surfaces is COM-523's confirmation when you change a role's groups ("43 people hold this role…"), and that is a passing message, not a list.

Entra's directory roles already have this — Access Control → Directory Roles → a role lists its holders with Active/Eligible badges. Business roles, which are the ones Compass itself decides, do not.

## What changes for the reader

The business role page gains a **Holders** section, matching the directory role one: everyone who holds this role, when it was assigned, and which request put them there. Clicking a person opens the account modal, as everywhere else.

A role held by nobody says so plainly rather than showing an empty box — on a matrix that is being built up, "nobody holds this yet" is the honest and common state.

## Adding and removing people, through the request path

From the same section: **Add people** and, per row, **Remove**. Both raise an ordinary access request and nothing reaches Entra until it is approved — the same rule ADR 0064 set for editing a role's groups, for the same reason. Giving somebody a role grants them every group it maps; taking it away removes them from those groups. That is a mass access change either way, and the person doing it must not be the person approving it.

**Adding** covers several people at once — one request, one approval, each person their own recorded outcome, the shape the People field already has.

**Removing** takes away only what *this role* gave. Untouched: a group a second active role the person holds also maps, and an approved exception. This is the mover's existing rule (ADR 0061 §3), and getting it wrong destroys exception records the first time anyone tidies a role's membership.

Before raising either, say what it will do — "this gives Ada 6 groups", "this removes 4 groups from Grace, and leaves 2 she has for other reasons". The blast radius belongs in front of the person, before the request, exactly as COM-523 put it in front of a role edit.

## The decision this needs

A mover already does all of the above: it carries a subject's `business_role_ids`, and execution replaces the person's whole role set for that company. So adding is a mover with this role added to what they hold, and removing is a mover with it taken away — no new request kind, no new execution path, no new gate.

The catch is that a mover carries the **whole new set**, snapshotted when the request is raised. Raised from this page and approved a week later, it would silently revert any other role change made in between — the request says "Ada's roles are exactly these", and means it.

Recommend expressing it as a **delta instead**: this role added, or this role removed, resolved against what the person holds at *execution* time. It also reads better to an approver — "Ada: Finance Manager added" rather than a set of five roles they have to diff by eye — and an approver reading a set cannot tell which part is the change.

Either way it is a decision to take before building, not during.

## Not in scope

The mover's unexplained-membership question. A mover asks whether to drop memberships nobody can explain, because a job change is the moment to ask; losing one role is not, and the person is not moving. Unexplained memberships are kept, untouched, and not offered.

## Notes

- Holders come from `directory_user_business_role` (COM-448), which already carries `request_id` and `assigned_at` — "when, and which request" needs no new column.
- **Nothing exposes a person's held business roles today.** The record is written by `business_role_holdings.set_held_roles` and read only inside that module; no endpoint returns it. Both halves of this task need that read, and so does the Mover form, whose role picker currently opens **empty** rather than prefilled with what the person holds. Worth checking whether that is a defect in its own right: a mover replaces the whole set, so submitting one today with a single role picked replaces everything else that person held.
- A separate `GET /business-roles/{id}/holders` rather than embedding in `BusinessRoleOut` — the matrix lists forty roles and must not resolve holders for each.
- The removal plan already exists: `business_role_holdings.plan_mover` and `core/role_propagation.py` (COM-523) between them know how to take away what one role gave and leave everything else.
- Company scoping is unambiguous: the holdings row is company-scoped and a business role belongs to one company, so "holders of this role" needs no further filter.

## Verifying

The list: a role with holders, a role with none, and the request link resolving. The changes: adding one person and several; removing somebody who keeps a group a second role maps; removing somebody who keeps a group an approved exception covers; the editor being refused their own approval; and — if the delta is chosen — a request raised before an unrelated role change and approved after it, leaving that other change alone.
