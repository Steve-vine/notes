---
id: 01M18YTK8WGN85H1V4V4MVQFQ6
created: 2026-08-30T09:08:21.404373Z
updated: 2026-08-30T09:08:25.35735Z
type: task
title: Editing a role's groups brings its holders in line — through the request path
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 523
sprint: sz42uhw
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: todo
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

Likewise, adding a group skips anyone who already has it — from another role or an exception — rather than raising a no-op subject for them.

## What the record says while it is in flight

The moment the role stops mapping a group, the role no longer explains those memberships, so they read as **unexplained**, with the pending removal shown against them.

* Approved → removed, record deleted with the membership.
* **Cancelled or not approved → they stay unexplained**, and sit in the queue as something still to decide.

Explicitly *not* an exception. An exception is a deliberate approved decision with a reason; a declined removal is a decision not to act, which is not the same thing. Recording it as an exception would manufacture an approval nobody gave and would put grants in the exception register that no one granted. If the reviewer declined because those people genuinely should keep the group, the follow-up is to grant them an exception on purpose — a real record, with a real reason.

No new provenance state is needed for this: unexplained already means "held, and nothing currently justifies it", which is exactly true here.

## Scope

**New edits only.** Holders already drifted from edits made before this exists are left alone — they surface through recert or a mover as they do now. A one-off reconcile across the tenant was considered and rejected: it would be a large unreviewed access change on deploy day, which is the thing the request path exists to prevent.

## Before saving

The edit screen should say what it is about to do — "this adds Finance-RW to 43 people and removes Payroll-RO from 12" — before the request is raised, not after. A role held by hundreds is exactly where an editor needs the blast radius in front of them, and it is the affordance whose absence made this defect invisible.

A role with no holders raises no request at all.

## Notes

* Trigger is `update_role` (`api/v1/business_roles.py:214`) when `group_ids` actually changes; holders come from `directory_user_business_role`.
* Related, and worth doing with this: a membership's provenance row is written once at grant time and never recomputed, so today it keeps claiming a role granted it long after that role stopped mapping the group. The removal direction is fixed here by construction; the general staleness is not, and is its own defect.
