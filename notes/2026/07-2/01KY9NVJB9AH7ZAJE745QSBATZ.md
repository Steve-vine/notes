---
id: 01KY9NVJB9AH7ZAJE745QSBATZ
created: 2026-07-24T09:03:45.001708Z
updated: 2026-07-24T12:49:57.16214Z
type: task
title: K8s native keys are unscoped by cluster — multi-cluster discovery merges entities across clusters
project: 01KX671DATY39VW6GWK3M2T3DN
number: 246
sprint: s5khymf
assignee: steve
label: null
priority: high
task_status: review
---
Found (Steve, 2026-07-24) after connecting env-staging-us alongside g5: the Chinwag app's namespace `chinwag-v2-test` shows part-of the **g5** cluster, and g5 host/cluster appear connected to everything.

Cause: every native key the Kubernetes connector mints is unscoped by cluster (`connectors/kubernetes.py`):
- `_CLUSTER_KEY = "k8s:cluster"` — a literal constant: all K8s integrations resolve to ONE cluster entity (named by whichever system synced last, so the display name can flip-flop between clusters).
- `k8s:namespace:{name}` — guaranteed collisions (`kube-system`, `default` exist everywhere); both clusters' workloads hang off the same namespace entities.
- `k8s:{ns}/{kind}/{name}`, `k8s:{ns}/service/{name}` — workload/service collisions (`kube-system/daemonset/kube-proxy` etc.).
- `k8s:node:{name}` — safe only by accident (EC2-shaped names vs "g5").

ADR 0028's reconcile then *actively merges* the colliding entities — the harvested tier assumes native keys are globally unique; the connector broke that assumption the moment a second cluster connected. Corruption compounds on every sync. Blast radius, impact and investigation context all read the corrupted graph.

Fix (this task = the key scheme; data cleanup is ISE-245's Nuke button):
- **Scope every K8s native key by integration** — e.g. `k8s:{system_id}:namespace:{name}`, `k8s:{system_id}:{ns}/{kind}/{name}`, cluster key `k8s:{system_id}:cluster` — so each integration owns its key space. Use a stable discriminator (system id, not display name, which is renameable).
- **Scope `_workload_key` identically** — signals (Obs Loop detectors, drift) target entities through it; a mismatch would dangle every K8s observation. Same for the namespace fallback keys and any other `f"k8s:..."` construction in the connector (audit them all).
- **Leave DataDog cross-keys (`datadog:service:{name}`) untouched** — those are *deliberately* cross-integration join keys (ADR 0028 harvested tier); only the K8s-owned key space gets scoped.
- **ADR required**: this changes the ADR 0028 native-key scheme — new ADR (append-only, supersedes/amends the key format), per the hard rule on recording architecture decisions. Record in the ISE Canon memo too (standing instruction).
- Tests: two fake integrations with identically-named namespaces/workloads discover as distinct entities with distinct keys; detector-targeted observations land on the correctly-scoped entity; DataDog cross-key still joins.

Sequencing: independent of the graph batch (ISE-233..238, 240..244). After deploy, existing polluted entities are cleared via ISE-245 (Nuke discovered data) and re-discovered under scoped keys — pre-release, no live-data migration needed; the ADR should note that a production system would have required an alias-rewrite migration instead.

Done when: two K8s clusters connected simultaneously discover fully disjoint entity sets (distinct cluster/namespace/workload/service/node entities), signals target the right cluster's entities, and the cross-integration DataDog join still works.