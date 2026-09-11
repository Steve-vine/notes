---
id: 01M26M18P2AY78E2GHJTC8K5HV
created: 2026-09-10T21:36:58.562735Z
updated: 2026-09-11T19:27:59.785416Z
type: task
title: Review cadence — default intervals per register, overdue reviews as owner actions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 672
sprint: skdc1az
blocked_by:
- 01M26M10T1M3CG6X987FY72B29
comments:
- id: 01M26YZQHDW735BXAX4RAXXMX8
  author: Steve Vine
  at: 2026-09-11T00:48:22.57297Z
  text: |-
    Done — PR #680 merged to main.

    Backend: `inventory_settings` singleton (no row = 365 days per register; migration 0184) with GET/PUT /api/v1/inventory-settings (read inventory.view, write inventory.admin). `core/inventory_reviews.py` is the one place the due date is computed — last verified (or created) + the asset's interval or the register default; null once decommissioned — and both registers, the detail pages and the portal's My assets read it (next_review_at, review_overdue). Action source `inventory_review_due`: an asset whose review has come round is its owner's action (unowned → module work for Inventory admins), derived on read so one per asset per period never duplicates and Confirm accurate closes it; overdue ones join the digest like everything else; portal links map to /portal/inventory. No Beat task was needed: actions are a projection (ADR 0025/0055) and the digest job is the run that mails them, deduped in its ledger. Tests cover the acceptance path (30-day interval, verified 40 days ago → one action for the owner, in the portal too; Confirm accurate closes it and moves the next review 30 days out; a second read raises nothing), the defaults, the per-register setting, the decommissioned exemption and the write gate.

    Frontend: Next review column on both register tabs (sortable, Overdue marker) and in the Lifecycle facts; a Settings tab on the Inventory register (inventory.admin) with the two defaults; Actions label "Asset review".
assignee: steve
label:
- feature
priority: medium
task_status: done
---
The inventory must be kept accurate, and Compass has to make that happen rather than hope (ADR 0072; ISO 27001 A.5.9).

* **Register defaults**: a default review interval per register (containers, data assets), annual to start, on the Inventory settings (Admin ▸ Inventory or an Inventory settings tab — follow where recert settings live). Overridable per asset (`review_interval_days`).
* **Due date** = `last_verified_at` (or created) + interval. Shown on both lists as **Next review**, sortable; overdue rows carry a marker.
* **Action source** (ADR 0055): `inventory.review_due` — an action for the asset's owner, raised by a Beat task when a review falls due, closed automatically when Confirm accurate is pressed. Overdue actions join the reminder/overdue digest; one action per asset per period (deduped on asset + due date), never a duplicate on re-run.
* Decommissioned assets are exempt.
* Dashboard: the Inventory tile (finishing task) shows overdue-review counts.

**Acceptance**: set a 30-day interval on a container verified 40 days ago → the Beat run raises one action for the owner, the portal shows it, Confirm accurate closes it and the next review moves 30 days out; a second Beat run raises nothing.