---
id: 01M1YQB6FSAA24YMPGNHYQVJNC
created: 2026-09-07T20:00:54.265243Z
updated: 2026-09-07T23:14:27.062486Z
type: task
title: 'Access Control lists sort: the tabs the directory sweep missed'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 613
sprint: sa2t9sq
blocked_by:
- 01M1YQ9HPHK8C1QK2GFV1CYVBM
- 01M1YQ9X2BGPQ01BW0TXNP4KT6
comments:
- id: 01M1Z2DJG1AP056SNNEG6SEHWR
  author: Steve Vine
  at: 2026-09-07T23:14:26.433076Z
  text: |-
    Done — PR #627 merged to main.

    - Business roles (name, owner by name — unowned last, groups by count, status) and a role's holders (person, since, how — no request recorded last).
    - Directory roles (name, custom before built-in, people) and a role's applications and holders (origin as it reads, direct before via-group, active holdings before eligible).
    - Access requests: kind, subjects, requester by name, mode (expedited first), status by lifecycle (ACCESS_REQUEST_STATUS_ORDER — waiting on somebody first, done, then ended), raised as a date.
    - Recertification: schedules (cadence by frequency, next due as a date with none last, enabled first), instances (overdue → open → completed), an instance's items (undecided → flagged → certified), and a campaign's reviews (RECERT_ITEM_STATUS_ORDER, reviewer by name, unattested last). RecertPage's known flake did not bite; its tests ran clean locally and in CI.
    - Validation queue, Coverage proposals, Conditional access policies (state on → report-only → off; requires blocks → MFA → nothing; everyone first) and exclusions — an exclusion nobody has explained is blank on Why, so the unexplained ones group together rather than scattering.
    - Report library sorts on the server through order_by/direction (COM-609), exactly as the directory tabs do; one sort state serves both halves since they are one list split on a heading. "Question it answers" is not orderable server-side and is marked.
    - A report's answer sorts by its column metadata: access/reportSort.ts maps the catalogue's field type (number, date, boolean, text/enum/reference) to a sort kind, an unread "Unknown" cell blank — when the whole answer is on screen. A paged answer keeps the definition's own order (reordering one page would be a lie about the rest) and its headings say so. The run history sorts. The wizard's ten-row preview is a peek, not a list, and is marked.

    Tests: Roles, Requests, Recert schedules, Report library (order_by/direction sent, both halves show one chevron). The full Access suite (25 files, 268 tests) passes.
assignee: steve
label:
- feature
priority: medium
task_status: review
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
