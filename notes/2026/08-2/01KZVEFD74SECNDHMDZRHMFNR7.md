---
id: 01KZVEFD74SECNDHMDZRHMFNR7
created: 2026-08-12T16:56:48.100394Z
updated: 2026-08-12T16:56:48.100394Z
type: task
title: 'service-detection: host_timeout floor of 10s silently yields 0 results for -sV (footgun)'
assignee: steve
imported_from: linear
task_status: done
priority: medium
label: follow_up
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 239
---
## Context

Surfaced during M9 testing (cloudflare → service-detection). A run with `host_timeout: 10` returned **0 services** from 160 inputs. Not a bug — `nmap -sV` version detection (TLS handshake + probe rounds, esp. on 443) takes more than 10s/host, so nmap hits `--host-timeout 10s` and **abandons each host before emitting any service**. Silent: the step `succeeded` with `asset_count: 0`, no error, no signal that hosts were timed out.

## E…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-441](https://linear.app/stevevine/issue/DEV-441/service-detection-host-timeout-floor-of-10s-silently-yields-0-results)