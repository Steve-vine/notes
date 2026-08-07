---
id: 01KYW7E0JA564JRYB7E7ST36QT
created: 2026-07-31T13:57:14.954474Z
updated: 2026-08-07T10:57:16.218922Z
type: task
title: 'Integration docs: Kubernetes'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 412
order: 1.125
sprint: sp3en5k
comments:
- id: 01KYW85BD67TC7QAKR8AKQ4SRV
  author: Steve Vine
  at: 2026-07-31T14:09:59.718727Z
  text: |-
    Done on feature/ise-412-docs-kubernetes — PR #10, left OPEN for the PR-preview test.

    Full Kubernetes page: capabilities (cluster/namespace/workload/node discovery, labels → tag pool, containment edges; the seven observation detectors — crashloop, oom_kill, pending_pod, unhealthy_workload, node_not_ready, node_pressure, node_flapping — with the fixed-confidence framing; evidence describe_pod/pod_logs/recent_events/pending_pods/rollout_status/node_capacity; actions set_label/restart_rollout/scale_workload T1, edit_resource T2, delete_resource T3), setup (kubeconfig + optional context, store-time validation, read-only RBAC list with explicit no-secrets, per-cluster instance), examples (crashloop→incident, governed restart/revert). Facts from connectors/kubernetes.py. Build/lint green.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the Kubernetes stub (`src/content/docs/integrations/kubernetes.md`) with full operator documentation:

- **Capabilities** — cluster state sync (nodes, workloads, namespaces, labels → tags), observation detectors (CrashLoopBackOff, OOMKill, pending pods, failing probes, cert expiry, resource saturation), evidence queries, workload action catalogue with risk tiers.
- **Setup** — connecting a cluster: cluster-scoped credentials/keys (ADR 0045), read vs write access, per-integration kind dictionary (ADR 0046).
- **Examples** — a crash-looping workload surfacing as an observation → incident; a governed rollout-restart through the approval flow.

Rewrite for operators, released capability only.