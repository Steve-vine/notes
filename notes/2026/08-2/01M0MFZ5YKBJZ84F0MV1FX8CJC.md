---
id: 01M0MFZ5YKBJZ84F0MV1FX8CJC
created: 2026-08-22T10:23:54.323534Z
updated: 2026-08-22T12:05:52.59057Z
type: task
title: Assessment Rules tab — approval-area machinery that assigns assessments instead of people
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 354
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: active
---
On the admin Vendors page: rename the **Approvals** tab to **Approval Rules**, and add a new **Assessment Rules** tab *before* it (between Vendor Assessments and Approval Rules). The new tab duplicates the approval-area functionality — same typed rules, same OR semantics — but a matching rule set assigns **assessments** (vendor forms), not approvers. Multiple assessments per rule set.

## Backend

- [ ] New model mirroring the approval-area triple: an **assessment rule set** (named, per-company), a link table to `vendor_forms` (many — the `vendor_approvers` shape, CASCADE both ways), and typed rules using the **same kinds** as `ApprovalRuleKind` (`always_required`, `min_criticality`, `min_sensitivity`, `min_annual_cost`; `data_types_any` stays dead). Share the kind enum and the `rule_matches` evaluation in `core/vendor_approval.py` rather than copying them — the matching logic must never drift between the two tabs; if that means hoisting `rule_matches`/`ProjectedEngagement` into a neutral module, do that.
- [ ] Evaluation function analogous to `required_area_ids()`: given a vendor/engagement (or projection), the set of assessment (form) ids the rule sets require.
- [ ] CRUD API mirroring `approval_areas.py`, gated the same (`require_vendor_write` admin-side read+write; the assessment picker lists the company's forms).
- [ ] A form referenced by a rule set cannot be deleted (RESTRICT, matching "a form with assessments cannot be deleted").

## Frontend

- [ ] Tab rename Approvals → **Approval Rules** (`VendorsPage.tsx`); new **Assessment Rules** tab before it, `canEdit`-gated like its neighbours.
- [ ] Duplicate the Approval Rules tab's UI: rule-set cards with name, the rules editor (same kind pickers/thresholds), and a multi-select of assessments from the forms list in place of the approver picker.

## Explicitly out of scope (the next piece)

What *happens* when rules match — when the required assessments get attached to a vendor and who is assigned to complete them — is the assignment design still to be specified. This task builds the rules surface and the evaluation function; nothing consumes the evaluation yet. (COM-190 already anticipated "auto-attach at onboarding comes later" — that wiring belongs to the follow-up, alongside the assignee question.)

- [ ] Tests: CRUD + gating; evaluation returns the union of matching sets' forms; rule semantics identical to the approval evaluation for the same inputs; RESTRICT on referenced forms.