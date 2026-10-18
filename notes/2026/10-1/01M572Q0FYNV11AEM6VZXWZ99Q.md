---
id: 01M572Q0FYNV11AEM6VZXWZ99Q
created: 2026-10-18T08:40:36.606234Z
updated: 2026-10-18T08:40:36.606234Z
type: task
title: Incidents appears in the Modules menu — a company's register of incidents (INC-12), where handlers record one with its categories, severity, times and owner, and nobody can delete one
task_status: todo
assignee: steve
label: feature
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1066
---
Sprint 76, Incidents - Register (ADR in COM-1063). Builds on the Incidents card (COM-1064). Every later task builds on this one.

## What people see

- **Incidents** in the Modules section of the menu, for people with `incidents.view`. The company picker decides whose register you see.
- **The register**: a sortable table showing reference (INC-12), title, categories (pills), severity, status, owner, and when it occurred and was reported. You can filter by status (open by default), category, severity, owner and date range. The filters sit in the URL like the other lists.
- **Record an incident** (for `incidents.handle`) asks for:
  - title and what happened;
  - one or more categories;
  - severity;
  - when it occurred, when it was detected, when the company became aware;
  - owner (the handler), and who reported it.
  The incident starts as **Reported**.
- **The incident page** has a header with reference, title, category pills, severity, status and owner, a Details card, and room for the sections later tasks add (one per category section, the timeline, notifications, review).
- Handlers can edit the details while the incident is open.

## Rules

- **There is no delete**, for anyone. A mistaken record is triaged as Not an incident (next task).
- A retired category or obligation stays visible on old incidents but can't be picked.
- Changes are in Activity, labelled with the reference.
- Permissions `incidents.view` and `incidents.handle` go to the built-in Admin only (ADR 0115 §3).

## Notes (technical)

- `incident_number_seq`, a `ref` property `INC-N`, and `CompanyScopedMixin`. Category many-to-many follows `vendor_flag_assignments`.
- Read `brief/information-architecture.md` → Screen conventions before building. Tables need `SortableTh`.
- Add the permission group to `core/permissions.py` and `brief/permission-catalogue.md`.

**Done when:** handlers can record and edit an incident with several categories; the register lists and filters them; there is no delete route.