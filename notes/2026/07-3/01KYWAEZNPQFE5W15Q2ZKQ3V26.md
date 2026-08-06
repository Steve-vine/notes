---
id: 01KYWAEZNPQFE5W15Q2ZKQ3V26
created: 2026-07-31T14:50:12.534247Z
updated: 2026-08-06T07:30:15.693396Z
type: task
title: 'Docs: Getting started — installation'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 424
order: 0.0625
sprint: sp3en5k
comments:
- id: 01KYWB0SFYB7E2GY1FAZBEY4E5
  author: Steve Vine
  at: 2026-07-31T14:59:56.03069Z
  text: |-
    Done on feature/ise-424-docs-installation — PR #19, left OPEN for review.

    Real install guide: prerequisites (cluster incl. the monitors-itself/break-glass note, Postgres, Redis/Valkey with the chart's optional instance, Entra app registration, optional AI provider key with the "no key → provider unselectable, scheduled AI no-op" behaviour); a values block using the ACTUAL keys from helm/values.yaml (secrets.values.databaseUrl/redisUrl/sessionRedisUrl/publicBaseUrl/entra*/anthropicApiKey, ingress, tls); a callout pair for the credential key-encryption key (base64 32-byte, back it up WITH the database) and the break-glass password hash; helm upgrade --install with the pre-upgrade migration hook; what's deployed (API, workers on sync/ai/actions queues, Beat, frontend, optional Valkey); values-files-only environment differences; hosted is always Entra (dev stub not chart-exposable); first-sign-in checklist ending at the first integration. Facts from helm/values.yaml, templates/secrets.yaml, settings.py + ADRs 0012/0005/0015/0008. Build/lint green.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the stub at `src/content/docs/getting-started/installation.md` with a real install guide: prerequisites (Kubernetes cluster, PostgreSQL, Entra ID app registration for OIDC sign-in, an AI provider key), Helm install with the values that matter, what the deployment contains (web app, workers, database), first sign-in and the break-glass account, and connecting a first integration.

Ground in ADRs 0012 (Kubernetes/Helm deployment), 0005 (migrations as a Helm hook), 0015 (Entra OIDC + break-glass), 0008 (immutable image tags). Operator audience, released capability only.