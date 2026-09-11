---
id: 01M293Z1H0B3WJCES8PTN449DP
created: 2026-09-11T20:53:51.776546Z
updated: 2026-09-11T21:43:39.882832Z
type: task
title: Inventory wording — "Containers" become "Technology Assets" everywhere on screen
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 674
sprint: skdc1az
comments:
- id: 01M296T76HFSGZVFQDFMYY04YN
  author: Steve Vine
  at: 2026-09-11T21:43:39.47326Z
  text: |-
    Done — PR #682 merged to main (a08729c).

    Every word on screen now says Technology Assets / Data Assets: tabs, titles, buttons, empty states, modals, column headers ("Technology assets" on the data list, "Technology assets holding this" on the data asset record), the portal, the dashboard tile, search labels, activity entity names, recert pickers, the Users page's assets section, role/permission descriptions, toasts, API error messages and OpenAPI descriptions. The CSV data-asset template column is now technology_assets and the technology asset template downloads as technology-assets-template.csv.

    Routes: /inventory/technology/:id and /portal/inventory/technology/:id, with the old /containers/ paths redirecting; new action links, search results and decision links use the new path. Identifiers unchanged (AST- refs, the containers table, /api/v1/containers, the container recert entity type). labels.ts carries the vocabulary. ADR 0072 §1 amended; IA brief Modules list updated.

    Ready for smoke on staging once the sprint's other five land.
assignee: steve
label:
- improvement
priority: high
task_status: review
---
Smoke finding, 2026-09-11: "Containers" confuses (it reads as Docker). The two registers are **Data Assets** and **Technology Assets**; every word on the screen realigns.

**Scope — the words, not the identifiers**
* Tabs: Inventory ▸ **Technology Assets** / **Data Assets**. Page titles, tab titles, headers, empty states, buttons ("Add technology asset"), modal titles, confirm dialogs, pills, table column headers ("Technology assets" count on the data list), the data-asset modal's *Held in* field ("Technology assets"), the *Data held* / *Technology assets holding this* sections, the portal Inventory tab, the dashboard tile, search result type labels, the activity page's entity names, CSV template headers and the import UI, recert schedule entity label, the Access Control user page's Assets section, the vendor/risk/decision/control detail link sections, settings card labels, notification/action text and email subjects.
* `labels.ts` is the one place the vocabulary is spelled; screen text that bypasses it gets pulled into it.
* **Routes**: `/inventory/containers/:id` → `/inventory/technology/:id` with a redirect from the old path (links in mail and actions already sent must keep working).
* **Identifiers stay**: `AST-` refs, the `containers` table, the `/api/v1/containers` router, model and type names, the `container` recert entity type. Renaming the API is churn with no user-visible gain; the OpenAPI *descriptions* and tags do change to the new words so the generated `schema.d.ts` drifts — run the drift script.
* Search index and any stored label text (e.g. action titles already written) — a data migration is not needed for identifiers; stored action titles from before the rename stay as written.
* **ADR 0072** gains an amendment note (§1): the register is called Technology Assets on screen; "container" survives as the code-level name. `brief/information-architecture.md` Modules list updated.
* Tests: the AppLayout nav test, screen-conventions tests and every inventory test that asserts on the old words.

**Acceptance**: no user-visible "container" anywhere in the internal app, the portal, mail or the CSV template; old links redirect; the API paths are unchanged.