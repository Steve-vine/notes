---
id: 01M0FNYJRZE6WTWDEGAYGFD96B
created: 2026-08-20T13:32:13.983576Z
updated: 2026-08-21T22:17:03.221046Z
type: task
title: Engagements carry an estimated annual cost — asked at request time, shown on the record
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 318
sprint: sbph5q5
comments:
- id: 01M0FPMXXMT82F0G62WVV3JYED
  author: Steve Vine
  at: 2026-08-20T13:44:26.292624Z
  text: |-
    Split out: **COM-319** makes the cost owner-editable on the portal engagement form. It stacks on this one and is blocked by it.

    It went to its own task rather than a section here because it is a governance change, not a form change — a fifth exception to ADR 0040 §3's read-only portal, needing its own amendment alongside COM-288/222/221/299. This task can ship without waiting on that call.

    One consequence lands back here: the `min_cost` rule kind noted under "deliberately not in scope" stops being a free future option if COM-319 ships as owner-editable. An owner who can edit the number could drop it below a threshold and walk the engagement out from under its approvers — COM-208's bug with a different column. So the "is cost rule-relevant?" question has to be answered before COM-319 is built, and its answer is recorded there.
- id: 01M0K6C8BX9YSBA3T1B1GFYA1Q
  author: Steve Vine
  at: 2026-08-21T22:17:02.589848Z
  text: |-
    Shipped — PR #333, merged to main (45417a3), migration 0089_engagement_annual_cost.

    **The two decisions, made out loud.**

    *Storage:* `Numeric(14, 2)`, the first money column in the codebase, on both `vendor_engagements.estimated_annual_cost` and `vendor_onboarding_requests.proposed_estimated_annual_cost`. Exact decimal because COM-320's rule compares against it and a float comparison at a threshold boundary is a bug waiting for the right number. Pydantic's `Decimal` → JSON **string** was accepted rather than coerced, so `schema.d.ts` reads `estimated_annual_cost: string | null` on responses and `number | string | null` on requests — the figure that reaches the rule is the figure that was typed.

    *Currency:* implied GBP, no column. Nothing here is multi-currency, and a currency nobody sets would be a second source of truth for the thresholds to disagree with. Retro-fitting one later is a migration, every display site and every configured approval threshold — taken knowingly.

    **The trap.** `_PROPOSABLE` and `ProjectedEngagement` both gained the field, with a test that fails if either is dropped — without them an approved amendment silently drops the new figure (COM-289's bug) and COM-320's rule judges a stale one.

    **The frontend question, answered by paying the debt.** `RequestEngagementModal` kept its own hand-rolled copy of the engagement question set; it now renders the shared `EngagementFields` like the other two forms, which is why the cost was one edit and not five. One visible consequence: its **Justification** field moved below the engagement block, where `RequestVendorModal` has always had it. Worth a look during smoke testing.

    Required on the request forms through `engagementErrors` (COM-311's mechanism — pressable button, named field), optional on the vendor-manager's own Add/Edit where a retrospective record may genuinely have no known price. A figure that will not parse is a field error, never a silent zero.

    **The inconsistent card, resolved rather than entrenched.** `EngagementsCard` showed data residency but not access requirements or sub-processors, while `ReviewModal` showed all three. Rather than add a fourth field to that set, the card now shows them all — each row only when it has a value. One money helper (`vendors/money.ts`): `£12,000`, pence only when there are pence, an absent cost as `—`. COM-320 reuses it.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
**Estimated annual cost** joins the engagement. The requester supplies it when raising a new vendor or a new engagement, and it renders on the vendor form's Engagements section — internal and portal alike.

It belongs on the engagement, not the vendor, for the reason criticality does (COM-208): one supplier can serve several purposes and each has its own price. The vendor's total is the sum of its live engagements, derivable whenever it is wanted.

**This field is rule-relevant** (decided 2026-08-20): COM-320 adds an "Annual cost at or above…" approval rule that reads it, and COM-319 makes it owner-editable on the portal only as far as those thresholds allow. That is not a later phase to design around — it is why several of the points below are not optional.

## Backend

- [ ] **Column on `vendor_engagements`**, nullable, plus a migration (head is `0087_info_loop_notifications`).
- [ ] **`proposed_estimated_annual_cost` on `vendor_onboarding_requests`**, nullable — the sparse amendment overlay. Not optional now COM-320 exists: an amendment is how a cost rise gets judged, so without this column the rule has nothing to judge.
- [ ] **The plumbing is mostly generic and will carry the field for free** — worth knowing before over-scoping this:
  - `_engagement_fields()` splats `body.engagement.model_dump()`, and `_new_engagement()` splats that into `VendorEngagement(**fields)`, so `new_vendor` and `new_engagement` land it once the schema has it.
  - The COM-297 edit path does the same `model_dump()` + `setattr` loop, so editing a queried request keeps it.
  - `_proposed_columns()` maps the amendment payload generically; only the two relation fields are special-cased.
  - What is **not** generic: `_PROPOSABLE` in `core/vendor_approval.py` and `ProjectedEngagement` both list their fields explicitly. **Add it to both.** Miss them and an approved amendment silently fails to land the new cost — the same class of bug COM-289 fixed for criticality — and COM-320's rule judges the stale number.
- [ ] **Schemas** (`api/v1/schemas.py`): `VendorOnboardingEngagementIn`, `VendorEngagementAmendmentIn`, `VendorEngagementCreate`, `VendorEngagementUpdate`, `VendorEngagementOut`. **Not** `VendorEngagementSummaryOut` — the register sub-rows deliberately carry only what a row renders (COM-212), and money is not on the row.

## Two decisions to make before writing the migration

- [ ] **How to store money.** There is no precedent — the codebase has no `Numeric` or `Decimal` column anywhere. `Numeric(14, 2)` is the correct answer and the one to take unless there is a reason not to; a float is not, and a string makes it unsummable. **COM-320's threshold column must match whatever is chosen**, or the comparison the rule performs is a decimal-versus-float trap. Note that Pydantic serialises a `Decimal` to JSON as a string, so the frontend type arrives as `string | null` — decide whether to accept that or coerce at the schema edge, because `schema.d.ts` picks up whichever you choose.
- [ ] **Currency.** Everything here is Moneypenny and GBP, and nothing in the app is multi-currency today. Recommend a single implied GBP with a `£` prefix in the UI and no currency column — but decide it out loud, because retro-fitting a currency later is a migration, every display site, **and every approval threshold already configured**.

## Frontend — write

Five forms collect an engagement, and only two use the shared `EngagementFields` component. COM-297 created that component precisely so a new field would be one edit; it did not finish the job, so this task either pays part of that back or works around it — decide which, and say which in the PR.

- [ ] `RequestVendorModal` — via `EngagementFields`. **Required**, per the ask.
- [ ] `RequestEngagementModal` — **its own hand-rolled copy** of the field set. Required.
- [ ] `EditRequestModal` — via `EngagementFields`, so a correction can fix the number.
- [ ] `AmendEngagementModal` — own copy; part of the sparse overlay, so optional there by definition.
- [ ] `EngagementModal` (vendor-manager Add/Edit, in `vendors/detail/cards.tsx`) — own copy. Optional here: a manager recording an engagement retrospectively may genuinely not know it.
- [ ] **Required means COM-311's mechanism, not a disabled button.** `engagementErrors()` in `engagementFields.ts` is where the "which field is missing" answer lives now; add it there and both shared-component forms get it. A number that will not parse is a field error, not a silent zero — and with COM-320 in play, a silent zero is a number that trips no threshold.

## Frontend — read

- [ ] **`EngagementsCard` (`vendors/detail/cards.tsx`) is one component rendered by both the internal vendor form and the portal one** (COM-288) — so "admin and portal" is a single edit, not two. Add an `EngagementRow` at the bottom of each engagement block, alongside Data Residency.
- [ ] **While you are there**: the card renders Data Residency but *not* Access Requirements or Sub-processors, though `ReviewModal` shows all three. Adding a fourth field to an already-inconsistent set is the moment to either show them all or decide out loud that the card is a summary. Do not just add a fourth.
- [ ] `ReviewModal`'s read-only engagement box — an approver judging a request should see what it costs, and with COM-320 the cost may be the very reason they were asked.
- [ ] `AmendmentDiff`'s `AMENDABLE` list, so a proposed cost change renders in the before → after. It is a scalar on both sides, so it belongs with `title`/`scope`/`criticality`.
- [ ] Format it once, in one helper — `£12,000` not `12000.00`, and an absent cost as `—` rather than `£0`. COM-320's rule summary line reuses this helper rather than writing a second one.

## Follows

- **COM-320** — the "Annual cost at or above…" approval rule kind that reads this field.
- **COM-319** — owner-editable on the portal, bounded by those thresholds.

- [ ] Tests: the field round-trips on both request kinds; an amendment proposing a new cost projects and lands it (the `_PROPOSABLE` trap); a request form will not submit without it and names the field when it is missing; a non-numeric entry is refused with a message rather than coerced; the card, the review surface and the diff all render it formatted; an engagement with no cost renders no row rather than a blank one.
