---
id: 01KXE5CKKRZ2NWZPPMKX768ZBA
created: 2026-07-13T16:36:27.896699427Z
updated: 2026-07-13T16:36:27.896699427Z
type: task
title: Separate write credential — sync must not hold a mutating credential
priority: medium
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 55
---
Found while wiring the g5 write credential for ISE-53.

`System` has ONE `credential_ref`. Both `sync.py` and `tasks/actions/execute.py` resolve it, so **sync and act run as the same principal**. The kubernetes.py docstring claimed the opposite ("sync runs with a read-only kubeconfig, act with a write-scoped one") — that was the intended design, never implemented. The docstring is corrected; the design gap remains.

Consequence today: the single Kubernetes identity ISE stores must be able to do both, so it has cluster-wide READ plus write bound to `ise-acceptance`. The blast radius is bounded by RBAC (that binding), not by ISE. Acceptable, and verified — but it means a bug in the sync path is holding a credential that *could* mutate, which is exactly what the two-principal design existed to prevent.

Fix:
- Add `System.write_credential_ref` (nullable) + migration.
- `sync.py` keeps using `credential_ref` (read-only).
- `execute.py` uses `write_credential_ref`, and REFUSES to execute if it is unset — a system with no write credential cannot be mutated, which is a better default than silently falling back to the read credential.
- Revert the `ise-connector-rw-read` ClusterRoleBinding once done: the write principal goes back to write-only, namespace-scoped, and cannot read the cluster at all.
- Settings UI: a second credential slot, clearly labelled as the one that can change things.

Worth doing before any system is opted into an auto-apply band, because at that point ISE mutates without a human in the loop and the identity separation is the only structural thing left.