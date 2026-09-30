---
id: 01M3ST3SMX44ZMN8DNQZ9MADFQ
created: 2026-09-30T18:44:28.957306Z
updated: 2026-09-30T18:47:21.543121Z
type: task
title: Access Control, redesigned — roles (searchable by role or group), requests, validation, recertification and coverage
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 807
sprint: s0zzctz
blocked_by:
- 01M3ST04QGV1F3BH3F9J4XDZXK
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The prototype's Access roles screen, plus the Access tabs that are about roles and the work around them. The directory views, reports and Access admin follow in their own task.

## What people see

- **Header:** "Access Control", with **New role** on the right (for those allowed, as today).
- **Tabs:**
  - first: Roles, Requests, Validation, Recertification, Coverage and Reports;
  - then **More ▾** with Access Graph, Users, Groups, Shared Mailboxes, Devices, Directory Roles, Conditional Access and Admin, each with its icon.
  - On narrower screens more tabs fold into More.
  - Tab names are today's names.
  - Who sees which tab is unchanged.
- **Roles:**
  - **Search roles or groups.** A role matches by its name. A role also matches when one of its groups does, and then only the matching groups show.
  - Filter by **Owner**. On the right, "6 roles · 48 groups" and **Show disabled**.
  - Each role shows its name as a link, its description (two lines), its owner (avatar and name), and its directory groups as chips.
    - The first eight chips show, then **+n more**, which expands to all with **Show fewer**.
    - Under the chips, "34 groups", and the status (Active or Disabled; disabled roles are faded).
  - Narrow screens put the groups under the role and the owner under the description.
  - "No roles match." when the search finds nothing.
- **A role's page:** detail layout, with its description, owner and status in the header.
  - The groups it grants are in the main column, each with its type pill as today.
  - People holding it, reviews and history are in their existing places, re-dressed.
- **Requests** (list and a request's page), **Validation**, **Recertification** (list, a campaign's page, a schedule instance) and **Coverage** use the kit's filter bar, chips where today there are status filters, and lists.
- **The person, group, device and policy pop-ups** keep their addresses (`?user=` …) and trail behaviour, in the new look.

## Notes (technical)

- **Where.** `pages/AccessControlPage.tsx` holds the tabs as nested routes. Put the kit's tab bar there, with overflow mapped onto the existing child routes; the URLs don't change.
- **Roles search.** Client-side over the roles payload, which already carries groups. Add a `q` query-state param (COM-792).
- **Pages:**
  - `access/RolesPage.tsx`, `RoleDetailPage`;
  - `RequestsPage`, `RequestDetailPage`;
  - `ValidationPage`;
  - `RecertPage`, `RecertCampaignPage`;
  - `CoveragePage`.
- **Pop-ups.** Keep `access/popupParam.ts` as it is.
- **Ratchet.** Empty these pages' entries from the page-header ratchet.
- **Tests:**
  - roles search by role name and by group name (only matching groups shown);
  - +n more / Show fewer;
  - tabs folding into More without changing routes.
- **Flakes.** Mind [[frontend-vitest-parallel-flake]] (RecertPage).

**Done when:** on staging, searching Roles for a group name finds every role that grants it, and every tab listed here is in the new layout.