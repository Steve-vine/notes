---
id: 01KZVFTF8E5T49DZXD7T9XDJRB
created: 2026-08-12T17:20:19.214093Z
updated: 2026-08-12T17:21:32.705307Z
type: task
title: Finding ingest path in workflow step dispatcher
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 353
sprint: sz0gev3
assignee: steve
imported_from: linear
label:
- feature
priority: medium
task_status: done
---
`FindingUpsertService` analogue of `AssetUpsertService`. Wires NDJSON scanner output → Finding rows with fingerprint-based dedup, inside the workflow step dispatcher.

## Scope

* `FindingUpsertService` (parallel to `AssetUpsertService`) — takes a stream of NDJSON records from a scanner, normalises each into a Finding, upserts with `ON CONFLICT (company_id, fingerprint, asset_id) DO UPDATE`.
* On conflict: bump `last_seen_at`, merge `meta`, leav…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-249](https://linear.app/stevevine/issue/DEV-249/finding-ingest-path-in-workflow-step-dispatcher)