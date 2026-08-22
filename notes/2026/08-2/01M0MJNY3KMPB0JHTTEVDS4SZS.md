---
id: 01M0MJNY3KMPB0JHTTEVDS4SZS
created: 2026-08-22T11:11:17.107764Z
updated: 2026-08-22T12:27:38.01671Z
type: task
title: Assessment lifecycle grows Open — incremental answers, valid-until, close and expiry
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 356
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: active
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