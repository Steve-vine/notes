---
id: 01KYAE4ZTVJQY1NT1CY9R0S5NY
created: 2026-07-24T16:08:19.547626Z
updated: 2026-07-24T16:09:36.203834Z
type: task
title: Argo Rollout preset + end-to-end acceptance on env-staging-us
project: 01KX671DATY39VW6GWK3M2T3DN
number: 259
sprint: s5khymf
assignee: steve
priority: medium
task_status: backlog
---
Ship `Rollout.argoproj.io/v1alpha1 → workload` as a one-click preset in the Kind Dictionary (all touchpoints known: owns ReplicaSets like Deployment; replicas at the default `spec.replicas`/`status.readyReplicas`; DataDog scope tag `kube_rollout`; restart is `spec.restartAt` — actions stay off per ISE-256), and prove the whole slice on the real cluster.

Acceptance on env-staging-us (the motivating case, found 2026-07-24 — Chinwag apps are Rollout-managed and currently invisible):
- Enable the preset → next sync discovers the Chinwag Rollout workloads with scoped native keys.
- Estate list shows them under Workload; graph shows part-of namespace + runs-on node edges; pod observations roll up to the Rollout workload.
- Baselines record desired==ready for Rollouts.
- The `kube_rollout` scope tag is registered so DataDog alert resolution can target Rollout workloads once ISE-254 lands (coordinate the tag format with that fix).

This is the sprint's demo: "the apps you couldn't see, now on the pane of glass."

Depends on ISE-257 and ISE-258.