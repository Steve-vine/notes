---
id: 01KZVE8P1CM1TMYNDSE5TD1K9K
created: 2026-08-12T16:53:07.756987Z
updated: 2026-08-12T16:54:10.054749Z
type: task
title: Dedup IP-dependent scans (port-scanner, service-detection) by resolved IP
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 217
sprint: sp88phy
assignee: steve
imported_from: linear
label:
- tech_debt
priority: medium
task_status: done
---
Found diagnosing the `vul-scan` run `91b7f09c`.

### Problem

Port-scanner and service-detection are **IP-dependent** — the open ports / running service depend on the resolved **IP**, not the hostname. But they scan **per hostname**, so when N hostnames resolve to M < N IPs the extra (N−M) scans are pure redundancy.

In this run that was dramatic (Cloudflare-fronted scope): hundreds of hostnames → ~2 Cloudflare edge IPs.

* **port-scanner**: 147…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-565](https://linear.app/stevevine/issue/DEV-565/dedup-ip-dependent-scans-port-scanner-service-detection-by-resolved-ip)