---
id: 01KZVAXDWZ9NWB4EX8SG34064M
created: 2026-08-12T15:54:33.247113Z
updated: 2026-08-12T15:54:33.247113Z
type: task
title: Result transport upgrade path
imported_from: linear
label: tech_debt
assignee: steve
priority: medium
task_status: backlog
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 70
---
Currently NDJSON-on-stdout via K8s pod log API (capped at \~10MB per pod). Upgrade to S3 or shared PVC when a scanner first emits >5MB output (likely nuclei against a large surface, or full-port nmap). Architectural seam in `dispatch_scan` is one function — `_collect_scanner_output(...)`. Tracked against Brief 006b.

Source: Obsidian To Do § Backlog.

---

Imported from Linear [DEV-69](https://linear.app/stevevine/issue/DEV-69/result-transport-upgrade-path)