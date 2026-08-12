---
id: 01KZVE2VRMFQ6KAFJWF5DNM8C1
created: 2026-08-12T16:49:57.01284Z
updated: 2026-08-12T16:50:26.380771Z
type: task
title: Dedup port-scanner (naabu) scans by resolved IP
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 214
sprint: sp88phy
assignee: steve
imported_from: linear
label:
- tech_debt
priority: low
task_status: done
---
Split from DEV-565 (which did the service-detection half).

port-scanner (naabu) is IP-dependent like service-detection — the open ports depend on the resolved **IP**, not the hostname — so N hostnames on M < N IPs scan the same IP (N−M) extra times (e.g. 147 Cloudflare-fronted hostnames → 1 edge IP → 588 endpoint rows describing 4 ports).

Apply the same pattern DEV-565 used for nmap: use `PreresolveResult.ip_map` to collapse the scan-target set to one representative host per resolved IP, scan each IP once, and fan the open ports back to every co-located host (each `endpoint` keyed on its own anchor, `meta.observed_ip` = the IP). See `app/scanners/service-detection/.../runner.py` `_dedup_targets_by_ip` / `_emit_services_for_host` + tests for the reference implementation.

**Lower priority than** DEV-565**:** port-scanner is fast (~110 s in the failing run) so the time saved is small; the value is mostly fewer redundant endpoint rows / cleaner inventory. naabu's target grouping + output parsing differ from nmap, so it's a separate (smaller) change.

### Acceptance

port-scanner scans each distinct resolved IP once and fans the open ports to all co-located hostnames, emitting the identical per-hostname `endpoint` assets. Multi-IP and no-resolution hosts handled (mirror DEV-565).

---

Imported from Linear [DEV-568](https://linear.app/stevevine/issue/DEV-568/dedup-port-scanner-naabu-scans-by-resolved-ip)