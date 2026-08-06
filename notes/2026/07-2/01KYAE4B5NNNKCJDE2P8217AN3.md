---
id: 01KYAE4B5NNNKCJDE2P8217AN3
created: 2026-07-24T16:07:58.389023Z
updated: 2026-08-06T08:34:50.038425Z
type: task
title: Dictionary-driven Kubernetes discovery (custom kinds become workloads)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 257
sprint: s5khymf
comments:
- id: 01KYAFWAH1P4653FWP3DS0XBDR
  author: Steve Vine
  at: 2026-07-24T16:38:32.737288Z
  text: |-
    Moved to Review. PR #238 → main (https://github.com/Steve-vine/ise/pull/238), stacked on ISE-256 (#237).

    Wired the kind dictionary into the connector:
    - Discovery via the dynamic custom-objects API (KubeApis gains optional `custom` client); custom workloads get scoped native keys, part-of + runs-on edges, template-label tags, datadog:service cross-key; selectable updated so Services route-to them.
    - Owner chain generalised (`_replicaset_owners`/`_pod_workload_key`/`_placement`/`_workload_key` read the dictionary) — Rollout owns ReplicaSets like a Deployment; pod-obs rollup (ISE-241) and runs-on placement light up for custom kinds.
    - Baselines: desired==ready via the entry's replica JSONPaths.
    - RBAC degradation per-kind (`_contained`) — a CRD the credential can't list contributes nothing, never a sync failure (ADR 0031).
    - Write actions stay OFF for custom kinds.

    Tests: 8 new connector cases (discovery/edges, Service routes-to, pod-obs rollup vs namespace fallback, replica baselines, RBAC degrade, cluster-scoped disjoint keys) + an end-to-end sync integration test landing a Rollout as an estate entity. Full suite (301 unit + K8s integration) green; ruff + format + bare mypy clean. No OpenAPI drift.
assignee: steve
label: null
priority: medium
task_status: done
---
Implement the ISE-256 dictionary in the connector: workload discovery, the pod→owner chain, and baselines all read the System's kind dictionary instead of the hard-coded Deployment/StatefulSet/DaemonSet trio.

- Discovery: list custom kinds via the custom-objects (dynamic) API using the entry's GVK/plural; mint scoped native keys (`k8s:{system_id}:{ns}/{kind}/{name}`); emit part-of-namespace edges, pod-template labels as tags, and the `tags.datadoghq.com/service` cross-key exactly as the built-ins do.
- Owner chain: generalise `_placement`/pod-owner resolution to follow `ownerReferences` to any dictionary-known kind (Rollout owns ReplicaSets directly, like Deployment; some CRDs own pods directly). This is what lights up runs-on edges and pod-obs→workload rollup (ISE-241) for custom kinds.
- Baselines (ADR 0030 §4): desired==ready via the entry's replica paths (default `spec.replicas`/`status.readyReplicas`).
- RBAC/degradation: a dictionary entry whose CRD the credential cannot list must degrade gracefully per the ADR 0031 capability pattern (surfaced per-integration, not a sync failure).
- No write actions for custom kinds (per ISE-256).

Tests per ISE-246's precedent: a fake CRD kind discovers entities/edges disjoint per cluster; pod-obs resolves to a custom-kind workload; missing RBAC degrades cleanly.

Depends on ISE-256.