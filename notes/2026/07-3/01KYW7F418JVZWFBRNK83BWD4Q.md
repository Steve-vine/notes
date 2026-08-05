---
id: 01KYW7F418JVZWFBRNK83BWD4Q
created: 2026-07-31T13:57:51.272709Z
updated: 2026-08-05T12:34:18.979853Z
type: task
title: 'Integration docs: Cloudflare'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 415
order: 1.5
sprint: sp3en5k
comments:
- id: 01KYW8B7ABJGDE3YXVV6C4TQYR
  author: Steve Vine
  at: 2026-07-31T14:13:12.139783Z
  text: |-
    Done on feature/ise-415-docs-cloudflare — PR #13, left OPEN for the PR-preview test.

    Full Cloudflare page: capabilities (zones/Tunnels/LBs/Workers discovery, DNS evidence-only; polled alert history as signals with the presence-window semantics and the "no notification policies → no signals" caveat; evidence list_dns_records/security_events/zone_analytics/audit_log/tunnel_connections; actions purge_cache_urls T1 + update_dns_record/set_ip_access_rule/set_security_level/purge_cache_everything/set_pool_enabled T2, deliberate absences stated), setup (account-owned read token with the exact permission groups from the credential spec, account_id, Grant-write second token, notification-policy prerequisite), examples (LB health-check→incident, Under Attack + cache purge tiering, attack-vs-surge evidence). Facts from connectors/cloudflare.py + ADRs 0062/0065. Build/lint green.
assignee: steve
priority: medium
task_status: done
---
Replace the Cloudflare stub (`src/content/docs/integrations/cloudflare.md`) with full operator documentation:

- **Capabilities** — per-account discovery (zones, Tunnels, LB pools as attributes, Workers/Pages), polled alert history as signals (24h presence window), evidence (DNS records, firewall events, zone analytics, audit log, tunnel connections), action catalogue (update existing DNS records, IP access rules, security level incl. Under Attack, cache purge URL/everything, pool enable/disable) with per-op tiers — no freeform WAF editing, no tunnel actions, no DNS create/delete, by design.
- **Setup** — account-owned read-only API token + account id; separate write-capable token via Grant-write; token scoping guidance.
- **Examples** — a Cloudflare alert on a zone entity; a T1 targeted cache purge vs a T2 purge-everything through approval.

Ground in ADRs 0062 (connector) + 0065 (actions); rewrite for operators, released capability only.