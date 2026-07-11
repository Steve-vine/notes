---
id: 01KX8GXMA1PVAJ7111FK38PATV
created: 2026-07-11T12:02:33.409683397Z
updated: 2026-07-11T13:16:48.848492958Z
type: task
title: Connector interface + registry
assignee: steve
priority: high
task_status: review
project: 01KX671DATY39VW6GWK3M2T3DN
number: 21
sprint: sdm5e08
---
Common internal connector interface (ADR 0014): read-state / detect / act capability groups, plus declared credential spec, sync spec, and health check. Registry keyed by connector_type. Phase 2 implements read-state + detect only; act is declared (tiered catalogue structure) but not executed. Transport (MCP vs native) hidden behind the interface (connectors brief).