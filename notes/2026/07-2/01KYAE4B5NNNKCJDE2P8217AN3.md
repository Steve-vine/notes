---
id: 01KYAE4B5NNNKCJDE2P8217AN3
created: 2026-07-24T16:07:58.389023Z
updated: 2026-07-24T16:07:58.389023Z
type: task
title: Dictionary-driven Kubernetes discovery (custom kinds become workloads)
assignee: steve
label: feature
priority: medium
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 257
---
Implement the ISE-256 dictionary in the connector: workload discovery, the pod→owner chain, and baselines all read the System's kind dictionary instead of the hard-coded Deployment/StatefulSet/DaemonSet trio.

- Discovery: list custom kinds via the custom-objects (dynamic) API using the entry's GVK/plural; mint scoped native keys (`k8s:{system_id}:{ns}/{kind}/{name}`); emit part-of-namespace edges, pod-template labels as tags, and the `tags.datadoghq.com/service` cross-key exactly as the built-ins do.
- Owner chain: generalise `_placement`/pod-owner resolution to follow `ownerReferences` to any dictionary-known kind (Rollout owns ReplicaSets directly, like Deployment; some CRDs own pods directly). This is what lights up runs-on edges and pod-obs→workload rollup (ISE-241) for custom kinds.
- Baselines (ADR 0030 §4): desired==ready via the entry's replica paths (default `spec.replicas`/`status.readyReplicas`).
- RBAC/degradation: a dictionary entry whose CRD the credential cannot list must degrade gracefully per the ADR 0031 capability pattern (surfaced per-integration, not a sync failure).
- No write actions for custom kinds (per ISE-256).

Tests per ISE-246's precedent: a fake CRD kind discovers entities/edges disjoint per cluster; pod-obs resolves to a custom-kind workload; missing RBAC degrades cleanly.

Depends on ISE-256.