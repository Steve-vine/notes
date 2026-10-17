---
id: 01M54K3K8QZ2EBBNZ2CVCXW0ZV
created: 2026-10-17T09:29:22.967062Z
updated: 2026-10-17T13:45:23.431691Z
type: task
title: SAP appears in the Modules menu — a company's plan of security work, where people with the right permission add, edit and delete entries (title, description, type, owner, dates, status)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1042
sprint: sxflvhs
blocked_by:
- 01M54K2KQAV78DGJTF8FMHD663
comments:
- id: 01M551RB5W8NCH7KRF39Z3WPJJ
  author: Steve Vine
  at: 2026-10-17T13:45:22.876338Z
  text: |-
    Done: merged in PR #1042.

    - SAP sits in Modules, after Inventory, for anyone with "View the Security Assurance Plan". With no company picked, it asks you to pick one.
    - The Schedule tab lists entries with their reference (SAP-12), type, owner, start and due dates, and status. It filters by type, status and owner, with switches for "Overdue only" and "Owned by me", and every column sorts. Overdue is a red pill that the server works out.
    - Add entry, Edit and Delete need "Manage the Security Assurance Plan". Delete asks first, and is only offered while an entry is open.
    - The owner is picked from the directory, the same way as an asset's owner. Someone without a Compass account gets one when the entry is saved.
    - An entry's page has a History section showing who changed what and when. Anyone who can see the plan can read it, unlike the admin-only audit trail.
    - ⌘K finds entries by reference, title or description.

    Two changes from the brief:
    - References are numbered across all companies, like G-, R- and AST-.
    - The three new permissions go to Admin only. The starter roles stay frozen; tick SAP into Viewer in Admin ▸ Roles if you want it there.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 75, SAP - Schedule (ADR in COM-1041). The foundation every other SAP task builds on. Built first after the ADR.

## What people see

- **SAP** in the Modules section of the menu, for anyone with `sap.view`. The page is called **Security Assurance Plan**, for the company chosen in the top bar.
- A **Schedule** tab listing the plan's entries, sortable and filterable by type, status, owner and date. The timeline and calendar views come in COM-1047; this task builds the list.
- **Every entry has a reference**, `SAP-12`, numbered per company like gaps. People say it, the assistant finds entries by it (COM-1059), and it's searchable in ⌘K.
- **Add entry** (needs `sap.manage_plan`) asks for:
  - **Title** (required) and **Description**;
  - **Type:** Training, Testing, Review, Audit or Other;
  - **Owner:** one person, using the same people picker as an asset's owner;
  - **Start date** and **End date**; the end date is when it's due, and can't be before the start;
  - **Status:** Planned (the default) or In progress. Done and Cancelled come in COM-1045, with what they ask for.
- **An entry's page** shows all of the above. Its history shows who changed what and when. **Edit** and **Delete** are there for `sap.manage_plan`.
- **Overdue** shows as a red pill when the end date has passed and the entry isn't done or cancelled. It's worked out; nobody sets it.
- **Delete** is offered only while an entry is Planned or In progress (Steve, B). It asks for confirmation. A deleted entry's reference isn't reused.

## Rules

- Everything belongs to one company. Switching company shows that company's plan.
- Every add, edit and delete is in Activity, and the entry keeps its own history.
- New permissions `sap.view`, `sap.manage_plan` and `sap.approve_plan` (the last is used by COM-1056), in a new "Security Assurance Plan" group in Admin ▸ Roles. Add them to the built-in roles where they fit (admin: all; viewer: view).

## Notes (technical)

- New `sap_entries` table: company-scoped, actor-stamped, soft-deleted, with a revision table for history (the risk/vendor revision pattern). Fields include `number` (per-company, as `Gap.number`), `type`, `status`, `owner_id`, `start_date` and `end_date`. Leave room for `series_id` (COM-1046) and the completion fields (COM-1045), or add them there.
- Router `api/v1/sap.py`; nav entry in `components/nav.ts` (Modules section, gated on `sap.view`). Read `brief/information-architecture.md` → *Screen conventions* first. Every table needs SortableTh, and every Switch needs w="fit-content" (screen-conventions test).
- ⌘K: add SAP entries to search (`api/v1/search.py`), gated on `sap.view`.
- Overdue is computed on read (in the backend, so the API and the assistant agree), never stored.
- Breadcrumbs follow the sprint 64 rules.

**Done when:** someone with `sap.manage_plan` can add, edit and delete entries for a company. Someone with `sap.view` only can read them. Someone without it doesn't see SAP in the menu.