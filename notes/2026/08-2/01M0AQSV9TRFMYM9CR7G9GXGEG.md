---
id: 01M0AQSV9TRFMYM9CR7G9GXGEG
created: 2026-08-18T15:28:23.866106Z
updated: 2026-08-25T18:42:58.855998Z
type: task
title: New group request — owner picker over all directory users
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 262
order: 2.625
sprint: s5gwx0s
comments:
- id: 01M0BQCVAB5HNKX7DFHQ4GS48T
  author: Steve Vine
  at: 2026-08-19T00:40:32.331298Z
  text: |-
    Built and merged to main (PR #266, CI green; migration 0076).

    The group_create raise form has a searchable owner picker over all mirrored directory users (name + UPN), with disabled accounts excluded client-side and refused server-side ("an owner who can't sign in is no owner"). The owner rides the request as group_owner_ids — shaped as a list of one exactly as the task asked, so co-owners later are a UI change, not a schema change — is editable at the approval gate via the COM-260 shared field editor (expedited validators see it like any other attribute), and lands on the Graph create via owners@odata.bind: the group is born owned, not patched after, with the ownership mirrored into directory_group_owners immediately.

    The required-or-optional question: left optional per the task's default. The COM-258 recert argument was weighed, but group recert schedules resolve owners at campaign open with an explicit unassigned-warning path (COM-264), so an ownerless group degrades visibly rather than silently — the pressure to require it is lower than for roles.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
---
The `group_create` raise form (COM-240) doesn't let the requester set an owner. Add one:

* **Owner field on the new-group request** — a searchable picker over **all directory users from the mirror** (name + UPN, debounced search), not just Compass app users; the group's owner is a tenant person, whoever they are. Disabled accounts excluded from the picker (an owner who can't sign in is no owner).
* Flows through the whole path: stored on the request, shown and **editable at the approval gate** (COM-260's field editor picks it up), and applied at execution — `owners@odata.bind` on the Graph create so the group is born owned, not patched after.
* Start single-owner to match the ask, but shape the request field and executor as a list of one so adding co-owners later is a UI change, not a schema change. (Entra itself allows multiple owners.)
* Whether owner becomes *required* on group creation is worth deciding while in here — COM-258 makes the business-role owner required for recert's sake, and the same argument applies to groups (ownerless groups are the ones recert campaigns can't assign) — but default to optional unless you say otherwise.
* Expedited mode gets the same field; the validator sees the owner on the validation page like any other attribute.

Refs: COM-239/240 (request + form), COM-260 (gate editing), COM-252 (owners now mirrored — display consistency with View Groups), COM-258 (the owner-required precedent).