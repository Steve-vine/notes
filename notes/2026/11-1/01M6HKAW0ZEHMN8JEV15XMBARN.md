---
id: 01M6HKAW0ZEHMN8JEV15XMBARN
created: 2026-11-03T20:59:10.751239Z
updated: 2026-11-04T00:22:15.256624Z
type: task
title: Initiatives in the menu below Actions — start an initiative (name, description, owner, target date), the Initiatives list, and the initiative page with its tabs; two new permissions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1554
sprint: snyzymp
blocked_by:
- 01M6HK9XH4C9SWTB3X48YKWPGS
- 01M6HKACNAZW0QKYH6H1EFMPKP
comments:
- id: 01M6HPY5KYV516KHHNQ7VWK17X
  author: Steve Vine
  at: 2026-11-03T22:02:08.893988Z
  text: |-
    Done: PR #1568 merged (15dea6dd), migration 0768.

    What's there:
    - **Initiatives** sits directly below Actions in Overview. It appears to people with View initiatives.
    - **The list** shows reference, name, owner, target date (red once passed while still Active), % complete, open actions and status.
      - "My initiatives" and "Active only" start on and are kept in the address.
      - % complete and open actions show a dash until COM-1559 and COM-1560 fill them.
    - **Start an initiative** (Manage initiatives): name and owner are required, the owner defaults to you, and description and target date are optional.
    - **The initiative page:**
      - its header shows owner, target date and % complete;
      - its tabs are Controls, Gaps, Risks, Decisions, Content and Actions, each saying what will appear;
      - Edit is offered to its owner or Manage initiatives, and never on a Complete or Cancelled one.
    - **Search** finds an initiative by INI reference or name.
    - **The trail** reads Initiatives ▸ INI-3 · Name.
    - **The activity log** records every change.
    - **Two permissions** in a new Initiatives group go to the built-in Admin only.

    My calls:
    - **The owner can always open their own initiative,** even without View initiatives, as a named auditor opens their audit. Anyone else without View initiatives is told it doesn't exist.
    - **INI numbers are global** (one sequence), as G-, R- and AUD- are. ADR 0140 said "per company"; this follows the existing references instead.
    - **If the owner's account is deleted, the initiative shows as unowned.** The owner is required on every form, but Compass never blocks deleting a user.
    - **The Browser smoke's menu check** expects Initiatives for Admin and not for Viewer.

    To test on staging (after the sprint deploys), in E2E Test Company:
    1. As admin, check Initiatives shows below Actions.
    2. Start "E2E initiative" with E2E Analyst as owner, then turn off "My initiatives": it's listed with them as owner.
    3. Open it and check it shows the six tabs.
    4. As E2E Viewer, check there's no Initiatives menu item.
- id: 01M6HYYPYR1KPR9EQ53FB1YRAV
  author: Steve Vine
  at: 2026-11-04T00:22:15.256333Z
  text: |-
    Pre-UAT (staging 9c0b06a2, 2026-11-04, E2E Test Company): **Passed** (through the API and the Browser smoke; the Playwright browser wasn't connected this session).

    Steps and what I saw:
    1. The Browser smoke went green after the deploy. Its menu check expects Initiatives for Admin and not for Viewer, and it crawled the Initiatives screen for every account that has it.
    2. As E2E Admin A, I started **INI-1 "E2E initiative"** with E2E Analyst as owner, target 3 Jan 2027. It's listed with E2E Analyst as owner.
    3. E2E Viewer opening INI-1: not found. Starting one: refused.
    4. E2E Analyst (the owner, with no Initiatives permissions) opens it and can edit it.

    For you to look at: the menu item below Actions, and the initiative page's header and six tabs.
assignee: steve
label:
- feature
priority: high
task_status: review
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