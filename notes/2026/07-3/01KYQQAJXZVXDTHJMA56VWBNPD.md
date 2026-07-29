---
id: 01KYQQAJXZVXDTHJMA56VWBNPD
created: 2026-07-29T19:58:47.7435Z
updated: 2026-07-29T22:19:07.996632Z
type: task
title: Azure Monitor alerts → Alert signals
project: 01KX671DATY39VW6GWK3M2T3DN
number: 366
sprint: s0d5f5q
blocked_by:
- 01KYQQA7N6RWFYHQ148JMVWA8H
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Mirror of ISE-360 (CloudWatch alarms). Poll fired/resolved alerts from Azure Monitor (Alerts Management API) → Alert signals attributed to discovered entities via the alert's target resource id; Azure Sev0–Sev4 mapped onto the canonical severity ladder. Dedupe/reinforcement against DataDog/K8s signals via same-entity attribution + existing merge candidates — no new cross-source architecture.