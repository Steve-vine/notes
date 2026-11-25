---
id: 01M87HNCQ8RWA88ZTR0B1TTZ03
created: 2026-11-24T19:48:57.704384Z
updated: 2026-11-25T09:17:39.617635Z
type: task
title: 'An engagement can have several departments: chosen when it''s added or edited, and shown wherever its department shows today'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2147
sprint: sectbn9
comments:
- id: 01M87REKMRCNDK7NK14SPCZ8NP
  author: Steve Vine
  at: 2026-11-24T21:47:35.44807Z
  text: |-
    Built and merged to main: PR #2138 (ea648d16a), migration 0913_engagement_departments.

    What people see:
    - Adding or editing an engagement in Compass: Departments is a multi-select of the company's active departments, in order. A proposed or active engagement needs at least one, with no upper limit. Removing the last one from a live engagement is refused; only an ended engagement can have none.
    - Engagements that had a department keep it as their only one. The migration carried every existing one across.
    - A retired department stays on engagements that have it (marked Retired) and can be kept, but not newly added.
    - The engagement card (Compass and portal), the portal list's engagement lines and the approver's review show every department in company order, e.g. "Finance, IT". The label reads "Departments" when there are several.
    - The portal and Compass filters (and the counts) find a vendor when any live engagement has any chosen department. "Not recorded" means none has one.
    - The register's Department column and the report's Departments column list every department across a vendor's live engagements, each once.
    - "Used by N" and the delete guard count every engagement that has the department among its several.
    - Polaris adds and updates engagements with one or several departments by name, and shows them all.

    Tested: 459 backend integration tests plus the unit suite. The migration was tested against seeded rows: carried on upgrade, first-in-order on downgrade, then up again. 1804 Vitest tests, including the multi-select, "Finance, IT" on the card, refusing removal of the last one, and a two-department portal line. CI green.

    For Steve to decide:
    1. Until COM-2148, a request still names one department, and an approved amendment replaces the engagement's whole set with that one (Finance + IT amended to IT leaves IT). COM-2148 makes requests carry a set.
    2. Restore ▸ Selected records: an engagement put back from a copy comes back without its departments. Its data types and data entities already behave this way, because put-back only writes rows directly under the vendor. Engagements are never deleted except by a vendor purge, so it rarely matters. Changing it would mean reworking put-back (Backup and Restore's code), so it's left as a known gap.

    Not checked yet: seen in a browser (staging pre-UAT after both sprints).
- id: 01M88E3GDD4F0AGFZMD4HMJYQT
  author: Steve Vine
  at: 2026-11-25T04:06:00.365129Z
  text: |-
    Pre-UAT on staging a63d542b2, E2E Test Company: **Passed**.
    - Add engagement with no department: "Pick at least one department." With Finance and IT it saves, and the card reads "Departments: Finance, IT".
    - Removing IT leaves "Department: Finance". Removing the last one is refused.
    - Older engagements (A1–A4, B1, B2) kept their single department after the migration.
    - Department = IT finds the vendor in the Compass register and the portal. The report CSV/PDF reads "Finance, IT", and an ended engagement's department isn't listed.
    - Departments in use show "Used by 3" with no Delete. The portal card reads "Departments Finance, IT".
    - Couldn't check: Polaris adding an engagement with two departments (needs a Polaris conversation).
    Screenshots: ~/compass-uat/sectbn9/COM-2147/
assignee: steve
label:
- improvement
priority: medium
task_status: done
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