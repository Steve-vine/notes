---
id: 01M0DF2TEXS5KWVE6YJVCKM60F
created: 2026-08-19T16:53:44.029982Z
updated: 2026-09-01T13:55:50.523626Z
type: task
title: '''Updated'' — a request that has been answered stops looking like a fresh one'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 294
sprint: sbph5q5
comments:
- id: 01M0E1MWP5F2JSZ204Q0SBMAAW
  author: Steve Vine
  at: 2026-08-19T22:18:10.50185Z
  text: |-
    Shipped in PR #289, merged to main as 8657a1e.

    `VendorApprovalStatus.updated` and `VendorOnboardingStatus.updated` (migration **0085**, `ALTER TYPE ... ADD VALUE` in an autocommit block). Ranked in `derive_status` below `info_requested` — an unanswered question is the one still blocking — and above `in_review`. On the approval, not the request, as the task argued. `OPEN_STATUSES` gains it in both places.

    **The part that would have quietly broken the loop:** three places treated `pending` *alone* as "awaiting this approver" — the queue's `can_decide`, the `mine_to_approve` filter, and the decide endpoint's already-decided guard. An `updated` approval that could not be decided would leave the information loop with no way back out: the approver asks, the requester answers, and nobody can act on the answer. All three now share `AWAITING_APPROVER` from `core/vendor_requests.py`, and the approval queue sorts `updated` with the undecided rather than with the record.

    **Colour:** the `updated` key already existed for the activity-log action and was blue — which is `submitted`, the one state it exists to be told apart from. Now cyan: adjacent so the two read as related, distinct so they read as different. Shared with the activity-log action.

    Tests: an answered question derives `updated` on approval and request; a fresh question from another area outranks it back to `info_requested`; an `updated` approval is still decidable and still blocks a duplicate request on the same engagement; the Open filter carries it on both the internal list and portal My Approvals; the colour is not `submitted`'s.

    Note for whoever reads this later: `vendor_assessor` is portal-only since COM-226, so tests covering an approver's queue must read `/api/v1/portal/approvals`, not the internal `/api/v1/vendor-approvals`.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
An approver asks a question, the requester answers, and the request goes back to `submitted` — indistinguishable from one nobody has touched. `derive_status` resets the `info_requested` approvals to `pending` and falls through to `submitted` (or `in_review` if some area had already approved). Neither side can see that anything happened.

- [ ] **`VendorApprovalStatus.updated`** — an approval that was `info_requested` and has since been answered becomes `updated`, not `pending`. **Do it at the approval, not the request**: status is derived from the approval set (ADR 0039 §6), and "has been answered" is a fact about one area's question. A flag on the request would be a second source of truth for something already derivable, and would not tell an approver *which* area's question was answered.
- [ ] **`VendorOnboardingStatus.updated`** and a `derive_status` clause: any `updated` → `updated`, ranked **below** `info_requested` (an unanswered question outranks an answered one) and **above** `in_review`.
- [ ] Deciding clears it — approve/reject/ask-again moves the approval off `updated` as it does off `pending`.
- [ ] **Migration**: both are Postgres enum types (`vendor_approval_status`, `vendor_onboarding_status`), so this is `ALTER TYPE ... ADD VALUE`, add-only, not a Python-side change. The ADR 0042 §5 retired-member precedent applies if either is ever regretted.
- [ ] **`OPEN_STATUSES` in two places**, and missing either hides the thing this task exists to show: `core/vendor_requests.py` (which also drives the one-open-request-per-engagement guard, so an answered request must still block a duplicate) and `OnboardingRequests.tsx` (or an updated request drops out of the default Open view).
- [ ] **`statusColors.ts` already has an `updated` key** — blue, from the activity-log action vocabulary — and blue is `submitted`. Left alone the new status inherits exactly the colour it needs to be distinguished from. Give it its own, and check the label: `statusLabel` auto-capitalises, so "Updated" comes free.
- [ ] Pills render on five surfaces: the internal Requests tab (`RequestGroupTable`), portal My requests (row + modal + per-approval), and `ReviewModal`.
- [ ] OpenAPI regenerated → `schema.d.ts`.
- [ ] Tests: an answered question derives `updated`; a second unanswered question outranks it back to `info_requested`; an updated request still blocks a duplicate open request; it appears in the Open view on both surfaces.