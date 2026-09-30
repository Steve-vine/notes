---
id: 01M3ST53ASBC2R4NQ3Y2P1FXY0
created: 2026-09-30T18:45:11.641205Z
updated: 2026-09-30T23:31:32.481071Z
type: task
title: Inventory in the new layout — the three registers, and a technology, data or software asset's page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 811
sprint: s0zzctz
blocked_by:
- 01M3ST04QGV1F3BH3F9J4XDZXK
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The information asset register, in the prototype's patterns, laid out like Vendors. Nothing it does changes.

## What people see

- **Inventory:**
  - page header with **New asset**;
  - tabs Technology, Data and Software, each with its count;
  - chips per register (e.g. Production / Non-production, sensitivity, support ending);
  - the filter bar;
  - a list with the asset's name, owner, status, sensitivity or environment pills, and review date.
- **A technology asset's page:**
  - detail layout, with fact cards (environment, RTO/RPO, owner, status);
  - Access (the one list of role · description · type · account), data held and linked risks in the main column;
  - Lifecycle, owners and review in the side column.
- **A data asset's page:** the same layout, with lawful basis, data entities and where it's held.
- **A software asset's page:** the same layout, with its SFT id, licence model and support dates.
- **The asset pop-ups** (new and edit) take the new look. Their fields and row alignment are unchanged.

## Notes (technical)

- **Pages:**
  - `pages/InventoryPage`;
  - `ContainerDetailPage` (technology) and its nested route;
  - `DataAssetDetailPage`, `SoftwareAssetDetailPage`;
  - the `inventory/` modals.
- **Chips.** They map to filters that already exist. Don't add new ones here.
- **Keep:**
  - `/inventory?tab=data` and the other tab URLs;
  - the natural-home trail mapping (ADR 0084).
- **Ratchet.** Empty these pages' entries from the page-header ratchet.

**Done when:** on staging, Inventory and all three asset pages are in the new layout.