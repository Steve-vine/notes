---
id: 01M2CZ3QYHK3X6AYD5GQ06775Q
created: 2026-09-13T08:46:00.657789Z
updated: 2026-09-14T18:59:41.070436Z
type: task
title: Data asset page — sections reordered; Access and Recertification added on the technology-asset model; Notes added; Technology assets renamed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 702
sprint: skdc1az
blocked_by:
- 01M2D04FXYNZVGHNE8T1W6W8V5
comments:
- id: 01M2D8P5WG0B58Q1PH6GXXJ9ZY
  author: Steve Vine
  at: 2026-09-13T11:33:21.936013Z
  text: |-
    Done — PR #713 merged to main (squash).

    The data asset page reads Record · Lifecycle · Access · Recertification · Technology assets · Classification · Controlled data and processing · Risks · Decisions · Notes · Audit trail. Access and Recertification are the data asset's own, on the technology-asset model: the same Access table and Add access modal (Group / User / Local rows; owners keep User and Local in the portal), and the same Recertification section — a schedule on a data asset prefills its owners, snapshots the data asset's holders with their roles, is attested in the portal and removes by source (group through Entra; user/local as an Inventory action for the admins, confirmed from the data asset). The section does not also list holders via technology assets; that is what the Technology assets section (renamed) links to. Access ▸ Recertification lists data asset schedules with the entity kind and the schedule modal offers Data asset as an entity type. Notes is the last field on the modal, editable in the portal, shown when present, an optional CSV column. The portal data asset page follows the same order for what it shows. ADR 0072 §1, §7, §9 amended.

    One name kept: the processing section stays "Controlled data and processing" (its COM-688 name) since the task only called out the Technology assets rename — say if you want it shortened.

    Smoke: on a data asset add a User and a Local row, expand a Group row, add a schedule and trigger it from Access ▸ Recertification; edit Notes.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Requested by Steve, 2026-09-13: the data asset detail page (`pages/DataAssetDetailPage.tsx`) reads in this order, every section full width:

1. **Record**
2. **Lifecycle**
3. **Access** — *new*, the same format as a technology asset's Access section **as reworked by COM-704** (one editable list: role · role description · type Group / User / Local · account)
4. **Recertification** — *new*, the same format as a technology asset's
5. **Technology assets** (rename from "Technology assets holding this"; same content)
6. **Classification**
7. **Controlled data processing**
8. **Risks**
9. **Decisions**
10. **Notes** — *new field*
11. **Audit trail**

**Access on a data asset — the decision this task carries** (amends ADR 0072 §1/§7, which put access on technology assets only and made a data asset's access "its containers' access, read-only"). Steve wants access recorded on the data asset itself: a dataset such as a file share or a shared mailbox has holders that are not the holders of a server. So:
* A data asset carries its **own access entries** in the COM-704 table (`asset_access_entries` with `asset_kind = data_asset`) — no new tables; the same Access card, add-access modal, holders roll-up and `/access` + `/holders` routes, mounted under `/api/v1/data-assets/{id}/…`, gated as the technology asset's (`inventory.view` / `inventory.manage_access`).
* The section does **not** also list holders via technology assets — that is what the Technology assets section links to; mixing the two would double-count in recertification.
* Portal: data asset owners manage User and Local rows; Group rows stay internal, as on technology assets.

**Recertification on a data asset**: `recert_schedules.entity_type` gains `data_asset`; owners prefill from the data asset's owners; the trigger snapshots the data asset's holders roll-up (holder · role · source); attestation in the portal as today; removals by source exactly as COM-704 defines — a holder from a Group row through the directory write path, a User or Local row as an Inventory action for the Inventory admins with the entry shown *removal pending*. The Recertification section (schedule summary, next due, last instance, Add/Edit) is the same component. Access ▸ Recertification ▸ Schedules lists them with the entity kind.

**Notes**: `data_assets.notes` (Text, nullable), last on the modal at the Description size (the COM-686 shape), editable in the portal, shown on the detail when present, an optional CSV column. Migration append-only, one head.

**Order and names**: today's page is Record · Classification · Technology assets holding this · Risks · Decisions · Lifecycle · Audit trail — so Lifecycle moves to second, the two new sections follow it, and the rename applies. The portal data asset page follows the same order for what it shows.

Tests: access entries of each type on a data asset and the holders roll-up (group with nested member), the routes and gates, recert trigger snapshot and both removal paths for `data_asset`, notes round-trip, the page's heading order, portal scope. Regenerate `schema.d.ts`. ADR 0072 §1, §7, §9 amended.

**Acceptance**: a data asset shows Access and Recertification sections that behave exactly like a technology asset's; a schedule on a data asset triggers, is attested in the portal and executes removals by source; Notes saves and shows; sections appear in the order listed.