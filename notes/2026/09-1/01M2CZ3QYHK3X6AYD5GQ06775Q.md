---
id: 01M2CZ3QYHK3X6AYD5GQ06775Q
created: 2026-09-13T08:46:00.657789Z
updated: 2026-09-13T08:46:16.517293Z
type: task
title: Data asset page — sections reordered; Access and Recertification added on the technology-asset model; Notes added; Technology assets renamed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 702
sprint: skdc1az
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Requested by Steve, 2026-09-13: the data asset detail page (`pages/DataAssetDetailPage.tsx`) reads in this order, every section full width:

1. **Record**
2. **Lifecycle**
3. **Access** — *new*, the same format as a technology asset's Access section
4. **Recertification** — *new*, the same format as a technology asset's
5. **Technology assets** (rename from "Technology assets holding this"; same content)
6. **Classification**
7. **Controlled data processing**
8. **Risks**
9. **Decisions**
10. **Notes** — *new field*
11. **Audit trail**

**Access on a data asset — the decision this task carries** (amends ADR 0072 §1/§7, which put access on technology assets only and made a data asset's access "its containers' access, read-only"). Steve wants access recorded on the data asset itself, in the same shape: a dataset such as a file share or a shared mailbox has holders that are not the holders of a server. So:
* A data asset carries its **own holders**: Entra groups from the mirror (effective members, direct and inherited distinguished) and a manual holder list (directory person or free text, access level, notes, `removal_pending`). Same components as the technology asset (`AccessCard`, the group picker, the manual list), parameterised by asset kind rather than copied.
* Storage: mirror the container tables — `data_asset_access_groups`, `data_asset_manual_holders` — with the same columns and audit treatment (or generalise both to `(asset_kind, asset_id)` polymorphic tables if that is cleaner than a second pair; decide in the PR, say why). Routes `/api/v1/data-assets/{id}/access-groups`, `/manual-holders`, `/holders`, gated as the container ones (`inventory.view` / `inventory.manage_access`).
* The section does **not** also list holders via technology assets — that is what the Technology assets section links to; mixing the two would double-count in recertification.
* Portal: data asset owners manage the manual list (as technology asset owners do); Entra group grants stay internal.

**Recertification on a data asset**: `recert_schedules.entity_type` gains `data_asset`; owners prefill from the data asset's owners; the trigger snapshots the data asset's combined holder list; attestation in the portal as today; removals by source exactly as COM-670 — group holders through the directory write path, manual holders as an Inventory action for the Inventory admins with the holder shown *removal pending*. The Recertification section (schedule summary, next due, last instance, Add/Edit) is the same component. Access ▸ Recertification ▸ Schedules lists them with the entity kind.

**Notes**: `data_assets.notes` (Text, nullable), last on the modal at the Description size (the COM-686 shape), editable in the portal, shown on the detail when present, an optional CSV column. Migration append-only, one head.

**Order and names**: today's page is Record · Classification · Technology assets holding this · Risks · Decisions · Lifecycle · Audit trail — so Lifecycle moves to second, the two new sections follow it, and the rename applies. The portal data asset page follows the same order for what it shows.

Tests: holders derivation for a data asset (group with nested member + manual), the routes and gates, recert trigger snapshot and both removal paths for `data_asset`, notes round-trip, the page's heading order, portal scope. Regenerate `schema.d.ts`. ADR 0072 §1, §7, §9 amended.

**Acceptance**: a data asset shows Access and Recertification sections that behave exactly like a technology asset's; a schedule on a data asset triggers, is attested in the portal and executes removals by source; Notes saves and shows; sections appear in the order listed.