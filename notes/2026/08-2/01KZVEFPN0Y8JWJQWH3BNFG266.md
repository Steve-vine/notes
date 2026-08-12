---
id: 01KZVEFPN0Y8JWJQWH3BNFG266
created: 2026-08-12T16:56:57.760543Z
updated: 2026-08-12T16:58:05.73946Z
type: task
title: 'Runbook: re-run the engine-seeds Job on dev when engine CRs / asset kinds change'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 241
sprint: sewyev2
assignee: steve
imported_from: linear
label:
- chore
priority: medium
task_status: done
---
## Context

DEV-437 root cause was dev-cluster drift: the engine seed CRs (`Engine`/`EngineVersion`, incl. `declaredAssetKinds`/`acceptsAssetKinds`) are applied by the `engine-seeds` Job — a Helm `post-install/post-upgrade` hook. Dev runs on `rollout-restart` (ADR 033), **not…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-439](https://linear.app/stevevine/issue/DEV-439/runbook-re-run-the-engine-seeds-job-on-dev-when-engine-crs-asset-kinds) · parent DEV-437