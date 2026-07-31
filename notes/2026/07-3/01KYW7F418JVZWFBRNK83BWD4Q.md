---
id: 01KYW7F418JVZWFBRNK83BWD4Q
created: 2026-07-31T13:57:51.272709Z
updated: 2026-07-31T13:57:51.272709Z
type: task
title: 'Integration docs: Cloudflare'
label: feature
assignee: steve
priority: medium
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 415
---
Replace the Cloudflare stub (`src/content/docs/integrations/cloudflare.md`) with full operator documentation:

- **Capabilities** — per-account discovery (zones, Tunnels, LB pools as attributes, Workers/Pages), polled alert history as signals (24h presence window), evidence (DNS records, firewall events, zone analytics, audit log, tunnel connections), action catalogue (update existing DNS records, IP access rules, security level incl. Under Attack, cache purge URL/everything, pool enable/disable) with per-op tiers — no freeform WAF editing, no tunnel actions, no DNS create/delete, by design.
- **Setup** — account-owned read-only API token + account id; separate write-capable token via Grant-write; token scoping guidance.
- **Examples** — a Cloudflare alert on a zone entity; a T1 targeted cache purge vs a T2 purge-everything through approval.

Ground in ADRs 0062 (connector) + 0065 (actions); rewrite for operators, released capability only.