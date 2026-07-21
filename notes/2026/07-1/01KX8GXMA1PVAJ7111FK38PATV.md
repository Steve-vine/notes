---
id: 01KX8GXMA1PVAJ7111FK38PATV
created: 2026-07-11T12:02:33.409683397Z
updated: 2026-07-21T08:38:49.453017Z
type: task
title: Connector interface + registry
project: 01KX671DATY39VW6GWK3M2T3DN
number: 21
sprint: sdm5e08
comments:
- id: 01KX8N5S0QA0FSB92V36EHWT4X
  author: Steve Vine
  at: 2026-07-11T13:16:54.679712603Z
  text: 'Development complete on feature/ise-021-connector-interface. PR #22: https://github.com/Steve-vine/ise/pull/22. Connector ABC (read_state/detect/act) + declaration models (CredentialSpec, SyncSpec, ActionSpec tiered per ADR 0017 with tier validated at declaration; StateSlice/FindingData/HealthResult; ConnectorContext) + registry (@register_connector, get/list, dup/unknown rejected). /api/v1/connectors discovery endpoint (viewer) exposes specs + action catalogue, never secrets — feeds the Add-integration form / System-detail actions. Phase 2 uses read-state+detect; act declared only (executor is Phase 4). 88/88 tests incl. 13 new via a fake connector; OpenAPI types regenerated (api-types green). Staging deployed green; endpoint holds the 401 boundary and returns empty list (no concrete connectors yet — ISE-23/24 register into this). Awaiting smoke test + merge clearance.'
- id: 01KX8NJVDE2B72MK5GZ2TKKCRW
  author: Steve Vine
  at: 2026-07-11T13:24:03.118893763Z
  text: 'Smoke tests passed. PR #22 merged to main (32cd23b), branch deleted. Belt-and-braces main run green. Done.'
assignee: steve
label: null
priority: high
task_status: done
---
Common internal connector interface (ADR 0014): read-state / detect / act capability groups, plus declared credential spec, sync spec, and health check. Registry keyed by connector_type. Phase 2 implements read-state + detect only; act is declared (tiered catalogue structure) but not executed. Transport (MCP vs native) hidden behind the interface (connectors brief).