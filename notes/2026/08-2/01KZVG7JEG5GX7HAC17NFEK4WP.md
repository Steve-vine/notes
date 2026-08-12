---
id: 01KZVG7JEG5GX7HAC17NFEK4WP
created: 2026-08-12T17:27:28.464477Z
updated: 2026-08-12T17:27:28.464477Z
type: task
title: httpx stalls on large input lists (~22k subdomains) — zero TCP connections, hits wall-clock timeout
label:
- follow_up
- bug
assignee: steve
task_status: done
priority: high
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 389
---
## Symptom

Chained `subfinder-then-httpx` against `example.com` produces \~22k subdomains in step 1, then httpx in step 2 runs for the full 600s wall-clock timeout (`_DEFAULT_TIMEOUT_SECONDS` in the runner) and emits **zero JSON records** to stdout. The runner only emits its initial force-emit `progress: 0/22249` and the final `httpx_timeout` log line; no actual probe records.

The `httpx_timeout` ScanJob excerpt across multiple smoke runs show…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-162](https://linear.app/stevevine/issue/DEV-162/httpx-stalls-on-large-input-lists-22k-subdomains-zero-tcp-connections) · parent DEV-159