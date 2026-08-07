---
id: 01KZDTK0FZ8AZWNGD8Q2KJPH69
created: 2026-08-07T09:59:07.007449Z
updated: 2026-08-07T10:38:03.718798Z
type: task
title: 'Connector timeout hardening: bound HTTP reads so network outages fail fast'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 606
sprint: sgyvvx3
assignee: steve
label: null
priority: medium
task_status: backlog
---
During the 2026-08-06 g5 DNS outage, connector reads went from ~2s to minutes of urllib3 retry storms (NameResolutionError × 3 attempts with backoff, SSL EOF retries, long default socket timeouts). That inflation — not task volume — collapsed worker throughput below beat's inflow and built the 10k sync-queue backlog. A network outage should degrade to *fast, visible failures* (which the Platform Log already surfaces well), not minute-long hangs.

Audit every connector's HTTP client and apply explicit, tight bounds:

- Connect timeout ~5s, read timeout ~30s (per connector judgement — some Graph/ARM list calls are legitimately slow), retries capped at 1–2 with short backoff.
- Covers: kubernetes client (urllib3 — the worst offender on 2026-08-06), httpx-based connectors (Cloudflare, FreshService, status pages), Graph/EntraID/M365, boto3 (AWS config has its own connect/read timeout + retry `max_attempts` settings), Azure SDK, DataDog, GitHub.
- One shared place for the defaults (settings), so a new connector inherits sane bounds instead of library defaults.
- A sync that fails fast records `last_sync_error` and warns to the Platform Log — the existing surfaces do the rest.

Companion to ISE-605 (task expiry + queue/staleness visibility): expiry makes backlogs self-healing, this stops them forming.