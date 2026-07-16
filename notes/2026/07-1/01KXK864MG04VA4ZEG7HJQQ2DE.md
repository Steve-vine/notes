---
id: 01KXK864MG04VA4ZEG7HJQQ2DE
created: 2026-07-15T16:01:33.840460803Z
updated: 2026-07-16T12:36:01.993913287Z
type: task
title: Vendor onboarding request submission
assignee: steve
task_status: backlog
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

- [ ] `models/vendor_onboarding_request.py` (status submitted/in_review/info_requested/approved/rejected/cancelled, `requested_by` SET NULL, `submitted_at`/`decided_at`) + `vendor_form_answers` (question FK RESTRICT, **`prompt_snapshot`**, `answer`, `answer_json`) + migration.
- [ ] `POST /vendor-onboarding-requests` [require_vendor_submit — vendor-owner's entry point]: validates answers against active questions, creates Vendor(`state=new`) + first engagement + request atomically. List/detail endpoints [read].
- [ ] Request form UI rendering the active questions by kind; requests list + detail view.
- [ ] Tests: atomic create, prompt snapshotting, required-question validation, role gating (vendor-owner can submit, not edit vendors).

Ref: ADR 0039 §5.