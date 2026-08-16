---
id: 01M05DQYNEGP6P209D3WY72W4P
created: 2026-08-16T13:56:23.854481Z
updated: 2026-08-16T16:18:51.841261Z
type: task
title: Rationalise the vendor roles (inception + ADR)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 227
sprint: sbph5q5
comments:
- id: 01M05GXJK0ASJB3H9ES5VN1JZ0
  author: Steve Vine
  at: 2026-08-16T14:51:53.823802Z
  text: |-
    Decision recorded as **ADR 0043 — Vendor roles rationalised** (PR #227, `decisions/0043-vendor-roles-rationalised.md`). Decision-only, no code, as scoped.

    **Which roles survive:** two. `vendor_manager` (runs the register — the only role that writes vendors/flags/forms/questions/areas and holds the company-wide Requests queue) and `vendor_portal` (the employee surface — reads the register, raises requests, acts on vendors they own or approve for). `viewer` and `admin` unchanged. **`vendor_owner` and `vendor_assessor` retire** — the enum members stay, per the ADR 0042 §5 retired-value precedent, and appear in no capability set.

    **Ownership and approval become relationships outright.** Both were already rows; both were *additionally* gated on a role carrying no information the rows did not. `_VENDOR_ASSESS` stops being role-derived — the `vendor_approvers` row alone gates the decision, because `decide_from_body` already checks area membership on every decision and is the single enforcement point. `require_vendor_assess` is deleted rather than reimplemented as a query: a router guard asking the weaker question ("do you approve for *anything*?") would be a second place to be wrong and a query per request to be right about nothing.

    **The `is_internal`/capability answer:** section access stays role-derived (§3 has the full per-surface table and the resulting frozensets); only the decide gate goes relational. `_PORTAL_ONLY` shrinks back to one member, which is what naming the concept in COM-226 was for.

    **Migration:** grant `vendor_portal` to every `vendor_owner`/`vendor_assessor` holder, *then* delete the old grants — one transaction, grant-before-revoke so no account is ever left holding nothing. Data-only; no type change; the downgrade is a documented no-op.

    **One genuine narrowing, flagged rather than slipped in:** a `vendor_owner` loses internal register read (and internal Library read). Argued in the ADR as a relocation — All Vendors is the same register and My Vendors answers their question better — but worth your confirmation before the migration runs. An assessor loses nothing and gains submit.

    **Knock-on for COM-225:** its warning becomes unnecessary and is removed, along with the `can_decide` fields on `ApprovalAreaApproverOut`/`AssignableUserOut`. Not a reversal — the same problem solved at the root rather than reported at the surface. The ADR is explicit that the follow-up must actually take that simplification, or the change has only added.

    **Deferred, not rejected:** renaming `vendor_portal` (the name is now wrong — it is the employee surface, not a portal pass), but the fix is a migration plus a wide rename and should ride with something rather than alone.

    **Implementation task list** for the follow-up sprint is at the end of the ADR in dependency order: capability sets + guard removal → the data migration → `/auth/me is_vendor_approver` → remove COM-225's payload fields → frontend (`permissionsFor`, tab keyed off the new fact, warning replaced with copy, Awaiting-my-approval switch) → Admin → Users stops offering the retired roles → tests.
assignee: steve
label:
- brief
priority: medium
task_status: done
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