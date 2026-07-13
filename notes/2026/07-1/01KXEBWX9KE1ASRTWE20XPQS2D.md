---
id: 01KXEBWX9KE1ASRTWE20XPQS2D
created: 2026-07-13T18:30:13.555013903Z
updated: 2026-07-13T18:30:13.555013903Z
type: task
title: Read-state is too thin for the AI to propose a concrete fix
assignee: steve
task_status: active
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 58
---
Found by the ISE-53 exit test (2026-07-13). The remediation machinery works; the AI is blind to the field it would need to patch.

The `workloads` state slice contains ONLY `{name, namespace, desired, ready}`. No container image. No spec of any kind.

So for a deployment failing on `nginx:v99-does-not-exist`, the propose-remediation agent:
- correctly inferred ImagePullBackOff (from k8s events in the findings),
- correctly reasoned that `restart_rollout` would "only recreate the same pods with the same unpullable image reference and would not fix it" — better reasoning than the ISE-53 task itself, which assumed restart/scale were the natural remediations,
- correctly identified `edit_resource` as the right operation,
- and then **proposed NOTHING**, because "the evidence I can gather does not tell me what the correct image tag/name should be... proposing a specific image string would be a guess, and a wrong guess would not fix the issue and could break the manifest further."

That is exactly the behaviour the prompt asks for, and it is the right call. But it means **Phase 4's exit criterion cannot be met**: the AI can see THAT something is broken and never WHAT TO CHANGE IT TO. `edit_resource` — the only operation in the catalogue that fixes this class of failure — is unproposable, because the field it patches is not in the state model.

No unit test could have found this. The connector, the catalogue, the state machine, the executor and the guard are all correct in isolation; the loop simply cannot close on real input.

Fix:
1. `workloads` slice: include each container's `image` (and name) for deployments, statefulsets and daemonsets.
2. Rollout history: derive the prior revision's images from the deployment's ReplicaSets (the read ClusterRole already grants `replicasets`), so the agent can see the last-known-good image and propose patching BACK to it — evidence, not a guess. That is how a human fixes this: look at what it was, put it back.
3. Keep the slice lean (ADR: don't sync what ISE doesn't use) — images and revision history, not whole manifests.

Generalises beyond images: any `edit_resource` proposal needs the agent to see the spec field it intends to change. State that is only good enough to DETECT is not good enough to REMEDIATE.