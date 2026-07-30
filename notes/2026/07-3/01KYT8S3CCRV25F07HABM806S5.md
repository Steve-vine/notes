---
id: 01KYT8S3CCRV25F07HABM806S5
created: 2026-07-30T19:42:17.996962Z
updated: 2026-07-30T19:42:17.996962Z
type: task
title: Cloudflare evidence-on-demand — DNS, security events, analytics, audit log, tunnel status
task_status: backlog
label: feature
priority: medium
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 384
---
On-demand Evidence queries for investigations — nothing polled that an investigation didn't ask for (AWS/Azure evidence precedent, ISE-362/ISE-368).

- `list_dns_records(zone)` — `GET /zones/{zone_id}/dns_records` (DNS is evidence-only in v1, per the discovery decision).
- Security/firewall events — GraphQL `firewallEventsAdaptive` over a bounded time window (the brief's "security events summary").
- Zone analytics summary (requests/threats/bandwidth over a window) via the GraphQL analytics dataset.
- Audit log — `GET /accounts/{account_id}/audit_logs`, bounded window (Activity-Log precedent).
- Tunnel status/connections — `GET /accounts/{account_id}/cfd_tunnel/{id}/connections`.
- All read-only, declared as connector evidence capabilities so the investigation/chat surfaces pick them up automatically.