---
id: 01KXX7KV6GYVC8TA604X1RKHA4
created: 2026-07-19T13:03:58.672213207Z
updated: 2026-07-24T12:32:43.167966Z
type: task
title: Context-driven suppression of observations
project: 01KX671DATY39VW6GWK3M2T3DN
number: 141
sprint: srmqjcq
blocked_by:
- 01KXX7KJT32P27V03GCRCE2RQ0
comments:
- id: 01KXXXZ0VQ3AZCWPJMVYF8AV7G
  author: Steve Vine
  at: 2026-07-19T19:34:33.591023726Z
  text: |-
    Done. Context-driven suppression of observations. PR #128 → main (all CI green — the setup.ts asyncUtilTimeout bump fixed the pre-existing frontend flakiness). Merged to staging (957047d). Review.

    ObservationSuppression model (entity_id+kind scoped, reason, optional annotation citation; migration 0032); promotion skips auto-open for suppressed observations (recorded but quiet); FindingRead carries derived suppressed/suppression_reason; POST/DELETE /findings/{id}/suppress + GET /entities/{id}/suppressions; Observations queue suppress/un-suppress with required reason + "Suppressed: <reason>" badge on queue and entity signals. Backend 627 passed.
assignee: steve
label: null
priority: medium
task_status: done
---
**Sprint 14 (vertical slice: backend + UI).** Keep the Obs Loop quiet where a human already knows better — the antidote to observation noise.

- **Backend**: suppression driven by the Sprint-12 registers — **entity context annotations** (ISE-130) + **severity overrides / Ignores** (ADR 0026). An entity annotated "runs Karpenter, expect transient nodes" suppresses the matching node-churn observation before it opens an Incident.
- **UI**: suppression is **visible and controllable** — a suppressed observation shows *why* ("suppressed: expected per annotation") on the Observations screen / entity, and an operator can add a suppression from where the noise appears.

**DoD**: an annotated entity suppresses its matching observation, the suppression + reason are visible in the UI, and an operator can suppress from the queue. Not done until suppression is legible in the UI.

Depends on the Kubernetes detectors.