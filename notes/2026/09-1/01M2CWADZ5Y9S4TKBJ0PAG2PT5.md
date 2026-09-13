---
id: 01M2CWADZ5Y9S4TKBJ0PAG2PT5
created: 2026-09-13T07:57:14.085949Z
updated: 2026-09-13T09:25:36.576267Z
type: task
title: Remove "Protecting controls" from all three asset registers
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 698
sprint: skdc1az
comments:
- id: 01M2CYW0RX69ZXB2FZ14WZ9MZA
  author: Steve Vine
  at: 2026-09-13T08:41:47.5495Z
  text: |-
    Done — PR #706 merged to main (squash).

    Removed the feature, not just the card: the Protecting controls section on all three asset pages, the Protected assets section on a control, the /{id}/controls routes and /controls/{ref}/assets, the core helpers, the InventoryControlLink model and its audit entry, and the inventory_control_links table (migration 0197 logs how many links it drops). The guarded delete now counts risks, decisions and recipients. ADR 0072 §13 carries the dated amendment; schema.d.ts regenerated with no control-link paths. The IA brief never listed the section and the CSV templates never carried controls.

    Note: the migration revision id had to stay under Alembic's 32-character version column ("0197_drop_control_links"). Awaiting staging deploy with the rest of the sprint.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Requested by Steve, 2026-09-13: the **Protecting controls** section on technology, data and software asset detail pages goes. Controls are assessed per company against the whole estate; pinning individual controls to individual assets was a link nobody maintains.

**Remove the feature, not just the card** — a link table nothing can write to is debt:
* Frontend: the Protecting controls `LinkedRecordsCard` in `inventory/LinkCards.tsx` and its three call sites; the **Assets** card on the control detail page (`ControlDetailPage.tsx`, `ControlAssetsCard`); the `useAssetControls` / `useLinkAssetControl` / `useUnlinkAssetControl` / `useControlAssets` hooks; the portal never showed it.
* Backend: the `/{id}/controls` routes on all three routers; `linked_controls` / `link_control` / `unlink_control` / `controls_out` / `assets_for_control` in `core/inventory_links.py`; the control-count clause in `citation_reasons` (a guarded delete no longer counts control links); the `InventoryControlLink` model and `inventory_control_links` table dropped in a migration (append-only, one head) that logs how many links it removes; the `_AUDITED_TABLES` entry; the activity page's rendering of that table.
* CSV templates never carried controls — nothing to change. Global search unaffected.
* ADR 0072 §13 amended: links are risks, decisions and vendors; controls are out (with the one-line reason above). `brief/information-architecture.md` if it lists the section.
* Tests: delete the control-link tests; the detail page tests lose the section assertions; a guarded-delete test that relied on a control link switches to a risk link.

**Acceptance**: no Protecting controls section on any asset page, no Assets section on a control page, no control-link endpoints in the OpenAPI, and `schema.d.ts` regenerated without them.