---
id: 01KYVNY07N3X03ESHJG5C6V9CZ
created: 2026-07-31T08:51:24.533316Z
updated: 2026-08-07T12:15:50.352033Z
type: task
title: EntraID alert signals — Identity Protection risky users
project: 01KX671DATY39VW6GWK3M2T3DN
number: 389
order: 1.5
sprint: setdxf2
blocked_by:
- 01KYVNXV67JWEJ5P3SP2893CTS
comments:
- id: 01KYVSXJS2MFVAFJW37GNC1K2B
  author: Steve Vine
  at: 2026-07-31T10:01:05.058478Z
  text: |-
    Built and pushed — PR #366 (feature/ise-389-entraid-alert-signals, stacked on #365).

    Delivered: detect() over identityProtection/riskyUsers filtered atRisk|confirmedCompromised — the stateful presence contract; source_key riskyuser/{object_id}; entity_key joins the ISE-388 user entity; kind identity-protection; riskLevel mapped subset-wise with medium default, admin-confirmed compromise escalated to at-least-high, critical never minted. Signal tags entra_risk:{level} feed the Tag Cloud. Read failures degrade to [].

    Tests: 8 new incl. two real-Postgres lifecycle tests — attribution onto the discovered user entity via ordinary linking, and the two-sweep firing→recovered derivation proving no connector state machine is needed. One test asserts the $filter itself (load-bearing: without it dismissed users would keep firing). ruff + mypy strict green.
assignee: steve
label: null
priority: medium
task_status: done
---
`detect()` polls `identityProtection/riskyUsers` filtered riskState atRisk|confirmedCompromised (tenant has P2) — a stateful presence contract like Azure's monitorCondition=Fired: only currently-at-risk users returned; reconcile_findings derives recovered when a user leaves the set (remediated/dismissed both read as recovery). `source_key = riskyuser/{object_id}` (stable across re-fires), `entity_key` joins the discovery user entity, `kind = "identity-protection"` for ADR 0026 per-service tuning. Severity map riskLevel low/medium/high → canonical ladder with conservative default. riskDetections are evidence, not alerts (point-in-time events would churn presence). servicePrincipalRiskDetections out of scope (separate Workload Identities licence — note in ADR 0063). Detect failures degrade to [] , never kill the sync. Tests: firing/recovery lifecycle across two detect passes, severity mapping, source_key stability.