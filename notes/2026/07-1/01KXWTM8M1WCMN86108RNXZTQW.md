---
id: 01KXWTM8M1WCMN86108RNXZTQW
created: 2026-07-19T09:17:00.929499257Z
updated: 2026-07-21T16:39:22.660025Z
type: task
title: Connector Entities capability + automatic cross-tag resolution
project: 01KX671DATY39VW6GWK3M2T3DN
number: 127
sprint: sp5m61e
blocked_by:
- 01KXWTKZTHER145ZR0ARR81TMM
assignee: steve
priority: high
task_status: done
---
**Sprint 12 (spine).** Populate the graph from the integrations + resolve identity for free.

- Wire the **Entities** capability (ADR 0027) on the connector contract: DataDog + Kubernetes enumerate entities, native keys, and observable edges (`runs-on` / `hosted-on`).
- **Identity resolution tier 1 (free): harvest shared keys / cross-tags automatically** — a K8s deployment carries `tags.datadoghq.com/service`; DataDog metrics carry `kube_namespace` / `kube_deployment`. Where a shared key exists, auto-create the alias linking the two integrations' names to one entity.
- Discovery refreshed on a cadence (existence/placement is discovered; refreshed, not authored).
- Integration tests: a service tagged in both DataDog and K8s resolves to one entity.

Depends on the entity/alias model + the connector-capability contract (ADR 0027, done).