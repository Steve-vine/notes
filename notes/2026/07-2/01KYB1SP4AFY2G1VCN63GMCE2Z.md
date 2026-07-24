---
id: 01KYB1SP4AFY2G1VCN63GMCE2Z
created: 2026-07-24T21:51:40.682897Z
updated: 2026-07-24T21:51:40.682897Z
type: task
title: routes-to derivation misses Argo-managed Services (injected pod-template-hash selector)
assignee: steve
label: bug
priority: medium
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 271
---
Found live 2026-07-24 via https://ise.citops.net/estate/7dd9818a-c922-4fb5-987b-3358bb961296: `chinwag-react-ui` (Rollout-managed workload) shows "No known dependents" in the impact panel while its `-live`/`-preview` Services route to nothing — only 11 of 54 Rollout workloads have any incoming routes-to edge.

**Cause:** under an Argo Rollout blue-green/canary strategy, Argo dynamically injects `rollouts-pod-template-hash: <hash>` into the active/preview Services' selectors at runtime. ISE derives routes-to by subset-matching the Service selector against workload pod-template labels (`_selected(selector, selectable)` in `connectors/kubernetes.py`) — the template labels can never contain the runtime hash, so the match fails and the edge is never minted. Rollouts whose Services aren't hash-managed match fine, which is why the gap is partial and easy to miss.

**Impact:** blast radius / the impact panel systematically under-reports for exactly the hash-managed (i.e. production-pattern, user-facing) Rollout workloads — "no known dependents" on a web UI that a Service demonstrably fronts. Also thins investigation context for those incidents.

**Fix:** strip runtime-managed revision-selector keys before the subset match — `rollouts-pod-template-hash` (Argo) and `pod-template-hash` (ReplicaSet cousin, same class). The remaining selector still identifies the workload; the hash selects the *revision*, which is below ISE's level of interest. While in there, verify the Rollout preset feeds Rollout pod-template labels into the `selectable` map the same way built-in kinds do.

Acceptance: on env-staging-uk/us, `chinwag-react-ui-live` (and the other hash-managed Services) gain routes-to edges to their Rollout workloads on next sync; the react-ui entity's impact panel shows its Service as a dependent; routes-to coverage across the 54 Rollouts rises to match the Services that actually front them.