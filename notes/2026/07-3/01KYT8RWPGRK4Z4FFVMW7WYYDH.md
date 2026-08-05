---
id: 01KYT8RWPGRK4Z4FFVMW7WYYDH
created: 2026-07-30T19:42:11.152789Z
updated: 2026-08-05T11:55:54.937531Z
type: task
title: Cloudflare alert signals — polled notification history
project: 01KX671DATY39VW6GWK3M2T3DN
number: 383
sprint: s39ax46
blocked_by:
- 01KYT8RMC8S3K8E5BPVEZEFE43
comments:
- id: 01KYTGG8M0588E3E8EYR7GHEY0
  author: Steve Vine
  at: 2026-07-30T21:57:17.056733Z
  text: |-
    Built and in review — PR #358 (feature/ise-383-cloudflare-alert-signals, stacked on #357, targeting main), merged to staging (f65ccb0).

    Delivered: detect() polls /accounts/{id}/alerting/v3/history over a bounded 24h window on the ordinary sync cadence, forwarded verbatim as Alert signals. One design note vs the plan: Cloudflare's alert history is an event log, not a stateful "currently firing" list (there is no Azure-style Fired filter), so the window IS the presence contract — a delivered notification stays a present signal while inside it, and ageing out derives recovery through the ordinary reconcile. source_key = alert_type|policy_id (the monitor/{id}/{group} shape), so re-deliveries collapse within a sweep and reinforce across sweeps; all keys bounded (_bounded_key, ISE-368 lesson).

    Severity: conservative medium default with unambiguous per-type overrides (DDoS L4/L7, tunnel_health_event, load_balancing_health_alert → high; SSL/cert events → low; billing → info); per-service tuning rides ADR 0026 via kind. Attribution: a structured alert_body naming zone_id/tunnel_id/load_balancer_id maps onto the ISE-382 discovery keys; freeform text bodies attribute nothing (never guessed, ADR 0028); pool ids deliberately excluded (pools aren't entities). Signal tags cloudflare_alert:{type} feed the Tag Cloud even though Cloudflare entities carry no tags. History read failure degrades to zero signals with a warning.

    The "requires notification policies" empty-state copy for the account card is noted for ISE-385 (the surface task).

    7 new tests incl. the cross-source Postgres path (discovered tunnel + tunnel alert resolve to one entity through ordinary linking). ruff + mypy (427 files) green.
assignee: steve
priority: medium
task_status: done
---
Detect layer: Cloudflare's own alerting forwarded verbatim as Alert signals (deferral principle; CloudWatch-alarms/Azure-Monitor pattern — ISE-360/ISE-367).

- Poll `GET /accounts/{account_id}/alerting/v3/history` on the normal sync cadence → Alert signals via the existing same-entity dedupe; no new cross-source architecture.
- Attribution: map each alert to its zone/tunnel/load-balancer entity where the payload identifies one; otherwise an account-level signal on the System.
- Severity: alert history has no native severity ladder — conservative default (warning) with per-alert-type overrides where obvious (e.g. tunnel down → higher).
- Bound every minted `source_key` (`_bounded_key`, the varchar(300) overflow gotcha from ISE-368).
- Requires notification policies to exist in Cloudflare — surface that plainly (empty-state text on the card), don't fail silently.
- Webhook delivery via the existing webhook integration (s6pc5xk) considered and deferred; polling is the v1 baseline (decided 2026-07-30).