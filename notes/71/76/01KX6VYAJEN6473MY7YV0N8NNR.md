---
id: 01KX6VYAJEN6473MY7YV0N8NNR
created: 2026-07-10T20:36:41.6780951Z
updated: 2026-07-10T22:06:46.119782Z
type: task
title: Auth backend — EntraID OIDC, sessions, dev stub
assignee: steve
priority: high
task_status: active
project: 01KX671DATY39VW6GWK3M2T3DN
number: 12
blocked_by:
- 01KX6VXSDBE12B66M73JW8YX5Y
- 01KX6VXVPJGWSDV0M5XYA3EX00
sprint: sqtx330
---
EntraID OIDC sign-in with server-side sessions and a local dev-stub auth mode (ADR 0015). Sign-ins/sign-outs produce audit events. Auth enforced uniformly at the /api/v1 boundary (ADR 0009).