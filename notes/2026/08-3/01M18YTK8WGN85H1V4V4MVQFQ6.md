---
id: 01M18YTK8WGN85H1V4V4MVQFQ6
created: 2026-08-30T09:08:21.404373Z
updated: 2026-09-01T13:55:52.288443Z
type: task
title: Editing a role's groups brings its holders in line — through the request path
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 523
sprint: sz42uhw
blocked_by:
- 01M18ZDMQ88EXY6S365XRVESPN
comments:
- id: 01M195R43NHQWYNW2MD3640ZCY
  author: Steve Vine
  at: 2026-08-30T11:09:20.373358Z
  text: |-
    Shipped — PR #532, merged to main as f73c6d0. Recorded as **ADR 0064** (amending ADR 0045 §4 and ADR 0061 §3).

    Saving a change to a role's groups now raises one membership-change request covering everyone who holds it, one subject each, through the normal approval path. The matrix saves straight away; nothing reaches Entra until it is approved — and the maker-checker rule means the editor cannot approve what their own edit implies (there is a test for that specifically).

    `core/role_propagation.py` decides what the edit implies and nothing else:
    - removals take only what *that* role gave. A group a second active role the holder has also maps survives, and so does an approved exception. The second-role check is deliberately **not** company-scoped: somebody holding roles under two companies has two reasons, and one company tidying its matrix is not a decision about the other's.
    - adds raise no write for anyone who already holds the group, whatever gave it to them.

    **One thing worth knowing beyond the task.** The catch-up's grants come through the same request path, so they land in `join_group_ids` like any hand-raised exception — which under COM-524's ledger rule would have made every holder read as an exception the day the role next dropped the group. So the catch-up's subjects **name the business role that drove them**, and the ledger rule now skips a subject that names a role. Naming the role also makes the existing open-request guard refuse to delete a role while the request its edit raised is open, which is that guard doing what it says.

    The picker holds a mapping change back until `GET /business-roles/{id}/group-change-preview` has answered — "43 people hold this role… adds HR Users to 40 people" — and **skips the confirmation entirely when the edit moves nobody**, which is the ordinary case and would otherwise be a click tax on every mapping change. A role with no holders raises nothing.

    `PATCH /business-roles/{id}` now answers `{ role, raised_request_id }` so the editor is told; `schema.d.ts` regenerated.

    Scope held to new edits only — no tenant-wide reconcile on deploy day.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Today a business role's group list is a definition that only ever applies to the *next* person it is given to. Add a group to a role and the people already holding it don't get it; remove one and they keep it. The role says one thing and its holders are another, indefinitely — until someone happens to be moved, or a recert campaign catches it months later.

Decided 2026-08-30: a role edit should bring its holders in line.

## What changes for the reader

Save a change to a role's groups and Compass raises **one access request** covering everyone who holds it — each person their own recorded outcome, the shape the People field already has. It goes through the normal approval path; nothing reaches Entra until it is approved. The role edit itself saves straight away, because the matrix is a definition and the access catch-up is a change.

So the role edit and the access change become two moments, deliberately. Editing the matrix is not itself an access grant, and a mistyped role edit does not become a mass revoke without a second person seeing it.

## What propagation must not do

Only memberships **that role** granted are removed. Untouched:

* a group a *second* active role the person holds also maps — they still have a reason for it;
* an approved exception for that group — somebody decided about that person specifically, and a role tidy-up must not silently overturn it.

This is the mover's existing rule ("take away what the old role gave, add what the new one gives, leave everything else alone"), applied to a different trigger. Getting it wrong destroys exception records the first time anyone tidies a role.

Adding a group raises no Entra write for anyone who already has it, from another role or an exception — there is nothing to do. **Their record still changes**, though: under COM-524 the group is now role-derived for them, because a role they hold maps it. Do not read "skip them" as "leave the record alone" — that is the staleness COM-524 exists to fix.

## What the record says while it is in flight

The moment the role stops mapping a group, the role no longer explains those memberships. Under COM-524's precedence they fall to whatever still stands: an approved exception if one does, otherwise **unexplained** — with the pending removal shown against them.

* Approved → removed, record deleted with the membership.
* **Cancelled or not approved → they stay as they fell**, and an unexplained one sits in the queue as something still to decide.

Explicitly *not* promoted to an exception. An exception is a deliberate approved decision with a reason; a declined removal is a decision not to act, which is not the same thing. Recording it as an exception would manufacture an approval nobody gave and would put grants in the exception register that no one granted. If the reviewer declined because those people genuinely should keep the group, the follow-up is to grant them an exception on purpose — a real record, with a real reason.

No new provenance state is needed: COM-524's rule already produces the right answer here without a special case.

## Scope

**New edits only.** Holders already drifted from edits made before this exists are left alone — they surface through recert or a mover as they do now. A one-off reconcile across the tenant was considered and rejected: it would be a large unreviewed access change on deploy day, which is the thing the request path exists to prevent.

Note this is about *access*. COM-524 does correct the stale **records** on its first pass, for everyone — that is a record correction with no Graph writes, and it is not the same thing as reconciling access.

## Before saving

The edit screen should say what it is about to do — "this adds Finance-RW to 43 people and removes Payroll-RO from 12" — before the request is raised, not after. A role held by hundreds is exactly where an editor needs the blast radius in front of them, and it is the affordance whose absence made this defect invisible.

A role with no holders raises no request at all.

## Notes

* Trigger is `update_role` (`api/v1/business_roles.py:214`) when `group_ids` actually changes; holders come from `directory_user_business_role`.
* **Depends on COM-524** for the provenance precedence (role-derived › exception › unexplained). Without it, "what does the record say afterwards" here is a set of special cases rather than a rule, in both directions.
