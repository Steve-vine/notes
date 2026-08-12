---
id: 01KZVB66BJJ0TKPDPTEV98FDQ8
created: 2026-08-12T15:59:20.434908Z
updated: 2026-08-12T15:59:20.434908Z
type: task
title: Subfinder runner emits 2 stdout lines that aren't valid NDJSON
assignee: steve
imported_from: linear
label: bug
priority: low
task_status: backlog
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 101
---
The dispatcher correctly warns and continues, so behaviour is fine. Likely subfinder banner / probe output leaking onto stdout instead of stderr. Worth tracing: either suppress in the runner, or update the runner to write all of subfinder's own diagnostic output to stderr.

Source: Obsidian Issues Tracker #19 (P4 Low, Open). Discovered during Brief 006b live verification.

---

Imported from Linear [DEV-27](https://linear.app/stevevine/issue/DEV-27/subfinder-runner-emits-2-stdout-lines-that-arent-valid-ndjson)