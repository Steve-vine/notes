---
id: 01KZVFBSB16HCMX1NFF13TNPHW
created: 2026-08-12T17:12:18.017777Z
updated: 2026-08-12T17:12:18.017777Z
type: task
title: M6.5 P6 — V1 asset parent linkage (unblocks httpx `technology` child assets)
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 306
---
**Substrate gap surfaced by the httpx port (**DEV-306**).** The spec-1.0.0 `AssetEventV1` has **no parent-linkage field** — the dispatcher's `asset_event_dedup_fields` hardcodes `parent_asset_id=None` for every V1 asset, with the …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-313](https://linear.app/stevevine/issue/DEV-313/m65-p6-v1-asset-parent-linkage-unblocks-httpx-technology-child-assets)