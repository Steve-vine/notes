---
id: 01KZ45905MAKJV97J0HBWXRFC3
created: 2026-08-03T15:53:29.012835Z
updated: 2026-08-05T12:31:29.161573Z
type: task
title: 'Estate: sync Kubernetes Secrets as a first-class ''secret'' entity type'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 517
order: 2.0
sprint: skxht3g
comments:
- id: 01KZ48VYFM1CTCVXKXBYE6C5VR
  author: Steve Vine
  at: 2026-08-03T16:56:15.604017Z
  text: |-
    Done in PR #442 (feature/ise-517-secret-entity-type). All four scope points covered, plus two decisions worth your view.

    **Scope as specified:** migration 0091 widens the entity-type constraint (no data path — nothing was discovering Secrets before); the connector discovers Secrets as metadata only (name, namespace, type, labels) and never reads the data block; relationships wired; `secret` added to the Estate type filter and given a key icon on the graph (not a padlock — `policy` already holds the shield-and-lock, and two lock glyphs at 18px would repeat the ISE-515 mistake).

    There's a test that puts a real value in the fake API's `data` and asserts it appears nowhere in any discovered entity, so "never the values" is enforced rather than merely intended.

    **Decision 1 — I excluded Kubernetes' own bookkeeping Secrets.** Helm writes one Secret per release *revision* (`helm.sh/release.v1`), so a busy namespace churns dozens on every deploy, and pre-1.24 clusters mint one per ServiceAccount. Syncing those would bury the handful you actually configured under machinery nobody authored, and they'd churn through the retirement machinery constantly. Excluded by the `type` field — a fact Kubernetes states, not a name pattern ISE guesses at. Say the word if you'd rather see everything.

    **Decision 2 — the dependency chain now goes through the Secret.** Previously a workload pointed `depends-on` straight at the ExternalSecret. Now it's workload → Secret → ExternalSecret, which is truer and still reaches the producer one hop further out. Consequence: the old direct edges stop being re-confirmed and will show as drift rather than being torn down (discovery never deletes edges). Where the credential can't list Secrets, the old direct edge still stands in, so a restricted cluster loses nothing.

    **Two changes beyond the ticket, for transparency:** secret-ref extraction was gated on an ExternalSecret-like kind being in the dictionary (finding the producer was its only use). That gate is gone — references matter on every cluster now, including ones with no operator. Since it consequently runs for every workload on every sync, I made it degrade to "no edges" rather than fail the sync if a pod template can't be serialised; the existing RBAC test caught that exact hazard. The now-uncalled helper `any_produces_secrets` was removed with its test rather than left as a function only its own test used.

    Tests: 5 new connector tests + 1 migration test. Full frontend suite (548), backend discovery/entities/sync/connector suites green, ruff/format/mypy strict clean, API types regenerated.
- id: 01KZ4B9DXM3MKMXD58ZN63380M
  author: Steve Vine
  at: 2026-08-03T17:38:34.54788Z
  text: |-
    RELEASED to main 2026-08-03 (PR #442 merged, main bc456fb, migration 0091). Smoke tested OK on staging; staging reset to main.

    Migration 0091 is already applied on the staging instance. Secrets appear in the Estate once each Kubernetes integration completes its next sync — nothing to run by hand.

    Both judgement calls stand as shipped, and both are cheap to reverse if the live estate changes your mind: Helm-release and ServiceAccount-token Secrets are excluded by type, and the dependency chain runs workload → Secret → ExternalSecret. The old direct workload → ExternalSecret edges will show as drift rather than disappearing, since discovery never deletes edges.
assignee: steve
priority: medium
task_status: done
---
From Sprint 46 Estate testing. Native Kubernetes Secrets should appear in the Estate as their own entity type (`secret`), not under Other. ExternalSecrets stay as they are — that's a customer CRD, correctly mapped to `other` — but the Secret is a standard Kubernetes kind and deserves promotion.

Scope:
- Add `secret` to ENTITY_TYPES (DB check-constraint migration + OpenAPI/api-types regen — ENTITY_TYPES changes redden the snapshot on their own branch).
- Kubernetes connector discovers Secrets: metadata only (name, namespace, type, e.g. Opaque/tls/dockerconfigjson) — never the data values.
- Wire existing relationships: ExternalSecret produces-a Secret, workloads depend-on Secrets they mount/reference (the consumer/producer plumbing already exists in the connector for the depends-on edges — the Secret just isn't an entity yet).
- UI: type filter/icon for the new type.