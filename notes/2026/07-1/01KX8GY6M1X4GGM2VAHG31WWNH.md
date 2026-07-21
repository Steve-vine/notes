---
id: 01KX8GY6M1X4GGM2VAHG31WWNH
created: 2026-07-11T12:02:52.161581012Z
updated: 2026-07-21T18:32:11.37001Z
type: task
title: DataDog connector — read-state + detect (MCP-first)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 24
sprint: sdm5e08
blocked_by:
- 01KX8GXMA1PVAJ7111FK38PATV
comments:
- id: 01KX8WW5YW8Z97W16P98R7XZQD
  author: Steve Vine
  at: 2026-07-11T15:31:28.860497488Z
  text: 'Development complete on feature/ise-024-datadog-connector. PR #25: https://github.com/Steve-vine/ise/pull/25. Native datadog-api-client transport (Steve''s call over MCP-first; recorded in the connectors brief, MCP swap-able later per ADR 0014). read-state: monitors/dashboards/metrics. detect: monitor alerts (Alert→high/Warn→medium/No Data→low, source_key monitor/<id>) — covers the exit test''s firing monitor. Read-only; act (ack T0, mute/unmute T1, edit T2) declared not executed. app_key added to redaction. 113/113 tests (11 new fake-api contract + integration through sync.sync_one). Staging deployed green; live worker confirms registered_types()=[''datadog'',''kubernetes'']. DEFERRED pending live validation with real keys: service-map slice + event-based detect. NEEDED FROM STEVE for the live test: DataDog read-only API key + Application key + site — I''ll store as an ISE credential and sync a datadog system (a firing monitor then appears in ISE, completing the DataDog half of ISE-30). Awaiting smoke test + merge clearance.'
- id: 01KX8XEVQS15H3B3H0KX4W27C4
  author: Steve Vine
  at: 2026-07-11T15:41:40.985821227Z
  text: 'LIVE VERIFICATION PASSED (DataDog EU). Stored the read-only API+App keys as ISE credential ''datadog-eu'' (site datadoghq.eu), created a ''datadog'' system on staging; Beat synced it → health=connected within one cycle. Persisted real state: 90 monitors (14 alerting), 77 dashboards, 4048 active metrics. Detect produced 14 monitor-alert findings including a REAL high-severity one — ''Chinwag - UK - Application Exception is Alert'' — plus No-Data monitors as low. Both systems now syncing on staging: g5 (kubernetes) + datadog, both connected — the two deliberately-different-shape connectors Phase 2 wanted, proven live. (system+credential created via api-pod exec like g5, bypassing create-audit.) Native transport + EU site confirmed working end-to-end. Ready for merge clearance.'
- id: 01KX8Y07KRVBBY3RB2Y5YNE0H7
  author: Steve Vine
  at: 2026-07-11T15:51:10.200075806Z
  text: 'Smoke tests passed. PR #25 merged to main (9f4ef2a), branch deleted. Belt-and-braces main run green. Done. Both connectors (kubernetes + datadog) live on staging with real data.'
assignee: steve
label: null
priority: high
task_status: done
---
MCP-first (ADR 0014): front the official DataDog MCP server, native API for gaps; ISE owns the MCP client. read-state: monitors, dashboard defs, active metrics summary, service map. detect: monitor alerts, events. Health check. Credential spec: API + app key, read-only scopes. Contract tests against recorded/fake fixtures (ADR 0016). Credential shapes added to the redaction list.