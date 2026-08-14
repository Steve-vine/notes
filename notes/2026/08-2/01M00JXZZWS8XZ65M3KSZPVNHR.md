---
id: 01M00JXZZWS8XZ65M3KSZPVNHR
created: 2026-08-14T16:50:52.540692Z
updated: 2026-08-14T16:50:58.641567Z
type: task
title: Frontend — Data Rubric admin tab and data-type pick-lists
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 207
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Frontend half of the Data Rubric (ADR 0042).

**New Admin tab: "Data Rubric"** (`pages/AdminPage.tsx`, new `admin/DataRubricSection.tsx`) — two stacked sections, modelled on `admin/MaturityRubricSection.tsx`:
* **Sensitivity** (top) — the four fixed levels in rank order, each with an editable name and definition, saved per row, with the revision history modal the maturity rubric already has. No add, no delete: the scale is fixed.
* **Data types** (below) — table of name, definition and a **sensitivity selector**. Add, edit, disable/re-enable, delete (guarded — the API answers 409 "in use", which the UI should surface as an offer to disable instead). **Starts empty**, so the empty state matters: it is the first thing an admin sees, and it should say what data types are for and that engagements can't record data until some exist.

**Data types become a multi-select** everywhere they are captured today — six files currently handle the free-text field:
* `vendors/RequestVendorModal.tsx`, `vendors/RequestEngagementModal.tsx`, `vendors/AmendEngagementModal.tsx` — the onboarding and portal request flows
* `vendors/detail/cards.tsx` — the engagement display; show each type with its sensitivity, and the engagement's effective sensitivity
* `vendors/OnboardingRequests.tsx` — the internal review of a submitted request
* `vendors/ApprovalAreas.tsx` — the rule editor: the `data_types_any` multi-select gives way to a **single sensitivity threshold** selector, presented like the existing `min_criticality` rule

Only **active** data types appear in the pick-lists; a disabled type already recorded against an engagement still renders (historical records stay readable) but can't be newly selected.

**Tests:** the rubric edit + history path; add/disable/guarded-delete; the empty state; a request modal submitting type ids; the rule editor producing a `min_sensitivity` rule; a disabled type rendering on an old engagement but absent from the picker.

Blocked by COM-206 — needs the API and the regenerated `schema.d.ts`. (Offline regen: strip the stdout log lines before `openapi-typescript`.)

Refs: ADR 0042, 0039, 0028, 0018, 0017, 0026.