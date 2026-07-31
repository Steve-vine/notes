---
id: 01KYVNY07N3X03ESHJG5C6V9CZ
created: 2026-07-31T08:51:24.533316Z
updated: 2026-07-31T08:51:24.533316Z
type: task
title: EntraID alert signals — Identity Protection risky users
label: feature
assignee: steve
task_status: backlog
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 389
---
`detect()` polls `identityProtection/riskyUsers` filtered riskState atRisk|confirmedCompromised (tenant has P2) — a stateful presence contract like Azure's monitorCondition=Fired: only currently-at-risk users returned; reconcile_findings derives recovered when a user leaves the set (remediated/dismissed both read as recovery). `source_key = riskyuser/{object_id}` (stable across re-fires), `entity_key` joins the discovery user entity, `kind = "identity-protection"` for ADR 0026 per-service tuning. Severity map riskLevel low/medium/high → canonical ladder with conservative default. riskDetections are evidence, not alerts (point-in-time events would churn presence). servicePrincipalRiskDetections out of scope (separate Workload Identities licence — note in ADR 0063). Detect failures degrade to [] , never kill the sync. Tests: firing/recovery lifecycle across two detect passes, severity mapping, source_key stability.