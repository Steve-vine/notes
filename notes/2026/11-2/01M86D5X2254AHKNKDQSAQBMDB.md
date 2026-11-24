---
id: 01M86D5X2254AHKNKDQSAQBMDB
created: 2026-11-24T09:11:21.410321Z
updated: 2026-11-24T17:51:22.640721Z
type: task
title: Each company keeps its own list of departments, edited in Admin → Companies
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2131
sprint: sectbn9
comments:
- id: 01M86PEEKWVV2TAT13GBW85QN5
  author: Steve Vine
  at: 2026-11-24T11:53:18.716593Z
  text: |-
    Built and merged to main: PR #2125 (27d21d61c), migration 0909_departments, ADR 0175 (Proposed; also listed in CLAUDE.md).

    What people see:
    - Admin → Companies → a company has a new "Departments · N" panel under Systems and applications. It lists the company's departments in their order, with retired ones kept in place, dimmed and marked Retired.
    - Someone who can manage companies can add, rename, move up/down (↑/↓), retire and bring back a department.
    - Names are unique within a company, ignoring case and spaces at the ends: "E2E Test Company already has a department called Finance". The same name in another company is fine.
    - Delete only shows for a department no engagement uses. One in use shows "Used by N" and offers Retire. A refused delete says "Finance is used by 3 engagements — retire it instead". (The count starts working when COM-2133 links engagements.)
    - An archived company's list is read-only.
    - Each add, rename, retire, bring back and delete writes its own activity-log line against the company. A reorder writes one line.
    - Anyone who can see the company's vendors (Compass or portal) or request a vendor can read the list. A recertifier-only account can't.

    Tested: backend integration tests for every Done-when point, plus the migration up → down → up and the case-insensitive uniqueness. Vitest covers the panel (list, add/rename/retire/reorder/delete, read-only archived company). CI full suite green.

    For Steve to decide:
    1. Departments have their own panel at the bottom of the company page rather than sitting among the scope panels, because they aren't scope.
    2. Retired departments stay in place in the list (dimmed) rather than moving to a separate section.
    3. People who can request a vendor but can't see the register can still read the departments, because they pick one on the request form.

    Not checked yet: seen in a browser (comes with the staging pre-UAT pass).
- id: 01M87247KPFYVN6Y2M71NB3671
  author: Steve Vine
  at: 2026-11-24T15:17:26.774066Z
  text: |-
    Pre-UAT on staging (0234a65f3), E2E Test Company, as E2E Admin A: **Passed**.
    - Added Finance, IT, Operations and Facilities. " finance " was refused: "E2E Test Company already has a department called Finance".
    - Renamed Facilities → Facilities Management. Moved Operations up (Finance, Operations, IT). Retired IT (dimmed, Retired mark, Bring back) and brought it back. Deleted Facilities Management.
    - Activity log: one line per add, rename, retire, bring back and delete, plus one for the reorder.
    - Demo's page shows its own empty, separate list (not changed).
    - A department in use shows "Used by N" with no Delete. Deleting it anyway is refused: "IT is used by 1 engagement — retire it instead".
    - Couldn't check: the same name allowed in another company (it would mean editing another company; backend tests cover it).
    - Found: pressing Enter in the Add department window doesn't save (you have to click Add). Fix-forward task raised. Delete has no confirmation: for Steve (it only applies to unused departments, and it's in the activity log).
    Left on staging: Finance, Operations, IT on E2E Test Company.
    Screenshots: ~/compass-uat/sectbn9/COM-2131/
- id: 01M87AY30GEEHJ3G9H4DP1QRZ5
  author: Steve Vine
  at: 2026-11-24T17:51:22.640173Z
  text: Steve accepted ADR 0175 on 24 Nov 2026. The status change in the repo is tracked as its own task in this sprint.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Vendor Departments" (Steve, 24 Nov 2026). The first of five: the list every other task picks from.

## Why
Every vendor engagement will record the department it is for (next tasks). There is no agreed list of departments, and each company has its own, so each company keeps an editable list.

## What people see
- Admin → Companies → a company: a new **Departments** panel beside Locations, Providers and Systems. It lists the company's departments in the order they're arranged.
- Someone who can manage companies can **add** a department (a name; unique within the company, ignoring case and spaces at the ends), **rename** it, **reorder** the list, and **retire** or **bring back** one.
- A **retired** department stays on the engagements that already have it, under its name with a "Retired" mark, but isn't offered when an engagement is added or changed.
- **Delete** is only offered for a department no engagement has ever used. One in use says how many engagements use it and offers Retire instead.
- Renaming shows the new name everywhere the department appears, including on existing engagements.
- A company that has ended (read-only) shows its list but can't change it.
- Adding, renaming, retiring, bringing back and deleting a department appear in the activity log.
- Anyone who can see a company's vendors (including portal requesters) can read its active departments, because they'll pick from them.

## Done when
- An administrator adds Finance, IT and Operations to E2E Test Company, renames one, reorders them, retires one and brings it back. A second company's list is separate and unaffected.
- A duplicate name in the same company is refused with a clear message, and the same name in another company is allowed.
- Deleting an unused department works. Deleting one in use is refused with the count, and Retire is offered (the guard can be tested here directly; the engagement link arrives in the third task).
- ADR 0175 (Proposed) records the decision: a per-company department list, retire rather than remove, one department per engagement.

## For the build
- New company-scoped table (e.g. `departments`: company_id, name, position, status active/retired; unique (company_id, lower(name))). Model it on `models/data_entity.py` / `api/v1/data_entities.py` (status, guarded DELETE returning 409 with a count) plus `CompanyScopedMixin` and the per-company uniqueness of `models/vendor_flag.py`.
- Routes under the company (e.g. `/companies/{id}/departments`): list (`include_retired`), create, patch (rename/retire/restore), reorder, delete. Writes gated like company scope (`admin.manage_companies`, writable company); reads open to anyone who can read that company's vendors, including the portal (compare `require_data_vocabulary_read`).
- UI: a `Panel` on `pages/CompanyPage.tsx` beside Locations (L203), with rows following `admin/DataRubricSection.tsx` `DataEntityRow` (Retire/Bring back/Delete, 409 handling).
- Add the table to `db/audit.py` `_AUDITED_TABLES`, and to the backups catalogue (`core/backups/opened_catalogue.py`) so Restore option 3 knows it.
- Migration 0909 (or next free). Probably **on the chain**: migration + API.