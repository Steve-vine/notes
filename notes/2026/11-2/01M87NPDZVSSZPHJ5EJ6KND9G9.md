---
id: 01M87NPDZVSSZPHJ5EJ6KND9G9
created: 2026-11-24T20:59:26.075054Z
updated: 2026-11-24T21:17:37.960348Z
type: task
title: 'A Business services page: each company''s list of Internal and Client facing services'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2150
sprint: ss3ttbb
blocked_by:
- 01M87NP509Q79GWHY7EYF0KVPQ
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint "Business Services". Follows the ADR.

## What people see
- **Exposure → Business services** (after Inventory) lists the company's services: reference (SVC-n), name, type (Internal or Client facing), owner, criticality and status. It can be filtered by type, criticality and status, searched, and sorted.
- **Someone who can manage the inventory** can add a service (name unique within the company; type; description; owner; criticality on the existing criticality scale), edit it, and retire or bring it back.
- **Delete** only works for a service nothing links to. One in use offers Retire.
- **A service's own page** shows its details and history. Later tasks add cards here for what it depends on, its vendors, risks, incidents and content.
- **A retired service** stays visible (marked) on everything already linked to it, but isn't offered for new links.
- **Global search** finds services by name or SVC-n.
- Every add, change, retire and delete is in the activity log.
- Polaris can list, read, add and update services (`inventory_` tools).
- Moneypenny's services aren't seeded. People add them.

## Done when
- In E2E Test Company: add TAS (Client facing) and Payroll (Internal), filter by type, retire one and bring it back, and delete an unused one.
- A duplicate name is refused.
- Another company can't see them.
- SVC-n references are given out and found by search.

## For the build
- Table `business_services`: company-scoped, `Sequence("business_service_number_seq")`, `SVC` prefix with a `business_service_ref()` helper (as `container.py` does). Add `SVC` to `RESERVED_PREFIXES` in `core/registers/prefixes.py`. The migration must check no existing register already uses the prefix SVC, and stop with a clear message if one does.
- Type enum (internal / client_facing). Criticality reuses the asset criticality scale.
- Audited (`_AUDITED_TABLES`). Add it to the backups catalogue.
- Menu: `components/nav.ts`, Exposure group, gate Inventory. Screen conventions apply.
- Polaris: `assistant/tools/inventory_services.py` (the inventory area has about 49 tools to spare).
- **On the chain**: migration + API.