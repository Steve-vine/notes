---
id: 01KY515PBJZDA2XB0J4E9JSK9Z
created: 2026-07-22T13:45:18.962873Z
updated: 2026-07-22T15:24:31.468413Z
type: task
title: Deterministic edge harvest — K8s routes-to/runs-on, DataDog structure-from-tags
project: 01KX671DATY39VW6GWK3M2T3DN
number: 215
sprint: s5khymf
assignee: steve
label:
- feature
priority: high
task_status: active
---
Fill the dependency layer from what the platforms already know (Canon: source 2, "Deduced — integration structure"). Today only `part-of` containment is ever emitted; `depends-on`/`routes-to`/`runs-on` exist in `EDGE_TYPES` but nothing creates them.

- **Kubernetes** (`connectors/kubernetes.py` discover_entities):
  - `routes-to`: Service → selector-matched workloads (the K8s-native dependency fact);
  - `runs-on`: workload → node (from pod placement), node → cluster stays `part-of`.
- **DataDog** (`connectors/datadog.py`):
  - host `part-of` cluster from `kube_cluster_name`/`cluster_name` tags (minting the cluster entity if unknown);
  - APM service-dependency map → service `depends-on` service, where APM exists (contained source, graceful degradation like the other discovery sources).
- All refreshed per discovery with `last_confirmed_at` (existing `_upsert_edge`), so `drift.py` covers them automatically. Harvested resolution — never touches asserted edges.
- **UI (DoD)**: the new edges appear in the existing entity Dependency graph panel — verify the graph stays legible on a node with many workloads (cap/cluster the fan-out in the view if needed).
- Tests: selector matching incl. multi-service overlap; idempotent re-discovery; DataDog degradation when APM absent.