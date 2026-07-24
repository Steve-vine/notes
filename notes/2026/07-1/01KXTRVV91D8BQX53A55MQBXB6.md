---
id: 01KXTRVV91D8BQX53A55MQBXB6
created: 2026-07-18T14:07:43.39388858Z
updated: 2026-07-24T16:07:42.602646Z
type: task
title: 'ADR: Connector capability contract'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 112
sprint: stgj737
assignee: steve
label: null
priority: high
task_status: done
---
**Sprint 11 (spine).** Record the move from the single-shape connector base (`connectors/base.py` — `sync_spec`/`read_state`/`detect`/`act`) to **capability-declared Integration Types**: **Alerts, Observations, Entities, Evidence, Actions** (+ lifecycle: credential spec, health), each optional; the platform degrades gracefully by capability.

- *Semantic* capabilities (Alerts/Observations/Entities) map source concepts onto ISE's canonical model — shared contract shape + small per-source mapping. *Tool* capabilities (Evidence/Actions) are generic-able (e.g. MCP). Principle: the more governance a capability needs, the less generic it can be (read-only Evidence cheapest; governed Actions carry per-source `ActionSpec` tier/reversibility).
- **Integration Type** (developer, code, tested) → **Integration** (admin, creds + config = today's `System`) → **User** (interacts). Bright line: any coding element = developer.

Operationalises/extends **ADR 0014** (MCP-first). The independently-deployable end-state is a *separate later ADR* (Sprint 15). Deliverable: `docs/decisions/NNNN-connector-capability-contract.md`.