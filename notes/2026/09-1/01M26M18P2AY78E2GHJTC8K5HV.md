---
id: 01M26M18P2AY78E2GHJTC8K5HV
created: 2026-09-10T21:36:58.562735Z
updated: 2026-09-10T21:36:58.562735Z
type: task
title: Review cadence — default intervals per register, overdue reviews as owner actions
label: feature
task_status: todo
assignee: steve
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 672
---
The inventory must be kept accurate, and Compass has to make that happen rather than hope (ADR 0072; ISO 27001 A.5.9).

* **Register defaults**: a default review interval per register (containers, data assets), annual to start, on the Inventory settings (Admin ▸ Inventory or an Inventory settings tab — follow where recert settings live). Overridable per asset (`review_interval_days`).
* **Due date** = `last_verified_at` (or created) + interval. Shown on both lists as **Next review**, sortable; overdue rows carry a marker.
* **Action source** (ADR 0055): `inventory.review_due` — an action for the asset's owner, raised by a Beat task when a review falls due, closed automatically when Confirm accurate is pressed. Overdue actions join the reminder/overdue digest; one action per asset per period (deduped on asset + due date), never a duplicate on re-run.
* Decommissioned assets are exempt.
* Dashboard: the Inventory tile (finishing task) shows overdue-review counts.

**Acceptance**: set a 30-day interval on a container verified 40 days ago → the Beat run raises one action for the owner, the portal shows it, Confirm accurate closes it and the next review moves 30 days out; a second Beat run raises nothing.