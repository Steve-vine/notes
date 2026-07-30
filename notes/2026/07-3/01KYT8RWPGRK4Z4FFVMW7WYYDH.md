---
id: 01KYT8RWPGRK4Z4FFVMW7WYYDH
created: 2026-07-30T19:42:11.152789Z
updated: 2026-07-30T19:42:36.54249Z
type: task
title: Cloudflare alert signals — polled notification history
project: 01KX671DATY39VW6GWK3M2T3DN
number: 383
sprint: s09ekyn
blocked_by:
- 01KYT8RMC8S3K8E5BPVEZEFE43
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Detect layer: Cloudflare's own alerting forwarded verbatim as Alert signals (deferral principle; CloudWatch-alarms/Azure-Monitor pattern — ISE-360/ISE-367).

- Poll `GET /accounts/{account_id}/alerting/v3/history` on the normal sync cadence → Alert signals via the existing same-entity dedupe; no new cross-source architecture.
- Attribution: map each alert to its zone/tunnel/load-balancer entity where the payload identifies one; otherwise an account-level signal on the System.
- Severity: alert history has no native severity ladder — conservative default (warning) with per-alert-type overrides where obvious (e.g. tunnel down → higher).
- Bound every minted `source_key` (`_bounded_key`, the varchar(300) overflow gotcha from ISE-368).
- Requires notification policies to exist in Cloudflare — surface that plainly (empty-state text on the card), don't fail silently.
- Webhook delivery via the existing webhook integration (s6pc5xk) considered and deferred; polling is the v1 baseline (decided 2026-07-30).