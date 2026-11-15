---
id: 01M7F9PWFWMQYRMD8CQ9R7XY1S
created: 2026-11-15T09:48:11.644097Z
updated: 2026-11-15T14:29:27.108832Z
type: task
title: Integrations has two tabs, Collection first, then Core
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1843
sprint: spsp226
comments:
- id: 01M7FHN3V3ZYHQ2H6PGYBZ1F8F
  author: Steve Vine
  at: 2026-11-15T12:07:02.243562Z
  text: |-
    Built and merged — PR #1838 (d63a1d8c). Screens only.

    - Admin ▸ Integrations has two tabs, **Collection (n) | Core (n)**, and opens on Collection.
    - **Collection tab:** its tiles, Installed / All and search. The header has Internal addresses, Add a Collection integration and Add with Polaris.
    - **Core tab:** its tiles, Installed / All, search and the Category filter (no longer offering Collection). The mail catcher card and the "Built into Compass…" hint sit under it.
    - Each tab has its own search and Installed / All, and its count follows its own Installed / All.
    - The tab is kept in the address (?tab=core), so a reload or link keeps it.
    - **Old links still work:** ?category=collection opens Collection. Old Core links, such as ?category=email from System status or Inventory, open Core filtered as they ask.
    - Roles that can see Integrations but not manage it get both tabs without the Add buttons, as before.
    - Browser smoke now has an explicit step: the page opens on Collection, then Core is picked and kept in the address. That step first runs for real on this staging deploy.
    - Tests: Vitest for the tabs, counts, moved actions and old links. screen-conventions passes.
- id: 01M7FSSWE4GT8M64EZTQKGWN7K
  author: Steve Vine
  at: 2026-11-15T14:29:27.10862Z
  text: |-
    **Passed** (one part **Couldn't check**). Pre-UAT, staging build 20261115-1354 (36d3de6c), E2E Test Company.

    As E2E Admin A:
    - **Opening the page:** Admin ▸ Integrations opens on **Collection (7) | Core (6)**, with Collection selected.
    - **Collection tab:**
      - 7 tiles; Installed 7 / All 7; search.
      - The header has Internal addresses, Add a Collection integration and Add with Polaris. They aren't shown on the Core tab.
    - **Core tab:**
      - "Built into Compass. They arrive with a release." sits under the tab, with the Mail catcher card.
      - Installed 6 / All 10, search and Category.
      - The Category menu offers All, Cloud, Identity & directory, Email, Storage and Reference data. It no longer offers Collection.
    - **Counts:** picking All on Core changes the tab to **Core (10)** (address ?tab=core&core_show=all). Collection stays at 7.
    - **Searches are kept apart:** searching "git" on Collection shows 1. Core's search stays empty and shows 6. Back on Collection, "git" is still there.
    - **Reload:** reloading ?tab=core&core_show=all stays on Core (10).
    - **Old links:**
      - /admin/integrations?category=collection opens on the Collection tab.
      - /admin/integrations?category=email opens Core with Category = Email (SendGrid only).

    Couldn't check, a role that can see Integrations but can't manage it:
    - No test account has such a role. On staging the only role holding any of "manage integrations", "administer the inventory" or "manage configuration" is Admin, and Admin holds all three.
    - E2E Analyst (and every role but Admin) gets "You need permission to manage integrations, Inventory or configuration to see this." That's the same as before.
    - To see it, Steve would need a custom role with only "Administer the inventory" or "Manage configuration". It should see both tabs, Internal addresses only with "Manage configuration", and no Add buttons.

    Minor, not a defect: switching tabs leaves an old ?category=collection in the address. It does no harm.

    Screenshots: ~/compass-uat/spsp226/COM-1843/
assignee: steve
label:
- improvement
priority: low
task_status: review
---
## What happened

Steve, testing Integrations (2026-11-15): Admin ▸ Integrations shows every integration on one page, Core tiles first and then Collection tiles, under two headings, with Collection also offered as a category in the filter (`integrations/IntegrationsPage.tsx`). He wants them on separate tabs, Collection first.

## What people see

- **Two tabs under the Integrations header: Collection (n) | Core (n).** Collection is first and is where the page opens. The tab is kept in the address, so a link can open either one.
- **Collection tab:**
  - the Collection tiles;
  - Installed / All and search;
  - in the header, Add a Collection integration, Add with Polaris and Internal addresses (internal addresses are approved for Collection definitions).
- **Core tab:**
  - the Core tiles;
  - Installed / All, search and the Category filter, which no longer offers "Collection";
  - the mail catcher card, which is about Core mail.
  - The "Built into Compass. They arrive with a release." hint moves to sit under the tab.
- **Each tab's counts are its own.** Each tab keeps its own search and filters, and the tab counts follow the Installed / All choice.
- **Old links still work.** An old link with `?category=collection` opens the Collection tab, and the Core detail pages and Collection pages are unchanged.
- With COM-1841, the "Can change things" / "Read only" grouping applies inside the Core tab. Everything on the Collection tab is read only.

## Done when

- On staging, Admin ▸ Integrations opens on Collection, with its tiles and actions. Core shows the core tiles with the Category filter. The counts are right on each tab.
- A reload keeps the tab, and an old `?category=collection` link lands on Collection.
- A role that can see Integrations but not manage it sees both tabs without the Add buttons, as now.
- Vitest updated for the tabs, counts and the moved actions. `screen-conventions.test.ts` still passes, and the Browser smoke covers both tabs.

**Independent** (screens only, no API or migration). Related: COM-1841, whose grouping should be built inside the Core tab.