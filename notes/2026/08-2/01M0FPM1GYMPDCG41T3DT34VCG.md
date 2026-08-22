---
id: 01M0FPM1GYMPDCG41T3DT34VCG
created: 2026-08-20T13:43:57.214781Z
updated: 2026-08-22T06:55:11.643542Z
type: task
title: An owner can correct the estimated annual cost from the portal — as a proposal when it crosses a threshold
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 319
sprint: sbph5q5
blocked_by:
- 01M0FNYJRZE6WTWDEGAYGFD96B
- 01M0FQ0YRTPPDX09MGGEMWVFD4
comments:
- id: 01M0FQAJSV6757X9WK6K0T5FPW
  author: Steve Vine
  at: 2026-08-20T13:56:15.803819Z
  text: |-
    Rewritten (2026-08-20) after Steve confirmed cost **is** rule-relevant and asked for the "Annual cost at or above…" rule — now COM-320.

    That answers the open question this task was carrying, and it answers it the way that invalidates the original spec. As first written, this was a plain owner-editable field justified by nothing reading the cost. With `min_annual_cost` in play, an unconditional owner edit becomes a control bypass: set the number below a threshold and the engagement walks out from under an approver it should have required.

    Rather than drop the ask, the task now lets the owner always state the new number and lets the rules decide what that means — direct write when it needs no new approval area (every reduction, and every rise that stays under the thresholds), an `amend_engagement` request when it crosses one. `projected_engagement()` and `required_area_ids()` already do this work for amendments, so it is a call rather than a new mechanism.

    Two consequences of the change worth surfacing rather than leaving in the body:

    - **The revision row is now required, not optional.** The earlier version offered "write a revision, or record why `updated_by` is enough". A money figure that an approval rule reads and an owner can change needs a history of what it was before.
    - **Blocked by COM-320 as well as COM-318** — the threshold check cannot be written before the rule kind exists.
