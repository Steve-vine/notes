---
id: 01M87HNCQ8RWA88ZTR0B1TTZ03
created: 2026-11-24T19:48:57.704384Z
updated: 2026-11-24T20:42:22.040249Z
type: task
title: 'An engagement can have several departments: chosen when it''s added or edited, and shown wherever its department shows today'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2147
sprint: sectbn9
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Sprint "Vendor Departments". Steve's amendment while testing on staging (24 Nov 2026): "it should be possible to assign multiple departments to an engagement." Part 1 of 2; part 2 (COM-2148) covers requests.

## What people see
- **Adding or editing an engagement** in Compass: the Department drop-down becomes a multi-select of the company's active departments, in their order. **At least one is required**, and there's no upper limit.
- **Engagements that already have a department** keep it as their first and only one. Nothing is lost.
- **A retired department** stays on engagements that have it (marked Retired) and can be kept, but can't be newly added.
- **The engagement card**, in Compass and the portal, shows all of the engagement's departments in the company's order, e.g. "Finance, IT".
- **The portal vendor list:** each engagement line shows all its departments (with COM-2145, the vendor's own row shows none).
- **The Compass vendor register:** a vendor's Department column lists every department across its live engagements, each once.
- **The filters** (portal list and Compass register) match a vendor when any of its live engagements has any of the chosen departments. "Not recorded" means none of its live engagements has a department.
- **The vendor register report's** Departments column lists every department across a vendor's live engagements, each once.
- **The Departments panel's** "Used by N" and the delete guard count every engagement that has the department among its several.
- **Polaris** can add and change an engagement's departments by name (one or several), and shows all of them.

## Done when
- In E2E Test Company: an engagement can't be saved with no department, and can be saved with Finance and IT. The card shows "Finance, IT" in Compass and the portal.
- Removing IT from it leaves Finance. Removing the last one is refused on a proposed or active engagement.
- Engagements on staging that had one department still show it after the change.
- Filtering by IT finds a vendor whose engagement has Finance and IT. The register, the portal list and the report all show both.
- Deleting a department used by such an engagement is refused with the count.
- Polaris adds an engagement with two departments named in words.

## For the build
- Replace `vendor_engagements.department_id` with a link table (engagement ↔ department, FK RESTRICT on the department side, like `vendor_engagement_data_entities`). Migrate each existing `department_id` into it, then drop the column. Test the migration against a populated database, not just a fresh one: upgrade with real engagement rows, check they're carried, then down and up again.
- API: `department_ids: list[uuid]` (min 1 on create, and on update of a live engagement) replaces `department_id`; output `departments: [{id, name, retired}]`. One resolver validates the list (same company; active unless already on the engagement).
- Update `core/departments.department_usage_counts`, the register and portal filters (`_department_clause`), the register's batched department load, the report's `_live_departments_by_vendor`, `DepartmentPicker` (multi), `EngagementDepartmentCell`, the engagement card, and Polaris `vendors_engagements` and `resolve_department` (a list).
- Backups catalogue: the new link table belongs with the engagement (core/backups/opened_catalogue.py), as `vendor_engagement_data_entities` does.
- **On the chain**: migration + API. Request paths still use the single column until COM-2148, so keep them working; this task must not break portal requests. Simplest is to have the request paths write a one-item list until COM-2148 makes them multi.