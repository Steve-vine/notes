---
id: 01KZVG4PSPATECQW676CM4YV4M
created: 2026-08-12T17:25:54.614219Z
updated: 2026-08-12T17:25:54.614219Z
type: task
title: Verify httpx -json output streams (not internally buffered like subfinder)
imported_from: linear
task_status: done
assignee: steve
priority: medium
label:
- follow_up
- tech_debt
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 382
---
## Context

Brief 014 found that subfinder buffers its `-oJ` JSONL stdout output internally at the application level — regardless of TTY, regardless of `-active`, regardless of PTY allocation. This was discovered AFTER Brief 012b shipped a streaming `Popen` wrapper for httpx on the assumption that httpx streams its output.

httpx is also a ProjectDiscovery Go binary. It might exhibit the same buffering behaviour, in which case the streaming wrap…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-171](https://linear.app/stevevine/issue/DEV-171/verify-httpx-json-output-streams-not-internally-buffered-like) · parent DEV-168