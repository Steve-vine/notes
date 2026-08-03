---
id: 01KZ45905MAKJV97J0HBWXRFC3
created: 2026-08-03T15:53:29.012835Z
updated: 2026-08-03T16:24:09.317622Z
type: task
title: 'Estate: sync Kubernetes Secrets as a first-class ''secret'' entity type'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 517
sprint: skxht3g
assignee: steve
priority: medium
task_status: backlog
---
From Sprint 46 Estate testing. Native Kubernetes Secrets should appear in the Estate as their own entity type (`secret`), not under Other. ExternalSecrets stay as they are — that's a customer CRD, correctly mapped to `other` — but the Secret is a standard Kubernetes kind and deserves promotion.

Scope:
- Add `secret` to ENTITY_TYPES (DB check-constraint migration + OpenAPI/api-types regen — ENTITY_TYPES changes redden the snapshot on their own branch).
- Kubernetes connector discovers Secrets: metadata only (name, namespace, type, e.g. Opaque/tls/dockerconfigjson) — never the data values.
- Wire existing relationships: ExternalSecret produces-a Secret, workloads depend-on Secrets they mount/reference (the consumer/producer plumbing already exists in the connector for the depends-on edges — the Secret just isn't an entity yet).
- UI: type filter/icon for the new type.