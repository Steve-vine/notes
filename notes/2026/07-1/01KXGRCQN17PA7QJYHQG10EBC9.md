---
id: 01KXGRCQN17PA7QJYHQG10EBC9
created: 2026-07-14T16:47:03.841104238Z
updated: 2026-07-14T16:47:09.991938814Z
type: task
title: Deployment & observability skeleton (Helm)
label:
- chore
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 10
sprint: s7hkfxa
---
Make the app deployable end to end with observability from the first deploy, per ADR 0008/0006.

- [ ] Two images: backend, frontend-nginx (immutable tags)
- [ ] One Helm chart, per-environment `values.yaml`; cloud-specific annotations defaulted empty
- [ ] Deployments: `api`, `worker`, `beat` (one backend image, three commands)
- [ ] Redis/Valkey instance (broker + session store)
- [ ] Alembic pre-upgrade hook Job; ExternalSecrets in prod
- [ ] Prometheus metrics on API + workers; healthz/readyz wired to probes

Depends on: Backend API scaffolding, Database foundation. Refs: ADR 0006, 0008.

---
*Migrated from Linear [DEV-396](https://linear.app/stevevine/issue/DEV-396/deployment-and-observability-skeleton-helm) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-395, DEV-416, DEV-389*