---
id: 01M1Q7B1QAV5G5T4SWYKZ82S61
created: 2026-09-04T22:06:31.146502Z
updated: 2026-09-04T22:06:31.146502Z
type: task
title: g5 egress DNS is intermittently unreliable — CI setup steps and integrations fail in windows
tech: kubernetes
label: tech_debt
priority: high
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 783
---
Two symptoms on 2026-09-04, one cluster.

**1. Integrations (ISE-778's trigger).** 18:05–18:26 the worker pod hit 75 `Temporary failure in name resolution` across five integrations. CoreDNS logged **3,525 errors in that window and none since**, all upstream:

```
1821  moneypenny.twingate.com. A: dial udp [::…]:53: connect: network is unreachable
1815  moneypenny.twingate.com. A: read udp 10.42.0.103->8.8.8.8:53: i/o timeout
 182  login.microsoftonline.com. A: dial udp [::…]:53: network is unreachable
```

CoreDNS forwards to `/etc/resolv.conf`, which carries an **IPv6 upstream the host cannot reach** plus 8.8.8.8; when 8.8.8.8 stalls, every query fails. **Single replica** (`coredns-c46df69ff-wfxqg`, 1 restart 4d ago).

**2. CI (`setup-uv` "fetch failed" in ~1s).** Five consecutive failures on PR #720's `backend-lint` (20:00–20:20), then #723's `backend` at 21:34 — while sibling jobs on the same run using the identical action passed. Reproduced from a runner pod at ~20:25: Node 24 default `fetch()` → `ETIMEDOUT` 3/3, `--dns-result-order=ipv4first` → 200, curl → 200. **PR #721** set `NODE_OPTIONS: --dns-result-order=ipv4first` workflow-wide, but #723 failed *with* the flag present, and at 21:40 the default fetch passed 4/4 from the same pod — so it is an intermittent egress fault in windows of minutes, only partly IPv6 ordering. `setup-uv` always fetches its manifest (`getArtifact(version, …, manifestUrl)`), so pinning `version:` does not avoid the fetch.

**Proposed**
- CoreDNS: drop the unreachable IPv6 upstream from the forwarders (or forward to explicit IPv4 resolvers), run 2 replicas.
- CI: install uv with `curl --retry 5 -LsSf https://astral.sh/uv/install.sh` pinned to the lockfile's version (+ actions/cache), instead of `setup-uv` — curl has never failed here. Same for helm.
- Decide whether a health-probe failure should trip `integration_broken` on its first failure or need two (ISE-778's open note) — a 20-minute DNS transient would have paged.

Evidence: runs 33913992726 (#720, attempts 1–5), 33921558780 (#723); `kubectl logs -n kube-system deploy/coredns --since=4h | grep ERROR`.