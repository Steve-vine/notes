---
id: 01KYB1SP4AFY2G1VCN63GMCE2Z
created: 2026-07-24T21:51:40.682897Z
updated: 2026-08-07T10:56:09.498994Z
type: task
title: routes-to derivation misses Argo-managed Services (injected pod-template-hash selector)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 271
sprint: s5khymf
comments:
- id: 01KYB33JMAZBDHPSF0NF2V9DYB
  author: Steve Vine
  at: 2026-07-24T22:14:33.354364Z
  text: |-
    Fixed on feature/ise-271-argo-routes-to (PR #245 → main).

    Root cause confirmed as described: `_selected()` in connectors/kubernetes.py subset-matches the Service selector against workload pod-template labels, and the runtime-injected `rollouts-pod-template-hash` in the active/preview Service selector never appears on template labels, so the match failed.

    Fix: strip revision-hash selector keys (`rollouts-pod-template-hash` + ReplicaSet cousin `pod-template-hash`, held in `_REVISION_SELECTOR_KEYS`) before the subset match; a selector left empty after stripping selects nothing rather than everything. Verified the Rollout preset already feeds pod-template labels into `selectable` via `_custom_workloads` (line 1019) exactly as built-in kinds — no change needed there.

    Tests added: hash-managed Service still gains its routes-to edge; an all-hash selector matches nothing. Full backend suite gates (pytest/ruff/mypy) green locally. On next staging sync the hash-managed Rollout Services (chinwag-react-ui-live etc.) should gain their edges.
assignee: steve
priority: medium
task_status: done
---
Found live 2026-07-24 via https://ise.citops.net/estate/7dd9818a-c922-4fb5-987b-3358bb961296: `chinwag-react-ui` (Rollout-managed workload) shows "No known dependents" in the impact panel while its `-live`/`-preview` Services route to nothing — only 11 of 54 Rollout workloads have any incoming routes-to edge.

**Cause:** under an Argo Rollout blue-green/canary strategy, Argo dynamically injects `rollouts-pod-template-hash: <hash>` into the active/preview Services' selectors at runtime. ISE derives routes-to by subset-matching the Service selector against workload pod-template labels (`_selected(selector, selectable)` in `connectors/kubernetes.py`) — the template labels can never contain the runtime hash, so the match fails and the edge is never minted. Rollouts whose Services aren't hash-managed match fine, which is why the gap is partial and easy to miss.

**Impact:** blast radius / the impact panel systematically under-reports for exactly the hash-managed (i.e. production-pattern, user-facing) Rollout workloads — "no known dependents" on a web UI that a Service demonstrably fronts. Also thins investigation context for those incidents.

**Fix:** strip runtime-managed revision-selector keys before the subset match — `rollouts-pod-template-hash` (Argo) and `pod-template-hash` (ReplicaSet cousin, same class). The remaining selector still identifies the workload; the hash selects the *revision*, which is below ISE's level of interest. While in there, verify the Rollout preset feeds Rollout pod-template labels into the `selectable` map the same way built-in kinds do.

Acceptance: on env-staging-uk/us, `chinwag-react-ui-live` (and the other hash-managed Services) gain routes-to edges to their Rollout workloads on next sync; the react-ui entity's impact panel shows its Service as a dependent; routes-to coverage across the 54 Rollouts rises to match the Services that actually front them.