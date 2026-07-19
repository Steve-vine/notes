---
id: 01KXXPEZ1QJPRTFEVVK6QMB30E
created: 2026-07-19T17:23:27.415896Z
updated: 2026-07-19T17:29:19.725037675Z
type: task
title: Vendor Assessments
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 190
order: 1.0
task_status: active
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
- [ ] `models/vendor_assessment.py` — `VendorAssessment` (CompanyScoped: vendor_id RESTRICT, form_id RESTRICT, status pending/completed, completed_at/by) + `VendorAssessmentAnswer` (assessment_id CASCADE, question_id RESTRICT, prompt_snapshot, answer, answer_json). Migration 0049.
- [ ] Shared answer validation extracted (core/vendor_answers.py) and reused by assessment completion (onboarding no longer takes answers).
- [ ] API: GET/POST `/vendors/{id}/assessments` (list/add — 409 duplicate pending form), GET detail with answers, POST `/{id}/complete` (validate vs form's active questions, snapshot, 409 if completed), DELETE pending only. Guards: form with assessments can't be deleted; question with assessment answers can't be deleted.
- [ ] Onboarding cleanup: submission/resubmit drop `answers`; remove `/vendor-forms/onboarding-questions`, is_onboarding from API schemas + designation logic/guards (columns stay). Historical answers still shown on request detail.
- [ ] Frontend: tab 'Vendor Forms' → 'Vendor Assessments' (copy: assessments); remove 'Use for onboarding' switch; request modal drops the questions section; vendor detail gains an Assessments section under Flags (add from active assessments, complete via question modal, status pills, delete pending).
- [ ] Tests: backend assessment lifecycle/guards/gating; onboarding suite updated; frontend detail-page assessments + updated VendorsPage/OnboardingRequests tests.
- [ ] PR to main, merge branch to staging, CI green.