---
id: 01M87NPDZVSSZPHJ5EJ6KND9G9
created: 2026-11-24T20:59:26.075054Z
updated: 2026-11-25T04:06:11.766724Z
type: task
title: 'A Business services page: each company''s list of Internal and Client facing services'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2150
sprint: ss3ttbb
blocked_by:
- 01M87NP509Q79GWHY7EYF0KVPQ
comments:
- id: 01M87Z05MQQEF5RFF9MEH98D4V
  author: Steve Vine
  at: 2026-11-24T23:42:02.391515Z
  text: |-
    Built and merged to main: PR #2143 (a8818ed80), migration 0915_business_services.

    What people see:
    - Exposure → Business services (after Inventory, same access) lists SVC-n, name, type (Internal or Client facing), owner, criticality and status. It filters by type, criticality and status, searches, and sorts every column. It opens on Active; Status: All shows retired ones, marked.
    - Someone who can manage the inventory can add (name unique within the company, ignoring case), edit, retire and bring back a service.
    - Delete appears only for a service nothing links to, and asks first. One in use says what links to it and offers Retire. A deleted service's SVC number is never reused, and its history stays.
    - A service's page shows its description, details and history. Later tasks add their cards there.
    - Global search finds services by name, description or SVC-n, in the selected company only.
    - Every add, change, retire, bring-back and delete is in the activity log.
    - Polaris can list, read, add, update, retire and bring back services. Deleting stays on screen.
    - SVC is reserved: no register can use it.

    Tested: backend integration for every Done-when point, permissions, an archived company, migration up → down → up and the SVC guard, and the Polaris tools. Vitest covers the list and service pages. CI green.

    For Steve to decide:
    1. Only name and type are required. Once a criticality is set it can be changed but not cleared (the shared picker has no clear option).
    2. Delete hides the service but keeps the record, so its SVC number and history survive and a backup can put it back.
    3. Retire and Bring back take effect at once with no reason asked, as departments do.
    4. Page addresses use the number (SVC-3 is /business-services/3).

    Not checked yet: seen in a browser (staging pre-UAT after both sprints).
- id: 01M88E3VHP84YZNDCV2H35RT25
  author: Steve Vine
  at: 2026-11-25T04:06:11.766499Z
  text: |-
    Pre-UAT on staging a63d542b2, as E2E Admin A: **Passed**.
    - Added SVC-1 TAS (Client facing, Critical) and SVC-2 Payroll (Internal, High). " tas " is refused as a duplicate.
    - The type filter works. Payroll retired (gone from Active, shown marked under Status All) and brought back.
    - An unused service was deleted after confirmation. History shows each step.
    - Global search "SVC-1" finds TAS. Other companies see no services.
    Screenshots: ~/compass-uat/ss3ttbb/COM-2150/
assignee: steve
label:
- feature
priority: medium
task_status: review
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