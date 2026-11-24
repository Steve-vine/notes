---
id: 01M87NPND8AN476F9PXXD35AMQ
created: 2026-11-24T20:59:33.672164Z
updated: 2026-11-24T21:00:40.10719Z
type: task
title: 'Business services link to Inventory: the systems, software and data a service depends on'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2151
sprint: ss3ttbb
blocked_by:
- 01M87NPDZVSSZPHJ5EJ6KND9G9
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint "Business Services". Follows the Business services page.

## What people see
- **A service's page** has a **Depends on** card listing the systems, software and data assets it uses. Each can be added or removed, with an optional note ("call recording").
- **Also shown, not stored:** the systems those systems depend on, via Inventory's existing dependencies. They're listed separately as "through AST-4 · Call platform", so the whole chain is visible.
- **A system's, software's and data asset's page** shows **Supports services**: the services that depend on it, directly or through another system, with the route.
- **A retired asset** still shows (marked) on services already linked to it.
- Linking and unlinking are in the activity log.
- Polaris can link and unlink, and answer "what does TAS depend on?" and "which services does AST-4 support?".

## Done when
- In E2E Test Company: link TAS to a system, a software asset and a data asset.
- The system's page shows TAS. A system that the linked system depends on shows TAS "through" it.
- Unlinking removes it from both sides.
- Deleting a system that a service depends on follows the existing delete rules for linked assets.

## For the build
- One link table, business service ↔ asset. Use a polymorphic asset kind like `inventory_risk_links` (kind + asset id) or three FKs with a one-target check like `bia_function_dependencies`. Prefer real FKs.
- Walk dependencies with the breadth-first walk `core/continuity.py` `_walk` already uses.
- Update the inventory delete guard (`core/inventory_deletion.py`).
- Audited. Add the link table to the backups catalogue.
- **On the chain**: migration + API.