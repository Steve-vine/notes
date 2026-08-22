---
id: 01M0MFH9XWYCQA8ABV17K54PCK
created: 2026-08-22T10:16:19.644966Z
updated: 2026-08-22T12:05:22.873033Z
type: task
title: Vendor states become Requested / Active / Dormant / Offboarded — compliance leaves the lifecycle
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 352
sprint: sbph5q5
comments:
- id: 01M0MNRZSS7J2S6034J79GRCVZ
  author: Steve Vine
  at: 2026-08-22T12:05:22.872869Z
  text: |-
    Done — PR #352, merged to main.

    The lifecycle is four states: `requested → active ⇄ dormant → offboarded`.

    - `new → requested`; `non_compliant` dropped from `VendorState` (it stays a member of `VendorComplianceStatus`, where it always meant something). Existing rows map to `active` — what they were, suppliers we still buy from, their judgement already recorded in `compliance_status`.
    - `apply_review_outcome` writes `compliance_status` only. ADR 0039 §4's "one helper owns posture" promise kept, and shorter.
    - **ADR 0050** records the amendment to ADR 0039 §2 and §4.

    Migration 0092 follows the 0091 promote pattern (build under a temp name, cast both columns with a CASE that maps as it casts, drop, rename). Both `vendors.state` and `vendor_revisions.state` migrate — a revision holding a value the type no longer has would fail to load, and history that cannot be read is not history. The downgrade is lossy and says so.

    Worth noting: the reminders scan skips only dormant/offboarded, so a vendor that reviewed badly kept being chased. That was correct **by accident** before — `non_compliant` merely wasn't in the skip list. It is now correct by construction, and `test_reminders` pins it with a "Lapsed Co" fixture.
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