---
id: 01KZVDH98TT9NJ142A0FG8YASC
created: 2026-08-12T16:40:21.018173Z
updated: 2026-08-12T16:40:21.018173Z
type: task
title: Populate RESOLVES_TO from live DNS resolution (widen host-stack coverage)
assignee: steve
imported_from: linear
task_status: done
label: feature
priority: low
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 188
---
Follow-on to [DEV-642](<https://linear.app/stevevine/issue/DEV-642>). DEV-642 writes the `subdomain --RESOLVES_TO--> ip` bridge **only** from a minted asset's `meta.observed_ip` (today that's the nmap `endpoint`'s resolved IP). So the IP/hostname host-stack bridge exists only for hosts that got a port-scan with `observed_ip`. This widens it.

## Idea

Populate `RESOLVES_TO` from **DNS resolution** in the discovery chain — i.e. when a `subdomain` is resolved (subfinder/resolver/httpx already resolve hostnames), record `subdomain --RESOLVES_TO--> ip` for each resolved address, independent of whether a port scan ran. This connects hostname-anchored technologies to IP-anchored components on more hosts, lifting `assemble_host_assets` / P3 promotion coverage.

## Scope (to triage at plan time)

* Identify where the chain already has hostname→IP resolution data (subfinder/dns/httpx outputs; the `subdomain.meta.observed_ip` the seeds mention; CNAME chains → `ALIAS_OF`).
* Write `RESOLVES_TO` edges (resolve-or-mint the `ip` anchor) at those points, reusing the DEV-642 mint helper (`_maybe_write_resolves_to_bridge` / `_host_ip_resolution`) — keep the **hostname→IP** direction + idempotent upsert.
* Consider multi-A/AAAA (multiple IPs per host) and temporal churn (IP changes → edge `disappeared_at`).
* Optionally settle `ALIAS_OF` (CNAME) at the same time, or defer.

## Acceptance

* Hosts resolved during discovery (no port scan required) carry `subdomain --RESOLVES_TO--> ip` edges; host-stack assembly bridges hostname↔IP on those hosts. Tests over the resolver/discovery output shapes.

## Notes

Pure coverage widener — not required for correctness (P3 is promote-only / false-negative-safe). The `RESOLVES_TO` semantics (direction, multi-IP, temporal) were set in DEV-642; this extends the **sources** that populate them. Touches the discovery/asset-mint path. Plan-mode-driven.

---

Imported from Linear [DEV-646](https://linear.app/stevevine/issue/DEV-646/populate-resolves-to-from-live-dns-resolution-widen-host-stack)