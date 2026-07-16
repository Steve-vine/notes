---
id: 01KXK85A3WD89VS2R7WKVCRMRG
created: 2026-07-15T16:01:06.684650209Z
updated: 2026-07-16T08:49:22.845305676Z
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
comments:
- id: 01KXN1VGCXSQ4J9V6H3ZFSVCTE
  author: Steve Vine
  at: 2026-07-16T08:49:22.84521184Z
  text: |-
    Build complete on feature/com-177-review-actions; PR #168 open against main, branch merged to staging. This is the final Sprint 27 brief.

    **What was done**
    - VendorReviewAction model (soft-delete, the TreatmentPlan analogue) + migration 0040; CRUD under /vendors/{id}/reviews/{review_id}/actions with a vendor-level listing for the card.
    - The unified Actions queue aggregates open vendor actions (title "<vendor>: <description>", company via the review's vendor, /vendors/{id} deep link, shared overdue derivation); done and soft-deleted actions drop out.
    - Frontend: Review-actions card on the Reviews tab (Close/delete for writers, Add-action modal with review picker defaulting to the newest, assign-to-me switch, disabled with a hint when no reviews exist); Actions page gets the 'Vendor action' label + filter.
    - 5 backend integration + 2 frontend tests; suites green (84 unit, 14 integration, 180 Vitest, build).

    **Local verification**: ruff + format, mypy src, Semgrep p/default clean, tsc -b/ESLint/Prettier/build pass (one useState<string | null> annotation the project build demanded — --noEmit had let the inference slide).

    **Decisions made on the fly**
    - Actions attach to a review (the finding's context) rather than the vendor directly — the ADR names them vendor_review_actions; the Add-action modal preselects the newest review.
    - Done actions stay visible on the vendor card (struck through) but leave the Actions queue — the queue is outstanding work only, matching gaps/treatments.
    - The queue title is prefixed with the vendor name so rows read sensibly next to other types.
---
Phase 2 (ADR 0039 §4): review findings become assignable, due-dated work in the unified Actions queue (ADR 0025).

- [x] `models/vendor_review_action.py`: review FK (CASCADE), `description`, `owner_id` SET NULL, `due_on`, status open/done — soft-deletable like treatment plans + migration 0040.
- [x] CRUD via the review sub-resource [require_vendor_write] (review must belong to the vendor, owner validated, DELETE = soft); vendor-level `GET /vendors/{id}/actions` [read] for the detail card.
- [x] `/api/v1/actions` aggregation gains the `vendor_review_action` type — open, non-deleted actions on live vendors, titled `<vendor>: <description>`, company via the review's vendor, deep link `/vendors/{id}`; overdue via the shared date logic. `ActionType` literal extended.
- [x] UI: Review-actions card on the vendor detail Reviews tab (status pill, Close/delete for writers, Add-action modal attaching to a review — newest preselected, assign-to-me); Actions page renders the new type ('Vendor action' label + filter option).
- [x] Tests: 5 backend integration (CRUD, cross-vendor 404, aggregation incl. done-excluded + composed filters, role gating, unknown 404s) + 2 frontend Vitest.

Branch `feature/com-177-review-actions`, PR #168. Ref: ADR 0039 §4, ADR 0025.