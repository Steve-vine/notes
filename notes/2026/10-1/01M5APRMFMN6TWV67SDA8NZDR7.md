---
id: 01M5APRMFMN6TWV67SDA8NZDR7
created: 2026-10-19T18:28:44.660546Z
updated: 2026-10-19T18:28:44.660546Z
type: task
title: People pickers outside Incidents tell apart colleagues who share a name
label: follow_up
assignee: steve
priority: low
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1126
---
Follow-up from COM-1113 (found 2026-10-19 while fixing the Write up crash).

## Today

COM-1113 made the Incidents people pickers show a colleague's sign-in beside their name when two colleagues share one (staging has two "Steve Vine" accounts). The pickers elsewhere don't crash, because they're keyed by who the person is, but two people with the same name look identical, so it's easy to pick the wrong one.

## What people see

Wherever you pick a colleague, two people who share a name each show their sign-in beside it, e.g. "Steve Vine (steve@stevevine.uk)". Everyone else looks as today.

## Where (technical)

Switch each to `colleagueOptions(people)` / `colleagueLabel` from `components/colleagues.ts` (COM-1113):
- `access/RolesPage.tsx:547`, `access/RoleDetailPage.tsx:235` — `u.name`
- `pages/ContentDetailPage.tsx:911` — `u.name`, from the admin user list
- `vendors/ApprovalAreas.tsx:30` — `u.name || u.email`
- `components/OwnerPicker.tsx:31`, `access/ReportSchedule.tsx:184`, `vendors/detail/cards.tsx:2630` and `:2651` — name · job title, identical when the title is blank
- Not audited: the Inventory owner pickers and the role-holder search (own lists and labels).

**Done when:** with two same-named active colleagues on staging, each of these pickers shows them apart.