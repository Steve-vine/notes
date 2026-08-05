---
id: 01KYVP2HRMF3D08YN7J6BK4MD6
created: 2026-07-31T08:53:53.556067Z
updated: 2026-08-05T13:39:24.198166Z
type: task
title: Cloudflare security + LB actions — IP access rules, security level, pool toggle
project: 01KX671DATY39VW6GWK3M2T3DN
number: 396
order: 1.5
sprint: s39ax46
blocked_by:
- 01KYVP1J34DFAEJ4VNBX5BADX7
comments:
- id: 01KYVPT3H8YP49KHVSDM6CCQS5
  author: Steve Vine
  at: 2026-07-31T09:06:45.415911Z
  text: |-
    Built and in review — PR #363 (feature/ise-396-cloudflare-security-lb-actions, stacked on #362, targeting main), merged to staging (ea57e13). Completes the ADR 0065 catalogue at six operations.

    Delivered: set_ip_access_rule (T2) enforces one-target-one-rule — an existing rule for the exact IP/CIDR has its mode overwritten with the prior mode riding `before`, rather than gaining a contradictory sibling; a created rule records its id and existed:false so the recorded undo is deletion. Zone-scoped or account-wide (zone_id omitted); the address family (ip/ip6/ip_range) is derived from the value, never asked for; the schema's charset refuses hostnames and rule expressions outright — the restricted-primitive stance in practice. set_security_level (T2) steps one zone's level up to under_attack with the prior level captured and a missing zone refused as a failed change. set_pool_enabled (T2) is the manual LB failover lever — prior enabled state and pool name captured, missing pool refused with nothing written. The catalogue tier-table test now asserts all six ops verbatim (a drift is an ADR amendment, not a tweak).

    8 new tests through the full act() gate path (create-vs-overwrite rule paths, account-wide scope, CIDR family derivation, hostname refusal, invented-level refusal, prior-state capture, missing-target refusals). ruff + mypy (429 files) + 34 Cloudflare action/connector tests green; PR CI running.
assignee: steve
priority: medium
task_status: done
---
The security and load-balancing half of the ADR 0065 catalogue (decided with Steve 2026-07-31: restricted primitives only — no freeform WAF rule editing).

- `set_ip_access_rule` (T2): block / challenge / whitelist ONE IP or CIDR via the IP Access Rules API (`POST /zones/{zone_id}/firewall/access_rules/rules`, or account-wide via `/accounts/{id}/...` when no zone given). `before` records any existing rule for that target (mode overwritten) or its absence; rollback = delete the rule or restore the prior mode. The classic under-attack response.
- `set_security_level` (T2): step one zone's security level (`PATCH /zones/{zone_id}/settings/security_level` — essentially_off…under_attack). Prior level captured in `before`; Under Attack Mode on/off is this operation at its extremes.
- `set_pool_enabled` (T2): enable/disable ONE load-balancer pool (`PATCH /accounts/{id}/load_balancers/pools/{pool_id}`) — manual failover for LB incidents. Prior enabled state in `before`; pool named by id (pools are attributes, not entities — the target_fields carry the pool id + name).
- Same containment + execution-path test contract as ISE-395.