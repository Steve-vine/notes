---
id: 01M05DQYNEGP6P209D3WY72W4P
created: 2026-08-16T13:56:23.854481Z
updated: 2026-08-16T14:46:53.076109Z
type: task
title: Rationalise the vendor roles (inception + ADR)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 227
sprint: sbph5q5
assignee: steve
label:
- brief
priority: medium
task_status: active
---
The sprint-32 changes have shifted where vendor leverage actually lives, and the ADR 0039 §8 role set no longer carves cleanly:

- `vendor_assessor` is becoming portal-only (COM-226) — no longer an internal-section role.
- Real "owner" powers now flow through **per-vendor ownership rows** (owner/co-owners: portal contact editing, co-owner management, main-owner transfer — COM-215/221/222), not the `vendor_owner` **role**, whose remaining value is thin: internal read + submit, which `vendor_portal` + ownership now mostly covers.
- The portal has grown from read-only into a working surface (requests, contacts, co-owners, approvals), so "internal vs portal" no longer maps to "does vs views".

**Deliverable: an inception pass + decision record** (new ADR or amendment superseding parts of 0039 §8 / 0040 / the 0026 amendment), answering:

- [ ] Which roles survive? (e.g. is `vendor_owner` still a role, or is "owner" purely a relationship + `vendor_portal` access?)
- [ ] What does each surviving role gate, per surface (internal section, portal tabs, decide, write, submit)?
- [ ] Migration path for existing role assignments (no user silently loses needed access; map old → new).
- [ ] Whether the capability sets (`_VENDOR_READ`/`_WRITE`/`_SUBMIT`/`_ASSESS`/`_PORTAL_READ`) stay role-derived or gain relationship-derived members formally (ownership helper as a first-class gate).
- [ ] Implementation task list for the follow-up sprint (this task is decision-only — no code).

Refs: ADR 0039 §8, 0040, 0026; COM-215/220/221/222/226.