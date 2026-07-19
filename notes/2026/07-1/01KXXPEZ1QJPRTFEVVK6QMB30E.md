---
id: 01KXXPEZ1QJPRTFEVVK6QMB30E
created: 2026-07-19T17:23:27.415896Z
updated: 2026-07-19T18:00:46.291368289Z
type: task
title: Vendor Assessments
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 190
order: 1.0
task_status: review
sprint: sp5bmib
---
This is how we will link forms/assessments with vendors.  

Assessments are created in the Vendor Forms section, this functionality is in place.  Each form represents a series of questions that must be answered or an assement that must take place.

Rename the Vendor Form section as Vendor Assessments, entries in this section will be known as 'Assessments' going forward.

On the vendor detail page, create a new section under Flags called Assessments. It should be possible to add assessments into this section for completion.

Remove the questions section from the Vendor request form.  Assessments will provide this functionality.

For now this will be a manual process, later forms will be automatically added to the Vendor detail.

---

## Agreed work (planned with Claude, 2026-07-19)

**Scoping decisions (Steve):**
- Completion stores answers + a pending→completed status only; linking outcomes to VendorReview/compliance comes later (with auto-attach).
- Remove the COM-189 'Use for onboarding' designation: the request form becomes vendor + engagement details only; no request answers. DB columns stay (no destructive migration); historical request answers remain visible.
- Adding and completing assessments are vendor-manager/admin (require_vendor_write).

**Checklist:**
- [x] `models/vendor_assessment.py` — `VendorAssessment` (CompanyScoped: vendor_id RESTRICT, form_id RESTRICT, status pending/completed, completed_at/by) + `VendorAssessmentAnswer` (assessment_id CASCADE, question_id RESTRICT, prompt_snapshot, answer, answer_json). Migration 0049.
- [x] Answer validation machinery moved to the assessments API (onboarding no longer takes answers).
- [x] API: GET/POST `/vendors/{id}/assessments` (list/add — 409 duplicate pending form, 422 retired form, 404 cross-company), GET detail with answers, POST `/{id}/complete` (validate vs form's active questions in form order, snapshot, 409 if completed), DELETE pending only (completed = governance record). Guards: form with assessments can't be deleted; question with assessment answers can't be deleted.
- [x] Onboarding cleanup: submission/resubmit drop `answers` (resubmit is body-less); `/vendor-forms/onboarding-questions`, is_onboarding and the designation guards removed (columns stay). Historical answers still shown on request detail.
- [x] Frontend: tab 'Vendor Forms' → 'Vendor Assessments'; 'Use for onboarding' switch removed; request modal drops the questions section, resubmit is a one-click action; vendor detail gains an Assessments card under Flags (add via native select, complete via question modal, answers viewer, remove pending). QuestionField extracted to a shared component. schema.d.ts regenerated.
- [x] Tests: backend assessment lifecycle/guards/gating (3 new suites of tests); onboarding + forms suites slimmed; frontend 199 green incl. detail-page add/complete/read-only.
- [x] PR to main (#181), merge branch to staging (9b15203).
- [ ] CI green (PR + staging deploy), Steve smoke test on staging.