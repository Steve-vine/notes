---
id: 01KZVCPB1R7YSBBHR6T2PNQ052
created: 2026-08-12T16:25:38.104724Z
updated: 2026-08-12T16:26:45.777751Z
type: task
title: version-cve findings have empty cve_ids column (engine buries it in meta + V1 ingest drops it)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 170
sprint: s3ry03w
assignee: steve
imported_from: linear
label:
- bug
priority: high
task_status: done
---
## Summary

`version-cve` findings land with an **empty** `Finding.cve_ids` **column** (`[]`) even though the CVE id is in the title and `meta.cve_ids`. Anything keyed on the structured column — CVE badges (`cve-badges.tsx`), KEV/EPSS enrichment display, finding correlation, cve_ids filtering — sees nothing.

Found verifying DEV-692 on dev (2026-06-27): a "CVE Detection" run produced **1,028** findings (titles `CVE-2026-28780: …`, severities correct) but every row has `cve_ids = []`.

## Two contributing causes

1. **Engine** (`app/scanners/version-cve/.../runner.py::_finding_for_cve`): puts `cve_ids` inside the `meta` dict only — it does **not** pass the top-level `cve_ids=[cve_id]` argument that `emit_finding` / `FindingEventV1` support (`packages/redvektor-engine-python/.../protocol.py:223,809`). So the emitted event's top-level `cve_ids` defaults to `[]`.
2. **Ingest** (`app/backend/src/redvektor_api/tasks/workflow_runs.py:~1862-1876`): `# Brief 075: V1 findings have no cve_ids (a legacy-only field)` → `cve_ids = event.cve_ids if isinstance(event, FindingEvent) else []`. For V1 findings (`FindingEventV1`) it hardcodes `[]` — a stale assumption from before V1 gained a `cve_ids` field. So even if the engine set it, ingest would drop it.

## Fix

* **Engine:** pass `cve_ids=[cve_id]` to `emit_finding` (top-level), in addition to / instead of `meta.cve_ids`.
* **Ingest:** populate `Finding.cve_ids` from `event.cve_ids` for V1 findings too (drop the legacy-only branch; read the V1 field). Backfill consideration for already-ingested rows is optional (re-run repopulates).
* Re-verify on dev: a `version-cve` run yields findings whose `cve_ids` column is populated and whose CVE/KEV/EPSS badges render.

## Acceptance criteria

* V1 `version-cve` findings persist `cve_ids` (the column matches the title's CVE).
* CVE badges + KEV/EPSS enrichment render on those findings in the UI.
* Tests: ingest maps `FindingEventV1.cve_ids` → `Finding.cve_ids`; engine emits top-level `cve_ids`.

## Notes

Distinct from DEV-692 (CPE 2.2 parse — fixed, findings now appear). This is the next layer: the findings appear but their structured CVE linkage is empty. The data isn't lost (it's in `meta.cve_ids`), so it's a mapping fix, not re-scan-for-data.

---

Imported from Linear [DEV-693](https://linear.app/stevevine/issue/DEV-693/version-cve-findings-have-empty-cve-ids-column-engine-buries-it-in)