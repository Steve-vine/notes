---
id: 01M87AXVY33YGJ5JG8SC2M0GDV
created: 2026-11-24T17:51:15.395388Z
updated: 2026-11-24T21:47:37.444692Z
type: task
title: 'Portal vendor list: the department shows on each engagement line, not on the vendor''s row'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2145
sprint: sectbn9
comments:
- id: 01M87HP2RWMAZ90D1ZBSQ39QAX
  author: Steve Vine
  at: 2026-11-24T19:49:20.28469Z
  text: 'Steve, 24 Nov: an engagement can now have several departments (COM-2147). Each engagement line shows all of its departments in the company''s order (e.g. "Finance, IT"), and the vendor''s row still shows none. Build this alongside or after COM-2147, which changes the same cell.'
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Sprint "Vendor Departments". Steve's change from testing COM-2135 on staging (24 Nov 2026).

## Why
Steve: the department belongs to the engagement, not the vendor. On the user portal's vendor list, where each vendor expands into its engagements, the department should appear only on the engagement lines, not on the vendor's own row. The Compass vendor register (COM-2136) shows no engagement lines, so its per-vendor Department column stays as it is.

## What people see
- Portal → Vendors and My Vendors: the Department column is empty on each vendor's row. Each engagement line under it shows that engagement's department ("Finance", "Finance (Retired)" or "Not recorded").
- The Department filter stays and works as now: it shows vendors with a live engagement in the chosen departments.
- With the vendor row no longer carrying a department, the column is no longer sortable on the portal list (there's nothing per vendor to sort by).
- No change to the Compass vendor register, the report, or Polaris.

## Done when
- In E2E Test Company, on the portal list: no vendor row shows a department, and every engagement line shows its own.
- The filter still finds the same vendors as before.
- The Compass register is unchanged.

Independent: screen only (`pages/PortalVendorsPage.tsx`, using COM-2135's `EngagementDepartmentCell`). Update its Vitest.