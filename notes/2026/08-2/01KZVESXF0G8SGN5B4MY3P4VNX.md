---
id: 01KZVESXF0G8SGN5B4MY3P4VNX
created: 2026-08-12T17:02:32.416449Z
updated: 2026-08-12T17:02:32.416449Z
type: task
title: 'cloudflare-dns-discovery: blank name_pattern ("") filters out all records'
label: bug
priority: medium
task_status: done
imported_from: linear
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 267
---
## Summary

In `cloudflare-dns-discovery`, leaving the optional `name_pattern` field blank submits `""` (empty string), which the record filter treats as a glob that matches **nothing** — so every DNS record is filtered out and the step returns 0 assets despite finding the zone and records.

## Root cause

`app/scanners/cloudflare-dns-discovery/src/redvektor_cloudflare_dns_discovery/runner.py`:

```python
if name_pattern is not None and not fnma…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-374](https://linear.app/stevevine/issue/DEV-374/cloudflare-dns-discovery-blank-name-pattern-filters-out-all-records)