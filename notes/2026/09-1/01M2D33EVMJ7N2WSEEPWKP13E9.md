---
id: 01M2D33EVMJ7N2WSEEPWKP13E9
created: 2026-09-13T09:55:45.652395Z
updated: 2026-09-14T18:59:44.728143Z
type: task
title: Status leaves the asset modals — assets are created Live and change state only from the Lifecycle box; In build becomes Offline (technology) and goes (data)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 705
sprint: skdc1az
blocked_by:
- 01M2CZ3ZP72XMDG26MTS9FVHAV
comments:
- id: 01M2D7K8TV7N3E145HC6FTSP9Z
  author: Steve Vine
  at: 2026-09-13T11:14:18.075704Z
  text: |-
    Done — PR #712 merged to main (squash).

    Status is never set on a form. The New and Edit modals of technology and data assets have no Status control; an asset is created Live and changes state only from the Lifecycle box by a dated transition (Decommission still behind a confirm). Technology assets: Live · Offline · Deprecated · Decommissioned. Data assets: Live · Cold storage · Deprecated · Decommissioned. Any working state moves to any other or to Decommissioned, which is terminal. In build is gone from both; existing In build technology assets now read Offline, In build data assets read Live (move any to Cold storage deliberately). The CSV templates lose the status column (a file carrying it is told why; everything imports Live). List filters, pills and the dashboard tile use the new sets. The software Lifecycle box (COM-703) shows the derived support state and Delete. ADR 0072 §6 amended.

    Smoke: open New technology asset / New data asset and confirm there is no Status; create one and see it read Live; check the Lifecycle buttons on each register.
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Smoke finding, 2026-09-13 (Steve), on COM-697: the New data asset modal still offers Live / In build (COM-697 left `DataAssetModal.tsx` untouched), and on technology assets the modal offers In build but the Lifecycle box cannot return to it — the modal and the Lifecycle box disagree about what a status is. Steve's simplification: **status is never set on a form**. An asset is created Live; its state changes only from the Lifecycle box, by a deliberate, dated transition.

**Modals**: the Status control is removed from the New and Edit modals of technology and data assets (software has none). Create always writes `live`. The portal edit forms never had it.

**Technology assets** — `ContainerStatus` becomes **Live · Offline · Deprecated · Decommissioned**. `in_build` is retired: `offline` is added to the enum (the Postgres value `in_build` stays — cannot be dropped — but the API stops offering it and `labels.ts` lists four). Transitions: any of Live / Offline / Deprecated may move to any other of the three or to Decommissioned; Decommissioned is terminal. Migration maps `in_build` → `offline`, logged with the count.

**Data assets** — `DataAssetStatus` becomes **Live · Cold storage · Deprecated · Decommissioned**. `in_build` retired the same way; transitions: any of the three non-terminal states to any other or to Decommissioned; Decommissioned terminal. Migration maps `in_build` → `live` (an asset "in build" is the least wrong as Live; there is no data equivalent of Offline), logged with the count so owners can move any to Cold storage.

**Software assets** — no typed status, as COM-695 decided: the Lifecycle box (COM-703) shows the derived support state — *Mainstream support · Extended support · Out of support* — and **Delete** is the only action. Nothing to add here beyond confirming the box reads that way once COM-703 lands.

**Everything that reads a status**: the Lifecycle box's transition buttons offer exactly the moves above, with Decommission still behind a confirm; list Status filters and pills list the new sets (Offline gets a grey pill, Cold storage the cool blue from COM-697); the dashboard tile's counts by status; the review-due exemption still applies to Decommissioned only; the CSV templates **lose the `status` column** for both registers (everything imports as Live; a file carrying the column gets a row error naming the change); `CONTAINER_STATUS_TRANSITIONS` / `DATA_ASSET_STATUS_TRANSITIONS` and their `labels.ts` mirrors are the single source of the allowed moves. Search unaffected.

**ADR 0072 §6** rewritten: created Live; four states per register named above; Decommissioned terminal; software has no typed state.

Tests: create writes Live regardless of body (a `status` in the create body is refused with 422 — not silently ignored); each allowed and refused transition per register; the migration's mappings and logs; both modals have no Status control; importer rejects the column; filters and tile with the new sets. Regenerate `schema.d.ts`.

**Acceptance**: neither New/Edit modal shows Status; a new technology or data asset reads Live; the technology Lifecycle box offers Offline / Deprecated / Decommission and the data one Cold storage / Deprecated / Decommission; existing In build technology assets read Offline; the software Lifecycle box shows the derived support state and Delete.