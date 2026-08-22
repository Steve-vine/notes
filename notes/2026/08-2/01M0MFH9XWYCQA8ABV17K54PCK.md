---
id: 01M0MFH9XWYCQA8ABV17K54PCK
created: 2026-08-22T10:16:19.644966Z
updated: 2026-08-22T11:16:58.220855Z
type: task
title: Vendor states become Requested / Active / Dormant / Offboarded — compliance leaves the lifecycle
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 352
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
State and compliance are two axes, but `VendorState.non_compliant` mixes them — set once by an unsatisfactory review (`vendor_posture.py`, `active → non_compliant`) and never unset when compliance recovers, which is how a live vendor ended up State=Non-Compliant while Compliance said something else. And `new` misreads as "a new vendor we're using" when it actually means "born from a request, not yet approved" — approval is what sets `active` (`vendor_requests.py:649`).

New lifecycle: **`requested` → `active` ⇄ `dormant`, → `offboarded`** (terminal, admin revert stays a router-level override, not a transition).

- [ ] `VendorState`: rename `new → requested`, drop `non_compliant`. Rebuild the `vendor_state` enum (rename-in-place + rebuild for the drop, or one rebuild for both — pre-live, so no compatibility ceremony), migrating data first: `new → requested`, `non_compliant → active` (their compliance_status already carries the judgment).
- [ ] `VENDOR_STATE_TRANSITIONS` shrinks accordingly; `requested` keeps `new`'s edges ({active, offboarded}).
- [ ] `apply_review_outcome`: an unsatisfactory review now touches **only** `compliance_status` — delete the state write. The docstring's promise ("the single place a review outcome moves posture") gets simpler, not violated.
- [ ] Check every state consumer: the reminders scan already skips only dormant/offboarded, so a non-compliant-but-active vendor keeps being scanned — correct, verify with a test. Offboard flow, dormancy rules, portal grouping, `VendorSummaryTile`, `statusColors.ts`, `transitions.ts`, VendorsPage/PortalVendorsPage filters.
- [ ] ADR 0039 §2 amendment (append-only): the lifecycle is four states and compliance is not one of them.
- [ ] Tests: migration maps both old values; unsatisfactory review leaves state alone; transition matrix round-trips.