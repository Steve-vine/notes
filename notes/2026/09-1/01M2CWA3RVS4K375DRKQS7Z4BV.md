---
id: 01M2CWA3RVS4K375DRKQS7Z4BV
created: 2026-09-13T07:57:03.643664Z
updated: 2026-09-13T08:25:27.269957Z
type: task
title: Data asset status gains Cold storage
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 697
sprint: skdc1az
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Requested by Steve, 2026-09-13: a data asset's lifecycle needs **Cold storage** — data kept but no longer in active use (archive, retention hold) — alongside Live.

* `DataAssetStatus` gains `cold_storage`; the Postgres enum `data_asset_status` gains the value (append-only migration, one head). Display order: In build · Live · **Cold storage** · Deprecated · Decommissioned.
* Transitions (`DATA_ASSET_STATUS_TRANSITIONS` and the `labels.ts` mirror): `live → cold_storage`, `cold_storage → live | decommissioned`, `deprecated → cold_storage` as well as its existing moves. In build cannot go straight to cold storage (nothing was ever live).
* Surfaces: the create modal's Status choice (Live / In build stays — cold storage is a transition, not a starting state), the detail page's transition menu, the list's Status filter and pill (a cool grey/blue pill, not the deprecated amber), the CSV importer's `status` column accepts `cold_storage`, the dashboard tile counts it as live data for classification purposes (cold data is still held data — a Restricted data asset in cold storage still makes its technology assets Restricted).
* Review cadence: cold-storage assets are still reviewed (retention decisions are exactly what a review of archived data is for).
* Technology assets are not changed — cold storage is a property of data, not of a system. ADR 0072 §6 one-line amendment.

Tests: the transitions allowed and refused, the pill and filter, derived classification through a cold-storage asset, importer acceptance.

**Acceptance**: a live data asset can be moved to Cold storage and back; the list filters on it; a Restricted data asset in cold storage still classifies its technology assets Restricted.