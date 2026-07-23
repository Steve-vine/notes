---
id: 01KXTRWDAAVEPFYT4BSH1AB47M
created: 2026-07-18T14:08:01.86654981Z
updated: 2026-07-23T18:32:53.642047Z
type: task
title: Connector capability reshape + DataDog monitors-only Alerts
project: 01KX671DATY39VW6GWK3M2T3DN
number: 116
sprint: stgj737
assignee: steve
label: null
priority: high
task_status: done
---
**Sprint 11 (spine).** Reshape `connectors/base.py` to **declared capabilities** (per the ADR), and cut DataDog over.

- **DataDog** (`connectors/datadog.py`): produce **Alerts from monitor state only**, keyed `monitor/{id}/{group}`, reading **per-group** state (`monitor.state.groups`, not just `overall_state`) so multi-alert monitors split per scope; expose metrics/logs/events/dashboards/service-map as **Evidence (on-demand)**, not detection; **retire `_event_findings` and metric/event detection** — a large idle-spend cut that also removes the alert/event double-surfacing. Keep the action catalogue (Actions capability).
- Update `sync.py` and the connector registry for capability declaration + graceful degradation.

Integration tests: a firing monitor → exactly one Alert per triggering group; metric/event churn no longer creates signals/issues. Depends on the connector-contract ADR + Signal models.