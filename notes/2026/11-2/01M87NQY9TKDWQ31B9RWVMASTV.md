---
id: 01M87NQY9TKDWQ31B9RWVMASTV
created: 2026-11-24T21:00:15.54699Z
updated: 2026-11-24T21:17:17.571833Z
type: task
title: The business impact analysis assesses the business services list, replacing its own list of functions, and Continuity reads per service
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2156
sprint: ss3ttbb
blocked_by:
- 01M87NPND8AN476F9PXXD35AMQ
- 01M87NQ09XED3JVCD11CASC93A
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint "Business Services". Follows the Inventory links and the vendor blast radius.

**Steve decided (24 Nov 2026): option 2, replace the BIA's own list of business functions with the business services list.** One list everywhere. Internal functions such as Payroll become Internal services.

## What people see
- **A new BIA assesses every active business service of the company,** Internal and Client facing, instead of a list of functions typed into the BIA. Each service gets the same assessment a function had: its impact over time, maximum tolerable disruption (suggested, or set with a reason), RTO and RPO, busiest times, minimum service, and the people and sites it needs.
- **What a service depends on** comes from the service itself: its Depends on (COM-2151) and its Vendors (COM-2152). It's shown in the BIA and kept with the BIA when it's approved, so an approved BIA still reads as it was even if the service's links change later. Nothing is typed twice.
- **A service added after a BIA was started** can be added to that draft. A service retired during a draft can be left out, with a reason.
- **Approved BIAs from before this change keep their functions** and read exactly as they did. A draft BIA still in progress when this lands offers to carry each of its functions across to a matching service (by name), or to start a new service from it. Nothing is lost.
- **Continuity** reads the current approved BIA. Once that's a service-based one, every flag, card and the Continuity page read **by service**: each service, its targets, whether IT can meet them, and the systems at fault. Until then it works as today.
- **A service's page** shows its recovery targets from the current approved BIA and its Continuity flags.
- Polaris's BIA and Continuity tools work with services.

## Done when
- In E2E Test Company: start a BIA. It lists every active service. Assess TAS and approve it. TAS's page shows its targets and flags, and the Continuity page lists TAS with any systems that can't meet them.
- An older approved BIA with functions still opens and reads as before.
- A draft BIA with functions can carry them across to services.
- Changing TAS's dependencies after approval doesn't change what the approved BIA shows.

## For the build
- The BIA's rows become per-service assessments (e.g. `bia_service_assessments`: assessment_id, business_service_id, plus the fields `bia_functions` has), with a snapshot of the service's dependencies taken at approval. `bia_functions` and `bia_function_dependencies` stay for older BIAs, read-only.
- `core/business_impact.py` (create, start next, submit, approve, supersede) and `core/continuity.py` (`system_targets`, `flags`, `vendor_needs`) learn the per-service source, falling back to functions for a function-based current BIA.
- Screens: the BIA editor (`riskAssessments/bia/`), Continuity cards and page. Polaris `risk_assessments_*` BIA tools and `*_get_continuity`.
- The assessment's frozen-on-approval rule (`EDITABLE_STATUSES`) applies to the new rows too.
- ADR 0178 records option 2. ADR 0131 (business continuity) is amended or superseded for the BIA's rows.
- **On the chain**: migration + API. The largest task in the sprint; it can be split if it grows.