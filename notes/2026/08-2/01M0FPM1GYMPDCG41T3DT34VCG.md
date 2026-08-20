---
id: 01M0FPM1GYMPDCG41T3DT34VCG
created: 2026-08-20T13:43:57.214781Z
updated: 2026-08-20T13:43:57.214781Z
type: task
title: An owner can correct the estimated annual cost from the portal — the fifth exception to read-only
label: feature
task_status: todo
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 319
---
Follows COM-318, which adds the field. This makes it **editable on the portal by the vendor's owners**, in place, without raising an amendment request.

## This is a governance decision before it is a form

ADR 0040 §3 says the portal renders the vendor record read-only. It has four recorded exceptions, each its own amendment: engagement proposals (COM-288), ownership (COM-222), contacts (COM-221), and the owner-gated transcript (COM-299). The ADR closes by saying so out loud:

> *a portal user's view of a vendor is no longer "the internal record minus the buttons". It is the record minus the buttons, minus the correspondence, plus the three owner-gated writes. **Anything added to the vendor page from here on has to answer which of those it is.***

So this needs an **amendment to `decisions/0040-vendor-portal.md`** (append-only — supersede, never rewrite), and the amendment has to answer that question. This is the answer to write up:

**Cost is not what the approval workflow judges — today.** `ApprovalRuleKind` has three active kinds: `always_required`, `min_criticality`, `min_sensitivity`. None reads cost, so editing it directly bypasses no control. That is what separates it from title, scope, criticality and data types, all of which must keep going through `amend_engagement` precisely because the rules read them — COM-208 moved criticality onto the engagement *because* editing it on the vendor dodged `min_criticality`.

**And the standing exceptions are the precedent, not an outlier.** COM-221/222 handed owners the upkeep of their own supplier's metadata. A price that has drifted at renewal is the same kind of fact: the owner is the only person who knows it, and routing a number nobody approves through a full approval fan-out teaches people not to keep it current.

- [ ] **The question that decides this, and it must be settled in the amendment rather than left implicit: will cost ever gate an approval?** COM-318 flags `min_cost` as the obvious next rule kind — spend is exactly the sort of thing that ought to pull in an approver. **If that is ever wanted, this task is the thing that breaks it**: an owner could edit the number below a threshold and walk the engagement out from under its approvers, which is COM-208's bug with a different column. Two honest ways out, pick one and record it:
  - **Cost is informational.** Owner-editable, no rule ever reads it, and a future spend threshold is enforced somewhere other than the approval rules. Simplest, and what the ask implies.
  - **Cost is rule-relevant.** Then it goes through `amend_engagement` like every other judged field, and this task becomes "show it on the portal, editable by nobody" — which is COM-318 alone.

## If it goes ahead — backend

- [ ] **A narrow portal route, not a general engagement PATCH.** `PATCH /api/v1/portal/vendors/{vendor_id}/engagements/{engagement_id}` accepting **this field only**. The contacts routes are the shape to copy: `require_portal_read` + `_owned_vendor(db, vendor_id, user)`, which resolves ownership through the single `vendor_ownership.is_owner` definition (main owner or co-owner, COM-222). A route that accepted `VendorEngagementUpdate` would hand a portal user every judged field on the engagement — do not reuse that schema.
- [ ] **Refuse it on an `ended` engagement**, and on an offboarded vendor, for the reason the amendment buttons are already hidden in those states — a retirement record is not something to reprice.
- [ ] **Decide what happens while a request is open against the engagement.** `_guard_no_open_request()` exists for amendments. An owner editing the cost under an approver who is mid-review is at best confusing; simplest defensible answer is to refuse while a request is open, and say why.
- [ ] **The audit gap is real and this is the change that makes it matter.** Engagement updates set `updated_by` and write **no revision row** — `write_vendor_revision` is vendor-level. A money figure an owner can change with no history is a poor governance answer for a governance tool. Either write a revision for this edit or record in the amendment why "who last touched it" is enough. Do not leave it undecided.

## Frontend

- [ ] **`EngagementsCard` is one component for both surfaces** (COM-288), and it already takes `portal` and `canEdit`. The internal side has an Edit button opening the full `EngagementModal`; the portal side must **not** get that — it gets an in-place edit of this one field, gated on ownership, in the same spirit as the contacts card's inline compliance toggle.
- [ ] **Ownership on the client comes from `useIsVendorOwner`** (`vendors/ownership.ts`), already used by `PortalVendorDetailPage`. The route is the enforcement; the hook decides what to render.
- [ ] Save on blur or an explicit tick — not a modal. It is one number.
- [ ] Tests: an owner changes it from the portal and the value lands; a non-owner sees no control **and** is answered 403 by the route directly; an ended engagement and an offboarded vendor both refuse; the internal Edit path is unchanged; whatever is decided about an open request is asserted.

**Related:** if this ships, ADR 0040's tally becomes *four* owner-gated writes, and the sentence quoted above needs updating in the amendment so the next person inherits an accurate count rather than a stale one.
