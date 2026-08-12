---
id: 01KZVE22NCTT3AN1VTJBGT2ZPP
created: 2026-08-12T16:49:31.308359Z
updated: 2026-08-12T16:49:31.308359Z
type: task
title: Port-scanner finds 0 open ports from the dev cluster (naabu egress)
task_status: done
assignee: steve
imported_from: linear
label: bug
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 211
---
Observed repeatedly while verifying DEV-565 and DEV-557: **port-scanner (naabu) returns 0 open ports for every target** when run from the dev k3s cluster, even for hosts that definitely have open ports.

### Evidence

* port-scanner root step on `scanme.nmap.org` (22/80 open) → step `succeeded`, `asset_count=0`.
* port-scanner root step on `demo.testfire.net` (80/443/8080 open) → `succeeded`, `asset_count=0`.
* Same hosts via **service-detection (nmap)** from the same cluster *do* find services (e.g. the DEV-557 contrast run found 4 endpoints on `ma/us.moneypenny.com:80,443`), so DNS + general egress work — it's specific to naabu's scan method.

### Likely cause

naabu defaults to a **SYN (raw-socket) connect** scan; nmap uses a TCP **connect** scan (`-sT`). Raw-socket SYN packets are commonly dropped by cloud egress / the CNI / lack of `NET_RAW`, so naabu sees no responses → 0 ports, while nmap's full-connect path succeeds. (RedVektor's nmap engine already pins `-sT` connect-scan for exactly this kind of environment.)

### To investigate

* Confirm naabu's scan type in the engine (`-s` flag) and whether it's SYN vs CONNECT. Force **CONNECT** scan (naabu `-s c`) — the runner docstring already says "CONNECT scan only (`-s c`)", so verify the flag is actually applied and reaching naabu, and that the Job has whatever capability/sysctl it needs.
* Check the scanner pod has (or doesn't need) `NET_RAW`/`NET_ADMIN`; a CONNECT scan shouldn't need raw sockets.
* Reproduce: `port-scanner` root step on `scanme.nmap.org`, inspect the naabu pod logs for the actual invocation + any permission/socket errors.

### Acceptance

port-scanner finds the expected open ports for a known-good target (e.g. `scanme.nmap.org` → 22, 80) when run from the dev cluster.

### Context

Not a blocker for the asset-model fixes (DEV-565/DEV-557 were verified via service-detection), but it means port-scanner can't be smoke-tested end-to-end from dev, and any real infra workflow using it will under-report.

---

Imported from Linear [DEV-578](https://linear.app/stevevine/issue/DEV-578/port-scanner-finds-0-open-ports-from-the-dev-cluster-naabu-egress)