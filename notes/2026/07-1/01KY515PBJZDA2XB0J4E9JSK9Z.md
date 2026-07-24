---
id: 01KY515PBJZDA2XB0J4E9JSK9Z
created: 2026-07-22T13:45:18.962873Z
updated: 2026-07-24T16:09:45.855955Z
type: task
title: Deterministic edge harvest — K8s routes-to/runs-on, DataDog structure-from-tags
project: 01KX671DATY39VW6GWK3M2T3DN
number: 215
sprint: s5khymf
comments:
- id: 01KY57M4AFTMZ7322QY4FTZVJ7
  author: Steve Vine
  at: 2026-07-22T15:38:03.471391Z
  text: |-
    Done — PR #194 (feature/ise-215-edge-harvest), stacked on #193/ISE-211. Unblocks ISE-216.

    **Kubernetes.** `discover_entities` now emits both facts you specified. `routes-to` from Service → selector-matched workloads, with real selector semantics: every selector entry must match, extra pod labels are irrelevant, and a selectorless Service (ExternalName, manually-endpointed) selects **nothing** rather than everything. Multi-service overlap works and both edges are real, as you called out. `runs-on` from workload → node, resolved through **owner references** (Deployment → ReplicaSet → Pod) rather than by re-matching labels — label matching would attribute a hand-made pod wearing the same labels to the workload, which isn't true. Node → cluster stays `part-of` as specified.

    Services are now discovered entities in their own right (`k8s:{ns}/service/{name}`), which they weren't before — necessary to hang `routes-to` off. They carry the DataDog service cross-key where the unified-tagging label is present.

    **DataDog.** Host `part-of` cluster from `kube_cluster_name`/`cluster_name`, minting the cluster entity as specified. APM `dependsOn` → service `depends-on` service; both schema shapes are read (`spec.dependsOn` and flat) because the generated client models the service-definition schema as a versioned union and the field moved.

    **Graceful degradation** — the two new Kubernetes sources are contained, so a kubeconfig without pod or service list rights still yields the inventory it can see, minus the edges. The inventory sources stay uncontained on purpose: if namespaces or workloads fail, the sync *should* fail. Tested.

    All edges go through the existing `_upsert_edge`, so `last_confirmed_at` and `drift.py` cover them automatically and `harvested` resolution never touches asserted edges — as specified.

    **On the UI check you asked for: the fan-out was a real problem.** The radial graph had no cap at all, and `runs-on` makes a node carry one spoke per workload placed on it — on this estate that's dozens. Forty spokes on one ring renders as a grey disc. Each hop ring now caps at 12, sorted by name so the cut is stable between polls rather than reshuffling under the reader, with "N more neighbours not shown" stated below it. A silently-clipped diagram would misrepresent how connected the estate is, which is the verifiability principle applied to the graph.

    **Tests** — 11 new in `test_connector_discovery.py` covering everything you listed (selector matching incl. multi-service overlap, idempotence via the existing upsert path, DataDog degradation without APM) plus the edge cases: extras-tolerated matching, selectorless Services, unscheduled/bare pods, and the pods-and-services-forbidden degradation path. One new frontend test for the ring cap. The k8s test fake gained `list_service_for_all_namespaces`.

    Backend 918 passed, ruff + mypy strict clean; frontend 298 passed, lint/build clean.

    **Worth knowing for the smoke test:** on staging this will produce few or no edges from DataDog — the estate has no APM `dependsOn` declared, and per ISE-205 the DataDog and g5 estates are disjoint. The Kubernetes edges are where the visible change will be.
assignee: steve
priority: high
task_status: done
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