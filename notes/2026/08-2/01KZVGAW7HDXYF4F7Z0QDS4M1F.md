---
id: 01KZVGAW7HDXYF4F7Z0QDS4M1F
created: 2026-08-12T17:29:16.785475Z
updated: 2026-08-12T17:29:16.785475Z
type: task
title: Brief 006b — Scanner Job dispatcher + subfinder + asset ingestion
assignee: steve
label: brief
imported_from: linear
task_status: done
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 402
---
Two new tables (`scans`, `scan_jobs`), K8s integration with auto-detect, `dispatch_scan` Celery task, `AssetUpsertService` with `INSERT ... ON CONFLICT ... RETURNING xmax = 0`, subfinder image (pinned v2.6.6), `redvektor-scanner-common` Pydantic-typed I/O contract via NDJSON-on-stdout. **End-to-end verified: 22,248 assets discovered for [example.com](<http://example.com>).**

**Brief spec:** [docs/briefs/006b-scanner-dispatcher-subfinder.md](<ht…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-11](https://linear.app/stevevine/issue/DEV-11/brief-006b-scanner-job-dispatcher-subfinder-asset-ingestion)