- id: 01M0K88NGJGTRJ39KJ8SP7CZDD
  author: Steve Vine
  at: 2026-08-21T22:50:02.130557Z
  text: |-
    Shipped — PR #335, merged to main. No migration.

    Built to the rewritten shape: the owner always states the figure, and the rules decide what stating it means. `PATCH /api/v1/portal/vendors/{id}/engagements/{id}`, owner-gated, one field. A figure needing no approval area the engagement does not already need is written; one crossing a `min_annual_cost` threshold raises an `amend_engagement` request and the stored figure does not move until it is approved.

    `required_area_ids` against the projection is the judge, as for any amendment. A small refactor came out of it: `vendor_approval.as_projected()` builds that shape from `_PROPOSABLE`, so "what if one field were different?" is a `dataclasses.replace` rather than a second copy of the field list; `projected_engagement()` is rewritten on top of it.

    **Two decisions worth your eye.**

    1. *The route can open a request without `require_vendor_submit`*, which `POST /portal/requests` does require. Deliberate, and recorded in the ADR amendment: a request changes nothing on its own (§4's own argument), and refusing to raise one would make the feature fail precisely when the money starts to matter — the owner left with a figure they may not state and no way to ask. If you would rather it refused instead, that is a one-line change and a follow-up task.

    2. *The audit is two writes, not one.* The brief asked for a revision; a revision alone records nothing about the cost, because `write_vendor_revision` snapshots **vendor** columns and `vendor_engagements` is not an audited table. So the route writes the revision (the record was touched, by whom, when) **and** an explicit ActivityLog line carrying `£12,000.00 → £8,000.00`. That is what actually closes the gap the task names — and what tells an honest correction from a bypass.

    Also: the figure is required rather than nullable. Clearing it would take a rule-relevant number down to "unknown", which matches no threshold — a reduction with the evidence removed.

    ADR 0040 amendment added: the fifth owner-gated write, named as a new *kind* (a field the rules read, written conditionally), with the tally corrected to five and a question set for any sixth addition.

    Smoke-test notes: the portal Annual Cost row shows an **Add**/**Update** button for owners only, and renders even when unpriced. Raising a figure past a configured `min_annual_cost` threshold should say "£80,000 needs Finance sign-off… gone for approval rather than being saved" with a link to the request, and the card should still show the old figure.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Follows COM-318 (the field) and COM-320 (the rule). An owner keeps their engagement's cost current from the portal — but **cost is now rule-relevant**, so a direct write is not available in the general case.

## Why this task changed shape

It was originally written as a plain owner-editable field, on the reasoning that no approval rule read the cost. COM-320 makes one that does. That reverses the argument entirely: an owner who can set the number freely can set it *below* a threshold and walk the engagement out from under an approver it should have required. That is COM-208's bug with a different column — the exact reason criticality was moved onto the engagement, where the rules could see it, instead of living on the vendor where an escalation dodged `min_criticality`.

So the field cannot be a free-text edit that writes straight through. **It also should not simply be read-only**: the ask is real, prices drift at renewal, and the owner is the only person who knows. The reconciliation is to let the owner always *state* the new number, and let the rules decide whether stating it is enough.

## The rule: an edit that cannot lower the bar

- [ ] **Evaluate the edit before writing it.** Run `required_area_ids()` against the engagement as it *would be* with the new cost — the machinery already exists and is exactly what amendments use (`projected_engagement()`), so this is a call, not a new mechanism.
- [ ] **If the new cost requires no approval area the engagement does not already have** — which covers every reduction, and every increase that stays under the thresholds — **write it directly.** That is the common case, it is the case the ask is about, and it goes through with no ceremony.
- [ ] **If the new cost would require an area the engagement has not been through** — raise an `amend_engagement` request instead of writing, and tell the owner that is what happened: *"£80,000 needs Finance sign-off — this has gone for approval rather than being saved."* Not an error. They did nothing wrong; the number simply crossed a line.
- [ ] **A reduction never retracts an approval already given.** Approvals are a record of what was judged, not a live derivation, and COM-320's own tests assert this. Dropping the cost is allowed and changes nothing that has already been decided.
- [ ] **Consider whether a reduction should be flagged rather than silent.** An engagement approved at £80,000 and quietly restated at £8,000 is a legitimate correction and also exactly what a bypass would look like. `updated_by` alone does not distinguish them — see the audit point below.

## Backend

- [ ] **A narrow portal route.** `PATCH /api/v1/portal/vendors/{vendor_id}/engagements/{engagement_id}` accepting **this field only**. The contacts routes are the shape: `require_portal_read` + `_owned_vendor(db, vendor_id, user)`, resolving through the single `vendor_ownership.is_owner` definition (main owner or co-owner, COM-222). Never reuse `VendorEngagementUpdate` — it would hand a portal user every field the rules judge.
- [ ] **Refuse on an `ended` engagement and on an offboarded vendor**, as the amendment buttons already are — a retirement record is not something to reprice.
- [ ] **Refuse while a request is already open against the engagement.** `_guard_no_open_request()` exists for exactly this. An owner moving the number under an approver mid-review is confusing at best, and with the threshold logic above it is ambiguous about which request decides.
- [ ] **The audit gap, which this change is what makes matter.** Engagement updates set `updated_by` and write **no revision row** — `write_vendor_revision` is vendor-level. A money figure that an owner can change, that an approval rule reads, with no history of what it was before, is not a defensible answer in a governance tool. Write a revision for this edit. (This is a stronger conclusion than the original version of this task drew, and COM-320 is why.)

## Frontend

- [ ] **`EngagementsCard` is one component for both surfaces** (COM-288) and already takes `portal` and `canEdit`. The internal side keeps its Edit button into the full `EngagementModal`; the portal side gets an in-place edit of this one field, gated on ownership — the spirit of the contacts card's inline compliance toggle, not a modal.
- [ ] **Ownership on the client comes from `useIsVendorOwner`** (`vendors/ownership.ts`), already used by `PortalVendorDetailPage`. The route is the enforcement; the hook only decides what renders.
- [ ] **The threshold case needs its own wording, and it is the part that will be got wrong.** The owner typed a number and got a request instead of a save. Say which area it needs and why, and link to the request, so it reads as the system working rather than as a failure.

## ADR

- [ ] **Amendment to `decisions/0040-vendor-portal.md`** (append-only), as COM-288/222/221/299 each got. It should record the fifth owner-gated write **and the shape of it** — that the portal's exceptions have until now been "a vendor's own owners maintaining their own metadata", and this is the first that touches a field the approval rules read, which is why it is conditional rather than free. The ADR's closing line asks every later addition to say which kind of thing it is; this one is a new kind, and worth naming as such.
- [ ] Update the ADR's "three owner-gated writes" tally, so the next person inherits an accurate count.

- [ ] Tests: an owner lowers the cost and it writes directly; an owner raises it within the thresholds and it writes directly; an owner raises it past a `min_annual_cost` threshold and gets an `amend_engagement` request with the right area, **and the stored cost is unchanged until it is approved**; a non-owner sees no control and is answered 403 by the route; ended engagements, offboarded vendors and open requests all refuse; a reduction leaves existing approvals standing; the edit writes a revision.
