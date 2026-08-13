---
id: 01KYT8S3CCRV25F07HABM806S5
created: 2026-07-30T19:42:17.996962Z
updated: 2026-08-13T19:00:00.160989Z
type: task
title: Cloudflare evidence-on-demand — DNS, security events, analytics, audit log, tunnel status
project: 01KX671DATY39VW6GWK3M2T3DN
number: 384
sprint: s39ax46
blocked_by:
- 01KYT8RMC8S3K8E5BPVEZEFE43
comments:
- id: 01KYTGNRGMT9P619HTE7DG0ZF1
  author: Steve Vine
  at: 2026-07-30T22:00:17.172545Z
  text: |-
    Built and in review — PR #359 (feature/ise-384-cloudflare-evidence, stacked on #358, targeting main), merged to staging (982ffee).

    Delivered: five declared evidence queries (ADR 0031 shape, static catalogue). list_dns_records is DNS's only home (never synced; optional record-type filter, bounded with total count). security_events rides the GraphQL firewallEventsAdaptive dataset (WAF blocks/challenges/rate limiting, bounded window, newest first) and zone_analytics rides httpRequests1hGroups (hourly requests/bytes/threats/cached/page-view buckets) — CloudflareClient gained post_json for the GraphQL endpoint, which lives on the same host but answers {data, errors} rather than the v4 envelope; it gets the same bounded 429 retry. audit_log is the Activity Log/CloudTrail analogue, windowed via since. tunnel_connections returns the tunnel's status plus flattened active edge connections (colo, opened_at, client version).

    Containment mirrors the act-catalogue guard on the read path: unknown query names are refused, GraphQL-level errors degrade to ok=False with Cloudflare's message as the summary, and any Cloudflare/network failure is a trace note, never a raise. All payloads bounded.

    One caution for the ISE-385 live smoke: the two GraphQL queries are the least fixture-verifiable part (scalar names like Time and dataset availability vary by plan) — exercise security_events and zone_analytics against the real account before calling the sprint done.

    10 new tests; ruff + mypy (428 files) green.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
On-demand Evidence queries for investigations — nothing polled that an investigation didn't ask for (AWS/Azure evidence precedent, ISE-362/ISE-368).

- `list_dns_records(zone)` — `GET /zones/{zone_id}/dns_records` (DNS is evidence-only in v1, per the discovery decision).
- Security/firewall events — GraphQL `firewallEventsAdaptive` over a bounded time window (the brief's "security events summary").
- Zone analytics summary (requests/threats/bandwidth over a window) via the GraphQL analytics dataset.
- Audit log — `GET /accounts/{account_id}/audit_logs`, bounded window (Activity-Log precedent).
- Tunnel status/connections — `GET /accounts/{account_id}/cfd_tunnel/{id}/connections`.
- All read-only, declared as connector evidence capabilities so the investigation/chat surfaces pick them up automatically.