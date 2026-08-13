---
id: 01KZY7XPNWKZNP2BT7WK783G0E
created: 2026-08-13T18:59:59.804096Z
updated: 2026-08-13T18:59:59.804096Z
type: task
title: create-ise-clusterrole.sh needs a role-only mode — a provisioning script is the wrong unit for an RBAC change
priority: low
task_status: backlog
assignee: steve
label: tech_debt
tech: kubernetes
project: 01KX671DATY39VW6GWK3M2T3DN
number: 695
---
`~/code/scripts/create-ise-clusterrole.sh` (separate repo, outside the ISE pipeline) provisions a cluster from nothing: namespace, ServiceAccount, both ClusterRoles, both bindings, a long-lived token Secret, and an emitted kubeconfig. That is right for onboarding a cluster and wrong for changing one object on clusters already onboarded.

**What went wrong in ISE-684.** The change was a rewrite of the `ise-readonly` ClusterRole. The only tool for applying it was "re-run the script per cluster", and that instruction carried two hazards that have nothing to do with the change:

- **`-type ro` DELETES `ise-readwrite` and its binding.** Of the seven integrated clusters, g5 and mgnt-staging-uk hold write grants. Running the wrong `-type` on either silently revokes a working write credential, and nothing in ISE would report it until an action failed.
- **Each run writes a kubeconfig carrying a never-expiring token into `/tmp`** — seven files, for a change that touches one cluster-scoped RBAC object.

Six of the script's seven steps are no-ops against an already-provisioned cluster. The actual change was one `kubectl apply`.

**Scope**
- A flag (`-only role`, or a separate `apply-ise-roles.sh`) that applies the ClusterRoles and nothing else: no namespace, no ServiceAccount, no token Secret, no binding churn, no emitted kubeconfig.
- It must still respect `-type`: `ro` applies the read role alone, `rw` applies both. It must NOT perform the ro-run downgrade delete — a role-only apply is not a re-provision, and conflating the two is what created the hazard above.
- Header comment stating when to use which mode: full run to onboard a cluster, role-only for a policy change to a cluster already onboarded.

**Not urgent.** ISE-684 is applied on all 7 clusters, so nothing is currently broken. This is about the next RBAC change — ADR 0100 does not promise to be the last one, and the reasoning above should not have to be re-derived under time pressure.