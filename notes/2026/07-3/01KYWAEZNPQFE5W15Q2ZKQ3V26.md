---
id: 01KYWAEZNPQFE5W15Q2ZKQ3V26
created: 2026-07-31T14:50:12.534247Z
updated: 2026-07-31T14:51:36.100022Z
type: task
title: 'Docs: Getting started — installation'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 424
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Replace the stub at `src/content/docs/getting-started/installation.md` with a real install guide: prerequisites (Kubernetes cluster, PostgreSQL, Entra ID app registration for OIDC sign-in, an AI provider key), Helm install with the values that matter, what the deployment contains (web app, workers, database), first sign-in and the break-glass account, and connecting a first integration.

Ground in ADRs 0012 (Kubernetes/Helm deployment), 0005 (migrations as a Helm hook), 0015 (Entra OIDC + break-glass), 0008 (immutable image tags). Operator audience, released capability only.