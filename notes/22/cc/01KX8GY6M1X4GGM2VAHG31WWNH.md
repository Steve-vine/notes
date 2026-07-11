---
id: 01KX8GY6M1X4GGM2VAHG31WWNH
created: 2026-07-11T12:02:52.161581012Z
updated: 2026-07-11T15:31:22.424717348Z
type: task
title: DataDog connector — read-state + detect (MCP-first)
task_status: review
assignee: steve
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 24
blocked_by:
- 01KX8GXMA1PVAJ7111FK38PATV
sprint: sdm5e08
---
MCP-first (ADR 0014): front the official DataDog MCP server, native API for gaps; ISE owns the MCP client. read-state: monitors, dashboard defs, active metrics summary, service map. detect: monitor alerts, events. Health check. Credential spec: API + app key, read-only scopes. Contract tests against recorded/fake fixtures (ADR 0016). Credential shapes added to the redaction list.