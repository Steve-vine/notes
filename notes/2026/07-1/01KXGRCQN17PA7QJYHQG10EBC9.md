---
id: 01KXGRCQN17PA7QJYHQG10EBC9
created: 2026-07-14T16:47:03.841104238Z
updated: 2026-07-14T16:47:19.854808167Z
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
comments:
- id: 01KXGRD79EDRC10C8S5CDYKXSE
  author: Steve Vine
  at: 2026-07-14T16:47:19.854713945Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 08:39 UTC]
    Implemented in **PR #1** — https://github.com/Steve-vine/compass/pull/1 (branch `steve/dev-396-deployment-observability-skeleton-helm`).

    **Scope:** Helm chart + the two Dockerfiles, validated with `helm lint`/`helm template`. No app-code changes — the chart references process commands and HTTP endpoints as a *contract* the backend-scaffolding brief fulfils. A live deploy still depends on the backend-API + DB-foundation briefs.

    **Checklist status:**
    - ✅ Two images: backend, frontend-nginx (`app/backend/Dockerfile`, `app/frontend/Dockerfile`; `:local` for k3s, immutable `<branch>-yyyymmdd-hhmm` convention for prod — never `latest`).
    - ✅ One Helm chart, per-env values (`values.yaml` + `values-k3s.yaml` + `values-prod.yaml`); cloud-specific annotations defaulted empty.
    - ✅ Deployments `api` / `worker` / `beat` — one backend image, three commands.
    - ✅ Valkey broker + result backend (single in-cluster instance, ADR 0006).
    - ✅ Alembic pre-install/pre-upgrade hook Job (pg_isready wait loop); ExternalSecrets path for prod (`secrets.external: true`).
    - ✅ Prometheus scrape annotations on api + worker; `/healthz` + `/readyz` wired to liveness/readiness probes.

    **Decisions made on the fly:**
    - **ADR 0005:** the CNPG `Cluster` CR is NOT a chart template (infra prerequisite). It ships at `scripts/infra/postgres-cluster.yaml` + README, applied before `helm install`. Validated against the live operator with `kubectl apply --dry-run=server`.
    - **Ingress/TLS:** plain k8s `Ingress` (class `traefik`, host `compass.citops.net`) + cert-manager `Certificate` reusing the existing `letsencrypt-prod` ClusterIssuer (not recreated) — mirrors the live `dev.redvektor.net` pattern.
    - No Prometheus Operator in the target cluster → metrics via pod scrape annotations rather than a ServiceMonitor.

    **Assumptions / follow-ups:**
    - Secret env-var names (`DATABASE_URL`, `BROKER_URL`, `RESULT_BACKEND_URL`, `SESSION_SECRET_KEY`, `AUTH_COOKIE_*`, `READYZ_*`) are a contract for the not-yet-existing backend `Settings` — reconcile when backend scaffolding lands.
    - `compass.citops.net` TLS needs a DNS A record → `172.20.11.163` and `citops.net` solvable by the issuer's Cloudflare token.
    - Follow-up: switch `DATABASE_URL` to the CNPG-generated app-user Secret instead of the dev-only password duplicated between `values-k3s.yaml` and the infra manifest.
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