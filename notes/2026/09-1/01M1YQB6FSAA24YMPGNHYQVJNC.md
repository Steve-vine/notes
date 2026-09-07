---
id: 01M1YQB6FSAA24YMPGNHYQVJNC
created: 2026-09-07T20:00:54.265243Z
updated: 2026-09-07T20:00:54.265243Z
type: task
title: 'Access Control lists sort: the tabs the directory sweep missed'
assignee: steve
label: feature
task_status: todo
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 613
---
Users, Groups and Devices already sort — COM-272 built the treatment there and this sprint borrows it. Every other Access Control tab still has plain headings. This task finishes the section.

## Pages

- `access/RolesPage.tsx` and `access/RoleDetailPage.tsx` — business roles and their members
- `access/DirectoryRolesPage.tsx` and `access/DirectoryRoleDetailPage.tsx` — Entra directory roles and their holders
- `access/RequestsPage.tsx` — access requests
- `access/RecertPage.tsx` and `access/RecertCampaignPage.tsx` — recertification campaigns and their reviews
- `access/ValidationPage.tsx` — validation findings
- `access/CoveragePage.tsx` — coverage
- `access/ConditionalAccessPage.tsx` — conditional access policies
- `access/ReportLibraryPage.tsx` and `access/ReportDetailPage.tsx` — the report library and a report's results
- `access/ReportWizardPage.tsx` — the field/subject picker tables

## Notes

- **The report library pages on the server** — use the server-side `SortState` path with the `order_by`/`direction` parameters added by *Sorting the long lists*, exactly as `UsersPage`/`GroupsPage`/`DevicesPage` already do. Everything else on this list sorts client-side.
- A **report's results** are a typed subject/field catalogue (ADR 0062) — the columns are whatever the definition selected, so the sort has to be driven by the column metadata rather than a hand-written per-column table.
- Provenance and exception columns sort by rank, with "unattributed" grouped together rather than scattered alphabetically — an unexplained membership is the thing a reviewer is hunting for.
- `RecertPage` carries the known parallel-test flake (see the vitest flake note): if its tests get slower, prove any failure against clean `main` before chasing it.

Tests: reorder / reverse / `aria-sort` on the higher-traffic tabs (Roles, Requests, Recertification, Report library), not on all twelve.
