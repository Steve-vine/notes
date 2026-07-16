---
id: 01KXK85A3WD89VS2R7WKVCRMRG
created: 2026-07-15T16:01:06.684650209Z
updated: 2026-07-16T08:39:59.294643716Z
type: task
title: Vendor review actions → Actions queue
assignee: steve
label:
- brief
priority: medium
task_status: active
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 177
blocked_by:
- 01KXK84SPXXWCHGF8SKKBZSGQK
sprint: sxady3y
---
Phase 2 (ADR 0039 §4): review findings become assignable, due-dated work in the unified Actions queue (ADR 0025).

- [ ] `models/vendor_review_action.py`: review FK, `description`, `owner_id` SET NULL, `due_on`, status open/done + migration.
- [ ] CRUD via the review sub-resource [require_vendor_write].
- [ ] Extend `/api/v1/actions` aggregation with a `vendor_review_action` type (deep link to the vendor detail page); overdue derivation via the shared date logic.
- [ ] UI: actions card on the vendor detail page; new type renders in the Actions page.
- [ ] Tests: aggregation includes/filters vendor actions.

Ref: ADR 0039 §4, ADR 0025.