---
id: 01KZVEFZDSRJT81SF0FQ2B32RX
created: 2026-08-12T16:57:06.745647Z
updated: 2026-08-12T16:58:12.774699Z
type: task
title: 'port-scanner: a single filtered port stalls naabu for ~7 min (CONNECT -timeout not honored)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 244
sprint: sewyev2
assignee: steve
imported_from: linear
label:
- bug
priority: high
task_status: done
---
## Summary

In `port-scanner` (naabu, CONNECT scan), **a single filtered/dropped port stalls the scan for \~6m47s**, regardless of the `timeout` param. naabu's `-timeout` (ms) does **not** bound the CONNECT-scan dial on a dropped port — the wait is the OS default TCP connect timeout (~135s) × naabu's default 3 retries (~407s ≈ 6m47). Since most real hosts have filtered ports, almost every scan pays this, and a multi-host scan blows the `wall_clo…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-430](https://linear.app/stevevine/issue/DEV-430/port-scanner-a-single-filtered-port-stalls-naabu-for-7-min-connect)