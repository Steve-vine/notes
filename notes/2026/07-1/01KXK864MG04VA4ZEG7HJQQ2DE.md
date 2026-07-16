---
id: 01KXK864MG04VA4ZEG7HJQQ2DE
created: 2026-07-15T16:01:33.840460803Z
updated: 2026-07-16T13:02:31.430028414Z
type: task
title: Vendor onboarding request submission
assignee: steve
task_status: review
label:
- brief
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 180
blocked_by:
- 01KXK85SRYTH1CMBR0RDZW7GTF
- 01KXK85YBRZF7830WVPZ9YHBSP
sprint: sxngp10
---
Phase 3 (ADR 0039 §5): submitting the onboarding form creates the vendor as `new` plus its first engagement.

- [x] `models/vendor_onboarding_request.py` (status submitted/in_review/info_requested/approved/rejected/cancelled, `requested_by` SET NULL, `submitted_at`/`decided_at`) + `vendor_form_answers` (question FK RESTRICT, **`prompt_snapshot`**, display `answer` + raw `answer_json` JSONB) + migration 0043.
- [x] `POST /vendor-onboarding-requests` [require_vendor_submit]: validates answers against active questions (unknown/retired 422, required presence, select shape + option membership), creates Vendor(`state=new`, revision 1) + first engagement(`proposed`) + request + answers atomically — nothing half-created on failure. List/detail endpoints [read]. The COM-179 delete guard is now enforceable (answered question → 409 retire).
- [x] Request form UI rendering the active questions by kind (all 7 kinds); Requests tab with list (status pill, vendor link, submitted date) + answers detail modal.
- [x] Tests: 4 backend integration (atomic create, prompt snapshotting, validation, role gating incl. owner-submits-but-cannot-edit) + 1 frontend Vitest.

Branch `feature/com-180-onboarding-requests` (stacked on COM-179), PR #171. Ref: ADR 0039 §5.