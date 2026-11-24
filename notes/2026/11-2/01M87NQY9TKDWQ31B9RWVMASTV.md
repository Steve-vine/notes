---
id: 01M87NQY9TKDWQ31B9RWVMASTV
created: 2026-11-24T21:00:15.54699Z
updated: 2026-11-24T21:00:15.54699Z
type: task
title: The business impact analysis assesses business services, and Continuity reads per service
label: feature
assignee: steve
task_status: todo
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2156
---
Sprint "Business Services". Follows the Inventory links and the vendor blast radius. **Steve to confirm the approach before it's built** (see "The choice").

## What people see
- **In a draft BIA**, each business function can be tied to a business service ("this function is how we assess TAS"). A new function can be started from a service, taking its name, owner and description, and its dependencies from the service's Depends on and Vendors.
- **A service's page** shows its recovery targets from the current approved BIA (MTPD, RTO and RPO) and Continuity's flags for it: which of its systems can't be recovered in time, have no target, or have no runbook.
- **The Continuity page** gains a **By service** view: each service, its targets, and whether IT can meet them, listing the systems at fault.
- **Approved BIAs aren't changed.** Older approved BIAs read as they did.

## The choice (Steve)
1. **Tie functions to services** (as above). The BIA keeps its own function list and each function may point at a service. This is the smaller change, and internal functions can still exist without a service.
2. **Replace the function list with the services list.** Each BIA assesses every active service. One list everywhere, but a bigger change to the BIA and its history.
This task describes option 1. Change it if Steve picks 2.

## Done when
- In E2E Test Company: a draft BIA ties a function to TAS and is approved. TAS's page shows its targets and Continuity flags.
- The Continuity page's By service view lists TAS with the systems that can't meet the target.

## For the build
- `bia_functions.business_service_id` (nullable FK, SET NULL). The "start from a service" action copies dependencies into `bia_function_dependencies`.
- `core/continuity.py`: a per-service roll-up from `system_targets()` / `flags()`.
- Card on the service page; a view on `pages/ContinuityPage.tsx`. Polaris `inventory_get_continuity` / `posture_get_continuity` gain a per-service answer.
- **On the chain**: migration + API.