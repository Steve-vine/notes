---
id: 01KY86NF52BYPE2EAR3AZE1K7Y
created: 2026-07-23T19:19:02.050145Z
updated: 2026-07-24T12:32:38.002829Z
type: task
title: Pod-level observations resolve to the namespace — associate transient K8s objects to their workload
project: 01KX671DATY39VW6GWK3M2T3DN
number: 239
sprint: s5khymf
comments:
- id: 01KY8AZPAFWGJVW132DZ1B66H4
  author: Steve Vine
  at: 2026-07-23T20:34:31.375519Z
  text: |-
    Done on feature/ise-239-pod-obs-workload (PR #223, from main — independent of the graph batch).

    _pod_observations now resolves each pod's owning workload via owner references (Pod → ReplicaSet → Deployment, or StatefulSet/DaemonSet directly) and targets that (k8s:{ns}/{kind}/{name} — the key discovery mints). Bare pods and Jobs fall back to the namespace, the one case where that was ever right.

    The owner-chain logic already lived inside _placement (ISE-215); extracted it as _replicaset_owners + _pod_workload_key and reused it there, so placement and observations share one resolver. source_keys are unchanged (they carry pod/container identity for dedup/flapping); only the target entity moves.

    One-time churn (flagged in the PR): on the first sweep after deploy, existing open findings keyed to the namespace close and re-open against the workload — the ADR 0038 flapping/implicit-ack fold keys on source_key, which is unchanged, so nothing double-fires.

    Backend-only, no migration. Test: Deployment-owned crashloop → k8s:ise/deployment/web; StatefulSet OOM → the set; bare pod → the namespace. Connector (24) + k8s-sync + discovery suites + mypy + ruff green.
assignee: steve
label: null
priority: medium
task_status: done
---
Principle (Steve, 2026-07-23): transient Kubernetes objects should be associated to the workload that owns them.

Today the Obs Loop's pod-level detectors (`connectors/kubernetes.py`, `_pod_observations` — Pending, CrashLoopBackOff, OOM-kill) target the *namespace* entity ("a pod is not a discovered estate entity, so these resolve to its namespace", ISE-128). The precise, actionable finding — "container X in pod Y is crash-looping, 14 restarts" — glows on the namespace node, which in a busy namespace says little; meanwhile `_unhealthy_workloads` separately lands a coarser ready&lt;desired observation on the workload. The operator-facing signal sits one level away from the thing they'd actually restart.

The machinery to do better already exists in the same file: `_placement()` resolves Pod → ReplicaSet → Deployment (and Pod → StatefulSet/DaemonSet) through owner references — the pod detectors just predate it (ISE-128 vs ISE-215) and don't use it.

Scope (backend-only):
- In `_pod_observations`, resolve each pod's owning workload via owner references (reuse/extract the `_placement()` owner-chain logic: ReplicaSet→Deployment; StatefulSet/DaemonSet direct) and set `entity_key=_workload_key(...)`.
- Fallback to the namespace key for pods with no workload owner (bare pods, Jobs) — current behaviour preserved for exactly the cases where it's right.
- Keep `source_key`s unchanged (they carry pod/container identity for dedup/flapping); only the target entity moves.
- Check the flapping/implicit-ack fold (ADR 0038) isn't disturbed by re-targeted findings — existing open findings keyed to the namespace will close and re-open against the workload on first run after deploy; note this as expected one-time churn in the PR.
- Tests: detector unit tests asserting a crash-looping pod owned by a Deployment yields `entity_key=k8s:{ns}/deployment/{name}`; a bare pod still yields the namespace key.

Payoff: with ISE-229 severity glow, the crashloop/OOM glow appears on the workload node an operator would restart, and workload-rooted impact/blast-radius views carry the pod-level evidence.

Independent of the six graph tasks (ISE-233..238) — no shared files.

Done when: a restarting pod's CrashLoopBackOff/OOM/Pending observations attach to the owning workload entity (namespace only for ownerless pods), visible on the workload node in the estate graph.