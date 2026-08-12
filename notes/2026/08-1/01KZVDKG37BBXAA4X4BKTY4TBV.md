---
id: 01KZVDKG37BBXAA4X4BKTY4TBV
created: 2026-08-12T16:41:33.543757Z
updated: 2026-08-12T16:41:33.543757Z
type: task
title: 'version-cve P1: store the NVD applicability tree (foundation for host-stack eval)'
task_status: done
priority: low
assignee: steve
imported_from: linear
label: feature
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 192
---
Phase 1 of [DEV-632](<https://linear.app/stevevine/issue/DEV-632>) (host-stack-aware correlation). The sync (`services/cve_sync.py` `_walk_cpe_matches`) **flattens** NVD `configurations` into `cve_cpe_match` rows and discards the operator tree (AND/OR + "running-on"), so the structure P3 needs to evaluate is unrecoverable. P1 **preserves** it.

## Scope (additive, no behaviour change)

* Add `cve.applicability` (JSONB, default `[]`; migration 0037) holding a **normalized** config tree.
* `_build_applicability(configurations)` in the sync: a compact tree of `{operator, nodes:[{operator, negate, matches:[{vendor, product, version-bounds, vulnerable}]}]}` — reuses `_parse_cpe_match`, but keeps **all** matches incl. `vulnerable:false` running-on (the flatten drops these). Set on `ParsedCve`; written by `_upsert_cves`; air-gap `import_bundle` covered (same parser).
* The flatten (matching) + `conditional_applicability` flag (DEV-626) are **unchanged** — P1 only adds the stored tree.

## Acceptance

* After a sync/import, `cve.applicability` holds the normalized tree (operator + running-on `vulnerable:false` preserved; version bounds round-trip). Parser + round-trip tests. No change to matching or findings.

---

Imported from Linear [DEV-633](https://linear.app/stevevine/issue/DEV-633/version-cve-p1-store-the-nvd-applicability-tree-foundation-for-host) · parent DEV-632