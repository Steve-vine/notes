---
id: 01M6HKAW0ZEHMN8JEV15XMBARN
created: 2026-11-03T20:59:10.751239Z
updated: 2026-11-03T21:19:34.066732Z
type: task
title: Initiatives in the menu below Actions — start an initiative (name, description, owner, target date), the Initiatives list, and the initiative page with its tabs; two new permissions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1554
sprint: snyzymp
blocked_by:
- 01M6HK9XH4C9SWTB3X48YKWPGS
- 01M6HKACNAZW0QKYH6H1EFMPKP
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint "Initiatives - New Feature" (ADR 0140, COM-1552). This task is the frame. The tabs are filled by the tasks that follow.

## What people see

- **Menu:** **Initiatives** sits directly below Actions in Overview. It carries the Company gate, and shows only to people with *View initiatives*.
- **Initiatives list.** One row per initiative in the selected company, showing:
  - reference (INI-N) and name;
  - owner;
  - target date (red once it has passed while still Active);
  - percentage complete (a dash until COM-1560 lands);
  - open actions;
  - status (Active, Complete, Cancelled).

  "My initiatives" and "Active only" are filters, both URL-backed, both on by default. The list is sortable and follows the screen conventions.
- **Start an initiative** (needs *Manage initiatives*). Name and owner are required, the owner being any internal user who can see the company. Description and target date are optional. The owner defaults to you.
- **The initiative page:**
  - **Header:** reference, name, status pill, owner, target date and percentage complete.
  - **Tabs:** Controls, Gaps, Risks, Decisions, Content and Actions. Each says what will appear there until it has something.
  - **Edit** (name, description, owner, target date) is open to the owner and to anyone with *Manage initiatives*.
- **Wiring:**
  - Breadcrumbs: Initiatives ▸ INI-3 · Ransomware readiness.
  - Global search finds initiatives by reference and name.
  - Every change is in the activity log.

## Who can do what

- *View initiatives*: see the menu item, the list and every initiative in the company.
- *Manage initiatives*: start one, and edit any.
- The owner can edit their own without *Manage initiatives*.
- The built-in Admin gets both permissions. The starter roles stay frozen. Add a permission group, "Initiatives".

## Notes (technical)

- Company-scoped tables: `initiatives` (number unique per company, name, description, owner_id NOT NULL, target_date, status enum, completed_at) and the soft-delete, actor and timestamp mixins.
- Add the table to `_AUDITED_TABLES`, and create the enum explicitly in the migration.
- Ref prefix `INI`, spelt once, like `DECISION_REF_PREFIX`.
- Add the nav item to `nav.ts` between Actions and Reports, with `gate: 'Company'` plus the permission. Add the trail route.
- Register the screens and tabs in the Browser smoke for the test accounts.

**Chain:** on the chain (migration + API).

**Done when:** on staging in E2E Test Company:
- as admin, Initiatives shows below Actions;
- starting "E2E initiative" with E2E Analyst as owner lists it with them as owner;
- its page shows the six tabs;
- E2E Viewer (no Initiatives rights) sees no menu item.