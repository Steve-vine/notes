---
id: 01KYVP2HRMF3D08YN7J6BK4MD6
created: 2026-07-31T08:53:53.556067Z
updated: 2026-07-31T09:03:54.606868Z
type: task
title: Cloudflare security + LB actions — IP access rules, security level, pool toggle
project: 01KX671DATY39VW6GWK3M2T3DN
number: 396
order: 1.5
sprint: s39ax46
blocked_by:
- 01KYVP1J34DFAEJ4VNBX5BADX7
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The security and load-balancing half of the ADR 0065 catalogue (decided with Steve 2026-07-31: restricted primitives only — no freeform WAF rule editing).

- `set_ip_access_rule` (T2): block / challenge / whitelist ONE IP or CIDR via the IP Access Rules API (`POST /zones/{zone_id}/firewall/access_rules/rules`, or account-wide via `/accounts/{id}/...` when no zone given). `before` records any existing rule for that target (mode overwritten) or its absence; rollback = delete the rule or restore the prior mode. The classic under-attack response.
- `set_security_level` (T2): step one zone's security level (`PATCH /zones/{zone_id}/settings/security_level` — essentially_off…under_attack). Prior level captured in `before`; Under Attack Mode on/off is this operation at its extremes.
- `set_pool_enabled` (T2): enable/disable ONE load-balancer pool (`PATCH /accounts/{id}/load_balancers/pools/{pool_id}`) — manual failover for LB incidents. Prior enabled state in `before`; pool named by id (pools are attributes, not entities — the target_fields carry the pool id + name).
- Same containment + execution-path test contract as ISE-395.