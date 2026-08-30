---
id: 01M19GB00DY722JVCMVWC1NJ0C
created: 2026-08-30T14:14:24.525385Z
updated: 2026-08-30T16:01:33.589172Z
type: task
title: A business role says who holds it, and lets you change that
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 534
sprint: sz42uhw
comments:
- id: 01M19PF2AJFK6BRBQE8G4RT55P
  author: Steve Vine
  at: 2026-08-30T16:01:29.426622Z
  text: |-
    Done — PR #544, merged to main.

    **The decision: a delta.** A mover carries the whole new set, snapshotted when the request is raised — approved a week later it would say "Ada's roles are exactly these" and mean it, reverting anything else that changed in between. So the Holders section raises a delta instead: `add_business_role_ids` / `remove_business_role_ids` on the subject (migration 0156), resolved by `business_role_holdings.target_role_ids` against what the person holds at *execution* time. An ordinary mover still carries the whole set — a job change decides all of somebody's roles at once and means it literally; a subject carries one form or the other, never both.

    What shipped:

    - **Holders section on the business role page** — everyone who holds it, when, and which request put them there, with the person opening the account modal. `GET /business-roles/{id}/holders` is its own endpoint, not a field on BusinessRoleOut: the matrix lists forty roles on one screen and must not resolve holders for each. A role held by nobody says so plainly.
    - **Add people / Remove**, both through the request path (ADR 0064). Nothing reaches Entra until a second person approves. Adding covers several people at once — one request, one approval, each their own recorded outcome.
    - **Removal takes away only what this role gave.** A group a second active role also maps, and a group an approved exception covers, are untouched — the mover's rule (ADR 0061 §3) on a new trigger.
    - **Blast radius before the request**, per person: "Ada gains 1 group: Finance Users"; "Grace loses 2 groups… Keeps Service Desk — a second role or an approved exception still explains it". `role_propagation.plan_holder_change` is the mirror image of `plan`: there the group set moves under a fixed population, here the population moves under a fixed group set. Same helpers, same rules.
    - A change that would move nobody is refused (422) rather than parked as a request nobody can act on.
    - The request output now names the added/removed roles, so an approver reads "Finance Manager added" rather than diffing five roles by eye.

    Not in scope, as briefed: the mover's unexplained-membership question. Those are kept, untouched, and not offered.

    Verified: 13 new backend tests in test_business_roles.py + 2 end-to-end in test_access_requests.py, including the case the decision was taken for — a request raised, an unrelated role change made in the gap, and after execution the person holds **both**. 5 new frontend tests. Full backend integration suite (1468) green locally; CI green.

    **Worth a look:** Access Control → Role matrix → a role → the Holders section at the bottom. Try adding somebody and reading what it says before you raise it.
assignee: steve
company:
- moneypenny
label:
- feature
priority: medium
task_status: review
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
