---
id: 01M0MFHM16BZZ66WHGWCJZAE4C
created: 2026-08-22T10:16:29.990222Z
updated: 2026-09-01T13:55:50.427442Z
type: task
title: Compliance status Review Due — a compliant vendor past its review date says so
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 353
sprint: sbph5q5
comments:
- id: 01M0N2BJDJAW3P37M2ZAHD5GAP
  author: Steve Vine
  at: 2026-08-22T15:45:14.674164Z
  text: |-
    Done — PR #353, merged to main (17516b3) and deployed to staging. Verified live: `vendor_compliance_status` = `not_assessed, compliant, under_review, non_compliant, review_due`.

    **The flip lives in `core/vendor_posture.py`**, as specified — that module's contract is "the single place `compliance_status` is written", and a scheduled writer anywhere else would have broken it. `apply_review_due(vendor) -> bool` decides only whether being due is allowed to change anything; the caller decides whether the vendor *is* due.

    Only `compliant` moves. `under_review` and `non_compliant` already carry a stronger claim than "we no longer know" and downgrading them would lose it; `not_assessed` has nothing to expire.

    **One judgement call worth recording.** The daily scan filtered on `Vendor.owner_id.is_not(None)` — because a *notification* needs a recipient. A *status flip* does not. An unowned vendor's `compliant` judgement expires on exactly the same day an owned one's does, and leaving the record asserting an expired verdict because nobody happens to own it would be the same lie this task exists to stop telling. So the owner guard moved out of the `WHERE` and onto the notification upsert: one pass, two effects, each with its correct population. Pinned by an `Unowned Expired Co` fixture.

    The status changes on the day it is **due**; the reminder still fires when the lead window opens. The warning and the fact are different things.

    Recovery is free, as anticipated: `apply_review_outcome` overwrites `review_due` with the fresh judgement like any other status — asserted by a test rather than enabled by code.

    Migration 0093 is an in-place `ADD VALUE` — nothing dropped, so none of the 0091/0092 rebuild ceremony. The downgrade does cost a full rebuild and says so.

    On the task's "summary tile counts" bullet: `VendorSummaryTile` carries `by_state`, `by_criticality` and `overdue_reviews` — no compliance breakdown, so there was nothing there to add. The overdue-review count already covers the same ground and is derived at read time.

    Tests: flip + revision; idempotent second pass writes no second snapshot; unowned still flips; `under_review`/`non_compliant`/no-cadence/never-reviewed untouched; a new review clears it.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
A vendor that was judged `compliant` stays `compliant` forever, however overdue its next review — the reminders job nags the owner but the record itself keeps asserting a judgment that has expired. Add **`review_due`** to `VendorComplianceStatus`: when a compliant vendor reaches its review date, its compliance status changes to Review Due.

- [ ] Enum: add `review_due` to `vendor_compliance_status` (in-place `ADD VALUE` is enough — nothing is being dropped).
- [ ] **The flip lives in `core/vendor_posture.py`** — that module's contract is "the single place compliance_status is written", and a scheduled writer elsewhere would break it. Add a function (e.g. `apply_review_due(vendor) -> bool`) and have the daily Beat job call it from the existing vendor scan in `tasks/reminders.py`, which already computes `next_due = latest review + review_frequency_months` — same query, one more effect, a revision written when it changes.
- [ ] Rule: only `compliant → review_due`. `under_review` and `non_compliant` already carry a stronger claim; `not_assessed` has nothing to expire.
- [ ] Recovery is free: recording the review runs `apply_review_outcome`, which overwrites `review_due` with the new judgment — assert it with a test rather than adding a path.
- [ ] Decide the edge: a vendor with no `review_frequency_months` or no completed review never becomes `review_due` (nothing to be due against) — matches the reminders scan's own guards.
- [ ] Frontend: badge colour/label in `statusColors.ts`, filters on VendorsPage/PortalVendorsPage, summary tile counts.
- [ ] Tests: compliant vendor crosses next_due → review_due + revision; already-due runs are idempotent (no second revision); under_review/non_compliant untouched; new review restores the judged status.