---
id: 01KYAE4ZTVJQY1NT1CY9R0S5NY
created: 2026-07-24T16:08:19.547626Z
updated: 2026-08-07T10:06:36.857357Z
type: task
title: Argo Rollout preset + end-to-end acceptance on env-staging-us
project: 01KX671DATY39VW6GWK3M2T3DN
number: 259
sprint: s5khymf
comments:
- id: 01KYAHVZDYFSVG0DXNV7PX4YV2
  author: Steve Vine
  at: 2026-07-24T17:13:18.526829Z
  text: |-
    Moved to Review. PR #242 → main (https://github.com/Steve-vine/ise/pull/242).

    Code deliverable shipped — the one-click Argo Rollout preset:
    - `kind_dictionary.PRESETS`: the canonical Rollout entry (owns ReplicaSets like a Deployment, default replica paths, `kube_rollout` DataDog scope tag — the tag ISE-254 resolves through, actions off per ADR 0046 §6).
    - GET `/kind-dictionary` returns `presets` (drops any already added); KindDictionaryCard renders preset buttons that pre-fill the add form in one click.

    Tests: preset validity, preset offered + drops-out-once-added, one-click form fill.

    **Live acceptance is a staging smoke test** (needs the deployed app + env-staging-us cluster, which only exists after the staging release). Checklist to run once staging is up:
    1. On the env-staging-us integration → Kind Dictionary → click the **Rollout** preset → **Test against cluster** passes → **Add kind**.
    2. Trigger a sync → the Chinwag Rollouts appear in Estate under **Workload** with scoped keys `k8s:{system_id}:{ns}/rollout/{name}`.
    3. Graph shows part-of-namespace + runs-on-node edges; pod crash/OOM observations roll up to the Rollout workload.
    4. Baselines record desired==ready for the Rollouts.
    5. (When a `kube_rollout`-scoped DataDog monitor fires) the alert resolves to the Rollout workload (ISE-254).
    6. Set the DataDog cluster name (ISE-255) so env-staging-us joins as one cluster entity.
- id: 01KYAYGFRTA952R7DFVNA5B5FE
  author: Steve Vine
  at: 2026-07-24T20:54:13.529947Z
  text: 'Smoke test complete on env-staging-us (Steve, 2026-07-24) — moving to Done. Argo Rollout preset acceptance passed: RBAC granted, Rollouts discover as workloads with scoped keys, part-of/runs-on edges, pod-obs rollup and baselines. Released to main (PR #242).'
assignee: steve
priority: medium
task_status: done
---
Ship `Rollout.argoproj.io/v1alpha1 → workload` as a one-click preset in the Kind Dictionary (all touchpoints known: owns ReplicaSets like Deployment; replicas at the default `spec.replicas`/`status.readyReplicas`; DataDog scope tag `kube_rollout`; restart is `spec.restartAt` — actions stay off per ISE-256), and prove the whole slice on the real cluster.

Acceptance on env-staging-us (the motivating case, found 2026-07-24 — Chinwag apps are Rollout-managed and currently invisible):
- Enable the preset → next sync discovers the Chinwag Rollout workloads with scoped native keys.
- Estate list shows them under Workload; graph shows part-of namespace + runs-on node edges; pod observations roll up to the Rollout workload.
- Baselines record desired==ready for Rollouts.
- The `kube_rollout` scope tag is registered so DataDog alert resolution can target Rollout workloads once ISE-254 lands (coordinate the tag format with that fix).

This is the sprint's demo: "the apps you couldn't see, now on the pane of glass."

Depends on ISE-257 and ISE-258.