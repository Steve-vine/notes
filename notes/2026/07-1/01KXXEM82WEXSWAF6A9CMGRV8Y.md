---
id: 01KXXEM82WEXSWAF6A9CMGRV8Y
created: 2026-07-19T15:06:31.900161Z
updated: 2026-07-19T15:27:52.439815572Z
type: task
title: Vendor assessment
number: 189
project: 01KXGC5PTGYHV30VM3E78G76S1
order: 1.0
task_status: active
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
- [ ] `models/vendor_form.py` — `VendorForm` (CompanyScoped: name, description, active, is_onboarding) + `VendorFormItem` ordered membership (form_id CASCADE, question_id RESTRICT, unique (form_id, question_id), position). One onboarding form per company (partial unique index).
- [ ] Migration `0048_vendor_forms` (off 0047) — tables + backfill: per company with questions, create "Onboarding form" (is_onboarding) containing the active questions in position order.
- [ ] API `/api/v1/vendor-forms` — CRUD (vendor-write), ordered `question_ids` replace-set on PATCH/POST; setting is_onboarding atomically unsets the previous; DELETE 409 on the designated onboarding form; question DELETE 409 when on a form. `GET /vendor-forms/onboarding-questions` (vendor-read) → the designated form's active questions (fallback: all active).
- [ ] Onboarding submission + resubmit validate against the designated form's questions.
- [ ] Frontend: rename tab 'Onboarding form' → 'Vendor Questions'; new 'Vendor Forms' tab (vendor-write) — list forms, create/edit modal with name/description/active/use-for-onboarding + question picker with ordering; request/resubmit modals use onboarding-questions endpoint. Regenerate schema.d.ts.
- [ ] Tests: backend vendor-forms CRUD/designation/guards/gating + onboarding-via-form; frontend VendorsPage tab rename + forms tab.
- [ ] PR to main, merge branch to staging.