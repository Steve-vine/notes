---
id: 01KYVP1J34DFAEJ4VNBX5BADX7
created: 2026-07-31T08:53:21.124716Z
updated: 2026-08-05T12:33:53.089088Z
type: task
title: Cloudflare actions foundation — write token, client write verbs, catalogue, ADR
project: 01KX671DATY39VW6GWK3M2T3DN
number: 394
order: 2.0
sprint: s39ax46
comments:
- id: 01KYVPFCDG1YR214MNYRD66XRV
  author: Steve Vine
  at: 2026-07-31T09:00:54.064181Z
  text: |-
    Built and in review — PR #361 (feature/ise-394-cloudflare-actions-foundation, targeting main), merged to staging (d8da447).

    Delivered: the ADR 0060/0061 second-credential pattern applied to Cloudflare. The write credential is a second write-capable account-owned token arriving only through the executor's write_credential_ref reveal (existing Grant-write flow — zero platform changes needed, it's connector-generic; credential_spec untouched, read token stays read-only). CloudflareClient gained patch/post_result/delete speaking the v4 envelope through a shared _checked answer path with the same bounded 429 retry as reads — safe because every planned catalogue op is an idempotent one-key mutation. Cloudflare writes are synchronous, so no ARM-style LRO helper (recorded in ADR 0065 §3). Capabilities now {alerts, entities, evidence, actions}; _execute dispatches getattr-style to _act_{name} handlers with Cloudflare errors contained into failed ActionResults.

    Deliberate: the catalogue is still EMPTY on this branch — operations ship WITH their handlers (the azure.py principle), landing in ISE-395 (DNS+cache) and ISE-396 (security+LB). ADR 0065 records the full six-op catalogue and tiers, the write-token permission groups, before-capture contract, and the deliberate absences (freeform WAF editing, tunnel actions, DNS create/delete); amends ADR 0062 §4; brief row updated to the final catalogue.

    Tests: capability surface updated + 3 write-plumbing tests (envelope/payload passthrough, 429 retry-then-raise, success:false raises — the "token lacks permission" shape surfaces as an error, never a silent executed). ruff + mypy (428 files) + 17 file tests green; PR CI running.
assignee: steve
label: null
priority: medium
task_status: done
---
Write path for the Cloudflare connector (sprint s39ax46, planned with Steve 2026-07-31), mirroring the AWS/Azure actions foundations (ISE-373/ISE-377, ADR 0060/0061).

- Second **write-capable account-owned token** on the existing `System.write_credential_ref` Grant-write flow — no credential_spec change; the read token stays read-only. Write token permission groups (all beyond the read set): zone-scoped DNS:Edit, Firewall Services:Edit, Zone Settings:Edit, Cache Purge:Purge, Load Balancers:Edit; account-scoped Account Firewall Access Rules:Edit, Load Balancing: Monitors and Pools:Edit.
- `CloudflareClient` gains write verbs (`patch`/`post`/`delete` on the v4 envelope, same error handling and bounded 429 retry as GET). Cloudflare writes are synchronous — no LRO helper needed (unlike ARM, ADR 0061 §5).
- Catalogue v1 declared with tiers fixed in code (decided 2026-07-31): `update_dns_record` T2 (existing records only — no create/delete), `set_ip_access_rule` T2, `set_security_level` T2 (incl. Under Attack Mode), `purge_cache_urls` T1, `purge_cache_everything` T2, `set_pool_enabled` T2. **No freeform WAF custom-rule editing** (restricted primitives only) and **no tunnel actions** (no server-side restart primitive — never invent one).
- Capabilities gain `actions`; the connector-generic ActionsPanel (ISE-376) lights up for free. Handlers land with their operations in the two follow-on tasks — the catalogue is only declared here for ops whose task ships in this sprint.
- JSON-Schema params with 32-hex id patterns; `target_fields` declared per op for the protected-targets guard.
- ADR 0065: Cloudflare actions, citing 0060/0061 (second-credential pattern) and 0062. (0063/0064 are claimed by the EntraID sprint planned in parallel.)