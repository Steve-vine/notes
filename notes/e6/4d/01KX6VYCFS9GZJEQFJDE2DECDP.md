---
id: 01KX6VYCFS9GZJEQFJDE2DECDP
created: 2026-07-10T20:36:43.64171091Z
updated: 2026-07-10T20:36:43.64171091Z
type: task
title: RBAC + break-glass access
assignee: steve
priority: high
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 13
---
Role model and enforcement plus the break-glass local-admin path for when EntraID itself is broken (ADR 0015 — ISE manages Entra, so auth must survive Entra outages). Break-glass use is loudly audited.