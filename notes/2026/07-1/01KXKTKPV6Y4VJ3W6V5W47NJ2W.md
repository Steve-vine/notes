---
id: 01KXKTKPV6Y4VJ3W6V5W47NJ2W
created: 2026-07-15T21:23:32.838450144Z
updated: 2026-07-24T12:32:38.663197Z
type: task
title: NetworkPolicies — default-deny egress with an explicit allow-list
project: 01KX671DATY39VW6GWK3M2T3DN
number: 78
sprint: sd1gs0p
assignee: steve
label: null
priority: medium
task_status: backlog
---
The Helm chart has **zero NetworkPolicy templates**. `security-model.md:47` calls it out aspirationally: "restrictable by NetworkPolicy *when the cluster supports it*".

## First, the open question

**Does the g5 CNI enforce NetworkPolicy?** It's undocumented — k3s v1.36 is the only clue (from the RBAC example files). k3s ships flannel, which does **not** enforce policy on its own; k3s bundles a separate controller that must be enabled. Confirm enforcement is actually on before writing policies that would otherwise be silently ignored (a NetworkPolicy that isn't enforced is worse than none — it reads as a control that isn't there).

## The egress set (derived from code, written down nowhere today)

- Model providers `api.anthropic.com` / `api.openai.com` (worker pods)
- DataDog API; EntraID `login.microsoftonline.com` (API pod)
- Kubernetes API (k8s connector)
- In-cluster: Postgres `ise-postgres-rw:5432`, Valkey `ise-valkey:6379`, DNS
- Ingress: Traefik → frontend → API Service

Default-deny + explicit allow for exactly that set. Templated + documented per connector. Staging-first.