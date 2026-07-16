---
id: 01KXK85A3WD89VS2R7WKVCRMRG
created: 2026-07-15T16:01:06.684650209Z
updated: 2026-07-16T08:49:05.693729646Z
type: task
title: Vendor review actions → Actions queue
assignee: steve
label:
- brief
priority: medium
task_status: review
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 177
blocked_by:
- 01KXK84SPXXWCHGF8SKKBZSGQK
sprint: sxady3y
---
Phase 2 (ADR 0039 §4): review findings become assignable, due-dated work in the unified Actions queue (ADR 0025).

- [x] `models/vendor_review_action.py`: review FK (CASCADE), `description`, `owner_id` SET NULL, `due_on`, status open/done — soft-deletable like treatment plans + migration 0040.
- [x] CRUD via the review sub-resource [require_vendor_write] (review must belong to the vendor, owner validated, DELETE = soft); vendor-level `GET /vendors/{id}/actions` [read] for the detail card.
- [x] `/api/v1/actions` aggregation gains the `vendor_review_action` type — open, non-deleted actions on live vendors, titled `<vendor>: <description>`, company via the review's vendor, deep link `/vendors/{id}`; overdue via the shared date logic. `ActionType` literal extended.
- [x] UI: Review-actions card on the vendor detail Reviews tab (status pill, Close/delete for writers, Add-action modal attaching to a review — newest preselected, assign-to-me); Actions page renders the new type ('Vendor action' label + filter option).
- [x] Tests: 5 backend integration (CRUD, cross-vendor 404, aggregation incl. done-excluded + composed filters, role gating, unknown 404s) + 2 frontend Vitest.

Branch `feature/com-177-review-actions`, PR #168. Ref: ADR 0039 §4, ADR 0025.