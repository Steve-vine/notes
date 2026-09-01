---
id: 01M0MJNY3KMPB0JHTTEVDS4SZS
created: 2026-08-22T11:11:17.107764Z
updated: 2026-09-01T13:55:50.77945Z
type: task
title: Assessment lifecycle grows Open — incremental answers, valid-until, close and expiry
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 356
sprint: sbph5q5
comments:
- id: 01M0MWCBPDE7B9T80B7NHH8GFH
  author: Steve Vine
  at: 2026-08-22T14:00:49.101079Z
  text: |-
    Done — PR #357, merged to main.

    `pending → open → completed | closed`.

    **`closed` keeps its answers.** Not `pending` again, not `completed` — a half-answered questionnaire is evidence of something, and both of those lose it. `close_reason` tells `manual` from `expired`, because a decision and a non-response are different facts; `closed_by` is separate and null for an expiry, since the scan made no decision and "who" and "why" are different questions.

    **Answers arrive one at a time** (PUT per question, upserted, unique-constrained). A single all-or-nothing POST would mean either losing everything on one bad answer or holding a week of work in a browser tab. A blank value deletes the row — a cleared field is not an answer, and an empty one would inflate the progress figure. `required` is not enforced per answer; submission insists, which is what lets somebody work through a form in any order.

    **One place owns the transitions** — `core/vendor_assessment_lifecycle`. Three surfaces move these rows (this router, the portal, the expiry scan) and each having its own idea of a legal move is how they would come to disagree.

    **Percentage** is answered ÷ *active* questions, batched into one query for the list payloads. Retiring a question stops it counting both ways — if it left the denominator but stayed in the numerator, a fully-answered assessment would read above 100%. A form with nothing to answer is 100%, not a bar stuck at zero on something that cannot be advanced.

    **Expiry is `valid_until < today`**, not `<=`: "valid until the 5th" includes the 5th, so it dies at the start of the 6th. The supplier gets the day they were promised. Idempotent by construction.

    Two decisions worth recording:
    - `complete` checks the transition **before** validating answers. A finished assessment should be told it has finished, not handed complaints about answers it was never going to accept.
    - Delete is now pending-only. An open assessment has been sent to somebody who may be mid-answer; the way to stop that is to close it.

    The revoke-hook registry this task introduced was **replaced by a direct call in COM-357**, once the token model existed. A registry would have made the guarantee depend on which entrypoint imported the registrant — and the expiry scan runs in a Celery worker that imports neither router.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
The backend core under the Vendor Portal: an assessment stops being a one-shot internal form-fill and becomes something a supplier works on over days. Current statuses are `pending`/`completed` with completion validating all answers in one POST.

## Lifecycle

- [ ] `VendorAssessmentStatus` grows: `pending` (assigned, not started) → `open` (started, live on the Vendor Portal) → `completed` (fully submitted) or `closed` (manual close or expiry with whatever was answered — **closed-incomplete keeps its answers as the record**, read-only, distinct from completed).
- [ ] New columns: `valid_until` (date), `opened_at`, `closed_at`, and how it closed (manual vs expired — a column or enum reason). Open requires `pending`; the Start flow (separate task) is what performs it.
- [ ] Completed assessments stay exactly as immutable as today; `closed` joins them — no re-answer, re-assign the form for a re-run.

## Incremental answers

- [ ] Answers save one-at-a-time against an **open** assessment (upsert per question, validating with the existing `_validate_answer`), instead of only as a single complete payload. The snapshot pattern holds: prompt snapshotted when the answer row is written.
- [ ] **Percentage complete** derived: answered ÷ active form questions — exposed on the assessment payloads for the admin tab and the portal.
- [ ] Final submission (the existing complete path) requires all required questions answered; it flips `open → completed`.

## Close and expiry

- [ ] Manual close endpoint, vendor-write gated, `open` only; records who and when.
- [ ] The daily Beat scan (`tasks/reminders.py` family) closes open assessments past `valid_until` as expired. Beat crontabs are wall-clock — the day it expires, it closes.
- [ ] Closing or expiring revokes the portal access tokens tied to it (interface with the token model — the portal task defines it; this task calls a revoke hook).

- [ ] Tests: status transitions (and the illegal ones 409); incremental upsert + validation + snapshot; percentage math incl. zero-question edge; expiry scan idempotent; closed keeps answers read-only; complete still validates the full set.