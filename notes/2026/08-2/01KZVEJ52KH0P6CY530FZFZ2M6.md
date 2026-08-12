---
id: 01KZVEJ52KH0P6CY530FZFZ2M6
created: 2026-08-12T16:58:18.067897Z
updated: 2026-08-12T16:59:16.808995Z
type: task
title: Dispatcher miscounts engine stderr log lines as dropped_malformed
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 246
sprint: sewyev2
assignee: steve
imported_from: linear
label:
- bug
priority: medium
task_status: done
---
## Summary

The dispatcher's NDJSON parser (`_parse_pod_logs`, `app/backend/src/redvektor_api/tasks/scans.py`) counts every engine **log line** as `dropped_malformed` and appends it to `warnings`. Surfaced on `cloudflare-dns-discovery` (13 per run; DEV-374 re-verify) but it…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-426](https://linear.app/stevevine/issue/DEV-426/dispatcher-miscounts-engine-stderr-log-lines-as-dropped-malformed)