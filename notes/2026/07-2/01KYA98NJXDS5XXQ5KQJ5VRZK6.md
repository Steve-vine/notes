---
id: 01KYA98NJXDS5XXQ5KQJ5VRZK6
created: 2026-07-24T14:42:57.245248Z
updated: 2026-07-24T14:43:30.490834Z
type: task
title: DataDog kube-scoped alert resolution broken by scoped native keys
project: 01KX671DATY39VW6GWK3M2T3DN
number: 254
sprint: s5khymf
assignee: steve
label:
- bug
priority: high
task_status: backlog
---
Regression from ISE-246 (ADR 0045), currently latent. `_signal_entity_key` (`connectors/datadog.py:374`) still mints the old **unscoped** workload key for monitors scoped by `kube_namespace` + `kube_deployment`:

```
k8s:{ns}/deployment/{name}
```

Post-ADR-0045, workload native keys are `k8s:{system_id}:{ns}/deployment/{name}`, so this key can never resolve — the first kube-scoped monitor that fires will land with `entity_key` set but `entity_id` null: unattached to its workload, so no blast radius, no incident context, no graph signal glow. Verified on the live estate 2026-07-24: no kube-scoped alerts are currently firing (the 20 unattached alerts are Meraki/Azure/synthetics with no kube tags; host-scoped ones resolve fine), which is the only reason nothing is visibly broken. The ISE-246 tests covered the *discovery-side* join (K8s workload emits `datadog:service:{name}` cross-key — still works); this is the separate alert-scope resolution path.

Design wrinkle: DataDog cannot know which K8s System's id to prefix. Options:
1. Suffix/LIKE match at resolution time (`native_key LIKE 'k8s:%:{ns}/deployment/{name}'`) — simple, but ambiguous with multiple clusters running same-named workloads (the exact collision ADR 0045 fixed).
2. Map the monitor's `kube_cluster`/cluster tag → K8s System, then build the scoped key — correct, needs a cluster-name→System mapping.
3. Unscoped secondary alias on workloads (the node-key approach ADR 0045 §2 took) — reintroduces the collision for workloads; probably ruled out.

Option 2 is the principled one. Whatever is chosen, amend ADR 0045 with the resolution rule.