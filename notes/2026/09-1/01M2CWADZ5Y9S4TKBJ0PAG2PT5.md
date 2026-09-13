---
id: 01M2CWADZ5Y9S4TKBJ0PAG2PT5
created: 2026-09-13T07:57:14.085949Z
updated: 2026-09-13T08:17:07.204527Z
type: task
title: Remove "Protecting controls" from all three asset registers
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 698
sprint: skdc1az
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Requested by Steve, 2026-09-13: the **Protecting controls** section on technology, data and software asset detail pages goes. Controls are assessed per company against the whole estate; pinning individual controls to individual assets was a link nobody maintains.

**Remove the feature, not just the card** — a link table nothing can write to is debt:
* Frontend: the Protecting controls `LinkedRecordsCard` in `inventory/LinkCards.tsx` and its three call sites; the **Assets** card on the control detail page (`ControlDetailPage.tsx`, `ControlAssetsCard`); the `useAssetControls` / `useLinkAssetControl` / `useUnlinkAssetControl` / `useControlAssets` hooks; the portal never showed it.
* Backend: the `/{id}/controls` routes on all three routers; `linked_controls` / `link_control` / `unlink_control` / `controls_out` / `assets_for_control` in `core/inventory_links.py`; the control-count clause in `citation_reasons` (a guarded delete no longer counts control links); the `InventoryControlLink` model and `inventory_control_links` table dropped in a migration (append-only, one head) that logs how many links it removes; the `_AUDITED_TABLES` entry; the activity page's rendering of that table.
* CSV templates never carried controls — nothing to change. Global search unaffected.
* ADR 0072 §13 amended: links are risks, decisions and vendors; controls are out (with the one-line reason above). `brief/information-architecture.md` if it lists the section.
* Tests: delete the control-link tests; the detail page tests lose the section assertions; a guarded-delete test that relied on a control link switches to a risk link.

**Acceptance**: no Protecting controls section on any asset page, no Assets section on a control page, no control-link endpoints in the OpenAPI, and `schema.d.ts` regenerated without them.