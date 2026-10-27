---
id: 01M5Y9BR7WFH1SHD4DE62TX3BY
created: 2026-10-27T08:59:19.676448Z
updated: 2026-10-27T09:05:30.96775Z
type: task
title: Admin ▸ Integrations is a gallery of tiles — each platform's logo, name, what it's for and whether it's connected, with search, a category filter and Installed / All
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1348
sprint: s8fmesf
blocked_by:
- 01M5Y9BDEE2W7W432G1MVTMQB5
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 90, Integrations (ADR in COM-1347).

## What people see

- **An "Integrations" item in the Admin group** of the left-hand menu, under Admin and above Activity. The page is titled *Integrations*.
- **A grid of tiles**, one per platform. Each tile shows:
  - the platform's logo and name;
  - one line on what Compass uses it for (e.g. AWS: "Finds what runs in your AWS accounts for Inventory");
  - its category;
  - its state: **Connected**, **Needs attention** or **Not set up**.
- **Above the grid:**
  - a search box that matches name, purpose and category;
  - a category filter (Cloud, Identity & directory, Email, Storage, Security tools, Reference data);
  - a toggle between **Installed** (set up, the default when anything is) and **All**.
  - The counts match what each choice shows.
- **Clicking a tile** opens its page (COM-1349). The trail reads Admin ▸ Integrations ▸ AWS.
- **Before the tile tasks land**, each platform's tile links to where it is set up today. The gallery is useful from this task on.
- **Polaris is not in the gallery.** It stays on Admin ▸ Polaris (Steve, 2026-10-27).

## Who can see it

- Anyone holding any of these rights:
  - manage integrations;
  - Inventory admin;
  - manage configuration (attachments).
- Everyone who can see the gallery sees every tile. A tile they can't configure opens read-only.

## Notes (technical)

- `components/nav.ts`: a new Admin item gated on any of the three rights; route `/admin/integrations`.
- Tile list: a registry naming each integration's key, name, category, purpose line and logo. State comes from one endpoint that summarises every integration's health. That endpoint reads the existing health and sync columns; no new reads.
- Logos: the platforms' own marks as SVG in the frontend, used to name the product.
- Follow *Screen conventions*: pills never truncate; the page has no subtitle.

**Chain:** on the chain (API: the summary endpoint).

**Done when:**
- the gallery lists every platform Compass talks to today (except Polaris's AI providers), with a true state for each;
- search and the filters work;
- someone with none of the rights doesn't see the menu item and can't reach it by URL.