---
id: 01M0DF2TEXS5KWVE6YJVCKM60F
created: 2026-08-19T16:53:44.029982Z
updated: 2026-08-19T16:55:23.393516Z
type: task
title: '''Updated'' — a request that has been answered stops looking like a fresh one'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 294
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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