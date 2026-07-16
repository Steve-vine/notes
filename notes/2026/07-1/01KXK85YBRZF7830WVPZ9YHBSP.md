---
id: 01KXK85YBRZF7830WVPZ9YHBSP
created: 2026-07-15T16:01:27.416056471Z
updated: 2026-07-16T12:51:57.053079377Z
type: task
title: Configurable onboarding form questions + builder UI
label:
- brief
priority: medium
assignee: steve
task_status: review
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 179
blocked_by:
- 01KXK8323S7Y8BV1RN3HN4Q2X1
sprint: sxngp10
comments:
- id: 01KXNFQNFXEQ1QKR8WZAFWNGP9
  author: Steve Vine
  at: 2026-07-16T12:51:57.052967325Z
  text: |-
    Build complete on feature/com-179-form-questions (stacked on COM-178); PR #170 open against main, branch merged to staging.

    Decisions: reorder is position-swap via PATCH (up/down buttons — no drag library); DELETE hard-deletes while unanswered with the 409-retire guard already shaped for the answers table (COM-180); the builder lives on a new "Onboarding form" tab of the Vendors page, visible to vendor writers only.

    Local verification: ruff + format, mypy src, 84 unit + 7 integration, 184 Vitest, build, Semgrep clean.
---
Phase 3 (ADR 0039 §5): the in-app-configurable question set for vendor onboarding requests.

- [x] `models/vendor_form_question.py` (CompanyScoped): `prompt`, `help_text`, `kind` (text/long_text/boolean/select/multi_select/number/date), `options` JSONB, `required`, `position`, `active` + migration 0042.
- [x] CRUD + reorder API [require_vendor_write]: POST appends to the form end; PATCH position = reorder; select kinds validate ≥2 options / other kinds reject options (incl. kind-change revalidation); retire via active=false; DELETE hard-deletes only unanswered questions (guard shaped for vendor_form_answers next brief).
- [x] Question-builder UI on a new "Onboarding form" tab of the Vendors page (canWriteVendors only): ordered list with kind/required/retired badges, up/down reorder, add/edit modal with per-kind options editor, delete.
- [x] Tests: 4 backend integration + 2 frontend Vitest.

Branch `feature/com-179-form-questions` (stacked on COM-178), PR #170. Ref: ADR 0039 §5, ADR 0018.