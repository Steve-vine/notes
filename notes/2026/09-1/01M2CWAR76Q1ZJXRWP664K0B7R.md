---
id: 01M2CWAR76Q1ZJXRWP664K0B7R
created: 2026-09-13T07:57:24.582788Z
updated: 2026-09-13T09:26:11.6197Z
type: task
title: Linking a risk to a software asset fails with "Data asset not found" — the frontend sends software to the data asset endpoint
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 699
sprint: skdc1az
comments:
- id: 01M2CXX6FVXW4038DJCZ7TM8KX
  author: Steve Vine
  at: 2026-09-13T08:24:57.595485Z
  text: |-
    Done — PR #705 merged to main (squash).

    The three risk-link hooks branched on `kind === 'container'` and sent every other register to the data-asset routes. Replaced with one dispatch table keyed on InventoryAssetKind (list/link/unlink per register), so a fourth register cannot compile without an entry. Decision links already went through the polymorphic /decisions/{n}/links and knew all three kinds; the control-link hooks had the same two-way branch but are deleted outright by COM-698.

    Tests: a hook test per kind asserting the exact routes; a software detail page test that links and unlinks a risk. Awaiting staging deploy with the rest of the sprint.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Smoke finding, 2026-09-13 (Steve): on a software asset, **Link risk** answers "Data asset not found".

**Cause** (frontend, `inventory/hooks.ts`): `useAssetRisks`, `useLinkAssetRisk` and `useUnlinkAssetRisk` branch on `kind === 'container' ? /containers/… : /data-assets/…` — written for two registers (COM-667) and never widened when the third arrived (COM-693 added the backend routes `/api/v1/software-assets/{id}/risks` but not the hook branch). A software id is therefore posted to `/data-assets/{id}/risks`, which correctly answers 404 with the data-asset wording. Check the decision-link and vendor-link hooks for the same two-way branch while there — anything that dispatches on kind must know all three.

**Fix**
* One dispatch, in one place: a `riskLinkPath(kind)` (or a small table `{ container: '/api/v1/containers/{container_id}/risks', data_asset: …, software_asset: … }`) used by all three hooks, typed against `InventoryAssetKind` so a fourth register cannot compile without an entry (`Record<InventoryAssetKind, …>`, not a ternary).
* Same for any other hook found with the two-way branch (decisions use the polymorphic `/decisions/{n}/links` with `target_type`, so they are probably fine — verify).
* The **Risks** card on the software detail page and the software rows in the risk detail's assets section then work end to end.

Tests: a hook test per kind asserting the path called (the existing hook tests presumably only cover container and data asset — add software); a software detail page test that links and unlinks a risk.

**Acceptance**: linking and unlinking a risk on a software asset works; the risk's detail lists the software asset; the same for the technology and data assets still works.