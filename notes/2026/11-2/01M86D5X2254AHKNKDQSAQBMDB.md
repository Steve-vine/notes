---
id: 01M86D5X2254AHKNKDQSAQBMDB
created: 2026-11-24T09:11:21.410321Z
updated: 2026-11-24T10:59:04.698952Z
type: task
title: Each company keeps its own list of departments, edited in Admin → Companies
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2131
sprint: sectbn9
assignee: steve
label:
- feature
priority: medium
task_status: active
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