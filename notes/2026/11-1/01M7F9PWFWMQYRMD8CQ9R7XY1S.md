---
id: 01M7F9PWFWMQYRMD8CQ9R7XY1S
created: 2026-11-15T09:48:11.644097Z
updated: 2026-11-15T10:58:03.809403Z
type: task
title: Integrations has two tabs, Collection first, then Core
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1843
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: active
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