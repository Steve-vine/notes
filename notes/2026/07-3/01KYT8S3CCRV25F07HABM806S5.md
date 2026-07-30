---
id: 01KYT8S3CCRV25F07HABM806S5
created: 2026-07-30T19:42:17.996962Z
updated: 2026-07-30T21:36:05.144975Z
type: task
title: Cloudflare evidence-on-demand — DNS, security events, analytics, audit log, tunnel status
project: 01KX671DATY39VW6GWK3M2T3DN
number: 384
sprint: s39ax46
blocked_by:
- 01KYT8RMC8S3K8E5BPVEZEFE43
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
On-demand Evidence queries for investigations — nothing polled that an investigation didn't ask for (AWS/Azure evidence precedent, ISE-362/ISE-368).

- `list_dns_records(zone)` — `GET /zones/{zone_id}/dns_records` (DNS is evidence-only in v1, per the discovery decision).
- Security/firewall events — GraphQL `firewallEventsAdaptive` over a bounded time window (the brief's "security events summary").
- Zone analytics summary (requests/threats/bandwidth over a window) via the GraphQL analytics dataset.
- Audit log — `GET /accounts/{account_id}/audit_logs`, bounded window (Activity-Log precedent).
- Tunnel status/connections — `GET /accounts/{account_id}/cfd_tunnel/{id}/connections`.
- All read-only, declared as connector evidence capabilities so the investigation/chat surfaces pick them up automatically.