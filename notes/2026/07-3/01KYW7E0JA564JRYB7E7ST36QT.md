---
id: 01KYW7E0JA564JRYB7E7ST36QT
created: 2026-07-31T13:57:14.954474Z
updated: 2026-07-31T14:05:05.113328Z
type: task
title: 'Integration docs: Kubernetes'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 412
order: 1.125
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Replace the Kubernetes stub (`src/content/docs/integrations/kubernetes.md`) with full operator documentation:

- **Capabilities** — cluster state sync (nodes, workloads, namespaces, labels → tags), observation detectors (CrashLoopBackOff, OOMKill, pending pods, failing probes, cert expiry, resource saturation), evidence queries, workload action catalogue with risk tiers.
- **Setup** — connecting a cluster: cluster-scoped credentials/keys (ADR 0045), read vs write access, per-integration kind dictionary (ADR 0046).
- **Examples** — a crash-looping workload surfacing as an observation → incident; a governed rollout-restart through the approval flow.

Rewrite for operators, released capability only.