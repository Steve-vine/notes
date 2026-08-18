---
id: 01M0AQSV9TRFMYM9CR7G9GXGEG
created: 2026-08-18T15:28:23.866106Z
updated: 2026-08-18T15:28:23.866106Z
type: task
title: New group request — owner picker over all directory users
assignee: steve
priority: medium
label: improvement
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 262
---
The `group_create` raise form (COM-240) doesn't let the requester set an owner. Add one:

* **Owner field on the new-group request** — a searchable picker over **all directory users from the mirror** (name + UPN, debounced search), not just Compass app users; the group's owner is a tenant person, whoever they are. Disabled accounts excluded from the picker (an owner who can't sign in is no owner).
* Flows through the whole path: stored on the request, shown and **editable at the approval gate** (COM-260's field editor picks it up), and applied at execution — `owners@odata.bind` on the Graph create so the group is born owned, not patched after.
* Start single-owner to match the ask, but shape the request field and executor as a list of one so adding co-owners later is a UI change, not a schema change. (Entra itself allows multiple owners.)
* Whether owner becomes *required* on group creation is worth deciding while in here — COM-258 makes the business-role owner required for recert's sake, and the same argument applies to groups (ownerless groups are the ones recert campaigns can't assign) — but default to optional unless you say otherwise.
* Expedited mode gets the same field; the validator sees the owner on the validation page like any other attribute.

Refs: COM-239/240 (request + form), COM-260 (gate editing), COM-252 (owners now mirrored — display consistency with View Groups), COM-258 (the owner-required precedent).