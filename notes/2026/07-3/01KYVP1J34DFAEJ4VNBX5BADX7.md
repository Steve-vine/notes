---
id: 01KYVP1J34DFAEJ4VNBX5BADX7
created: 2026-07-31T08:53:21.124716Z
updated: 2026-07-31T08:53:37.168483Z
type: task
title: Cloudflare actions foundation — write token, client write verbs, catalogue, ADR
project: 01KX671DATY39VW6GWK3M2T3DN
number: 394
sprint: s39ax46
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Write path for the Cloudflare connector (sprint s39ax46, planned with Steve 2026-07-31), mirroring the AWS/Azure actions foundations (ISE-373/ISE-377, ADR 0060/0061).

- Second **write-capable account-owned token** on the existing `System.write_credential_ref` Grant-write flow — no credential_spec change; the read token stays read-only. Write token permission groups (all beyond the read set): zone-scoped DNS:Edit, Firewall Services:Edit, Zone Settings:Edit, Cache Purge:Purge, Load Balancers:Edit; account-scoped Account Firewall Access Rules:Edit, Load Balancing: Monitors and Pools:Edit.
- `CloudflareClient` gains write verbs (`patch`/`post`/`delete` on the v4 envelope, same error handling and bounded 429 retry as GET). Cloudflare writes are synchronous — no LRO helper needed (unlike ARM, ADR 0061 §5).
- Catalogue v1 declared with tiers fixed in code (decided 2026-07-31): `update_dns_record` T2 (existing records only — no create/delete), `set_ip_access_rule` T2, `set_security_level` T2 (incl. Under Attack Mode), `purge_cache_urls` T1, `purge_cache_everything` T2, `set_pool_enabled` T2. **No freeform WAF custom-rule editing** (restricted primitives only) and **no tunnel actions** (no server-side restart primitive — never invent one).
- Capabilities gain `actions`; the connector-generic ActionsPanel (ISE-376) lights up for free. Handlers land with their operations in the two follow-on tasks — the catalogue is only declared here for ops whose task ships in this sprint.
- JSON-Schema params with 32-hex id patterns; `target_fields` declared per op for the protected-targets guard.
- ADR 0065: Cloudflare actions, citing 0060/0061 (second-credential pattern) and 0062. (0063/0064 are claimed by the EntraID sprint planned in parallel.)