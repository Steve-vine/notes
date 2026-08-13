---
id: 01KZX7KYEH8RC1K5FE70TKXS2R
created: 2026-08-13T09:35:25.649213Z
updated: 2026-08-13T10:06:25.696933Z
type: task
title: A dashboard tile is called a Tile, not a Service
project: 01KX671DATY39VW6GWK3M2T3DN
number: 679
sprint: savn96w
comments:
- id: 01KZX9CJP7H9NJ3TMEEXHBRGG0
  author: Steve Vine
  at: 2026-08-13T10:06:21.383514Z
  text: |-
    Built and merged to main as PR #630 (b5e7fbf), CI green.

    The Dashboards screen says tile throughout: composer title and name field, create/update/delete notifications, delete confirmation and its button, the All-tiles tab, every empty state, and the drill-in's fallback label and not-found state. "Business Service" is untouched wherever it means the estate's top layer.

    The API, the table and the service identifiers deliberately did not change — a contract rename costs a migration and an api-types regen for no user benefit. A comment at the top of DashboardsPage.tsx records that, so the mismatch reads as a decision rather than a miss.

    The source-picker test now asserts both halves in one place: "New tile" as the composer's heading and "Business Services" as a group label. That is the exact collision this fixed, so a re-rename in either direction breaks a test rather than quietly restoring it.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
ADR 0053 named a dashboard tile a "service", and since [ISE-674] one can point at a **Business Service** — so the Dashboards screen now uses one word for two different things, in adjacent controls ("New service", and inside its modal a "Business Services" option group). Under the Collections banner that collision has to go: on the Dashboards screen a tile is a **Tile**.

**Scope — user-visible copy on Dashboards only**
- `pages/DashboardsPage.tsx`: "New service" → "New tile", "Service name" → "Tile name", the create/update/delete notifications ("Service created/updated/deleted"), the delete menu item and its confirmation, and the modal title.
- `pages/DashboardServicePage.tsx`: the drill-in fallback label and the "Service not found" empty state.
- Anywhere else the word reaches a user about a tile — sweep the dashboard screens and the wallboard, and check the Settings › Wallboard pane too.
- **Business Service** stays exactly as it is everywhere. The point of the rename is to stop the two colliding, so the phrase must survive untouched where it means the estate's top layer.
- Update the affected test assertions (`Dashboards.test.tsx`, `DashboardService.test.tsx`).

**Out of scope — deliberately:** the API and DB naming (`DashboardServiceRead`, `dashboard_service`, the `/dashboards/:serviceId` route param, `dashboard-services` endpoints). This is a copy change, not a contract change; renaming the API costs a migration and an api-types regen for no user benefit. Say so in the PR so the mismatch reads as a decision rather than a miss.

**Done when** the word "Service" appears on the Dashboards screens only where it means a Business Service.