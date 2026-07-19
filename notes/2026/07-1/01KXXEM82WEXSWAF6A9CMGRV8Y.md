---
id: 01KXXEM82WEXSWAF6A9CMGRV8Y
created: 2026-07-19T15:06:31.900161Z
updated: 2026-07-19T17:17:39.720730631Z
type: task
title: Vendor assessment
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 189
order: 1.0
task_status: done
comments:
- id: 01KXXHM71AH6TGK7RH8E33K7QD
  author: Steve Vine
  at: 2026-07-19T15:58:56.554146755Z
  text: |-
    Implementation complete and deployed to staging — awaiting smoke test.

    **What was done**
    - Backend: `vendor_forms` + `vendor_form_items` (migration 0048 with per-company backfill of a designated "Onboarding form" from the active questions), `/api/v1/vendor-forms` CRUD + `/vendor-forms/onboarding-questions`, submission/resubmit validate against the designated form (fallback: whole active bank).
    - Frontend: 'Onboarding form' tab renamed to 'Vendor Questions'; new 'Vendor Forms' tab with form builder (ordered question picker, use-for-onboarding switch); request/resubmit modals render the onboarding-questions surface.
    - Tests: 4 new backend integration tests + submission-scoping test; frontend suite extended (196 green).

    **Decisions made on the fly**
    - The designated onboarding form can be neither deleted nor deactivated (409) — keeps the invariant "designated ⇒ active"; designate another form (flag moves atomically) or clear the flag first.
    - A question on a form cannot be hard-deleted (409, mirroring the answered-question guard); remove it from the form first.
    - Form membership PATCH is a full ordered `question_ids` replacement — simple for the builder UI.

    **Problems encountered**
    - First CI round failed: CI's ruff step lints `migrations/` but my local check only covered `src` + `tests` — E501 + a format nit in migration 0048. Fixed in 2692b01/8b8cde8.

    **State**: PR #180 open against main, CI green (10m05s). Staging deploy green (13m27s) — feature live on the staging env for smoke testing.

    **Smoke-test pointers**: Vendors → 'Vendor Questions' (renamed builder, unchanged behaviour); 'Vendor Forms' → create a form from bank questions, mark it "Use for onboarding"; Requests → 'Request vendor' should then ask only that form's questions in form order. Existing companies with questions should already show a backfilled designated "Onboarding form".
- id: 01KXXP4BG810VJ6VW0YHYTSW1H
  author: Steve Vine
  at: 2026-07-19T17:17:39.720488969Z
  text: 'Released. PR #180 squash-merged to main as dc1e692; main-push CI green (5m52s) — test suite + production build/deploy. Feature branch deleted (local + remote). Follow-up parked for a future task: "Run assessment" — complete a non-onboarding form against an existing vendor, recording the result as a VendorReview so outcomes drive compliance status.'
sprint: sp5bmib
---
Expand the assessment function by adding additional forms.  Rename the 'Onboarding form' tab of Vendors to 'Vendor Questions', and create a new tab called 'Vendor Forms'
The Vendor Questions tab works as it does today, creating a list of questions.  The Vendor Forms tab allows the user to create multiple forms made up of questions from the Vendor Questions tab.

---

## Agreed work (planned with Claude, 2026-07-19)

**Scoping decisions (Steve):**
- Builder only this task — completing forms against vendors (assessments) is a follow-up.
- Onboarding uses a **designated form**: one form per company manually marked as the onboarding form. (Future: multiple onboarding forms picked by vendor "tier" from initial questions — out of scope here.)
- No designated form → onboarding falls back to today's behaviour (all active questions).

**Checklist:**
- [x] `models/vendor_form.py` — `VendorForm` (CompanyScoped: name, description, active, is_onboarding) + `VendorFormItem` ordered membership (form_id CASCADE, question_id RESTRICT, unique (form_id, question_id), position). One onboarding form per company (partial unique index).
- [x] Migration `0048_vendor_forms` (off 0047) — tables + backfill: per company with questions, create "Onboarding form" (is_onboarding) containing the active questions in position order.
- [x] API `/api/v1/vendor-forms` — CRUD (vendor-write), ordered `question_ids` replace-set on PATCH/POST; setting is_onboarding atomically unsets the previous; DELETE 409 on the designated onboarding form; question DELETE 409 when on a form. `GET /vendor-forms/onboarding-questions` (vendor-read) → the designated form's active questions (fallback: all active).
- [x] Onboarding submission + resubmit validate against the designated form's questions.
- [x] Frontend: rename tab 'Onboarding form' → 'Vendor Questions'; new 'Vendor Forms' tab (vendor-write) — list forms, create/edit modal with name/description/active/use-for-onboarding + question picker with ordering; request/resubmit modals use onboarding-questions endpoint. Regenerate schema.d.ts.
- [x] Tests: backend vendor-forms CRUD/designation/guards/gating + onboarding-via-form; frontend VendorsPage tab rename + forms tab.
- [x] PR to main (#180), merge branch to staging (8fb8e02).
- [ ] CI green (PR + staging deploy), Steve smoke test on staging.

Additional guard decided during implementation: the designated onboarding form can be neither deleted nor deactivated (409) — designate another form or clear the designation first, so the invariant "the designated form is always active" holds.