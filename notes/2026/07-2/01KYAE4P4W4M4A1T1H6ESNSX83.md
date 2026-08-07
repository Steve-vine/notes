---
id: 01KYAE4P4W4M4A1T1H6ESNSX83
created: 2026-07-24T16:08:09.628518Z
updated: 2026-08-07T10:57:13.382723Z
type: task
title: Kind Dictionary editor on the Kubernetes integration screen
project: 01KX671DATY39VW6GWK3M2T3DN
number: 258
sprint: s5khymf
comments:
- id: 01KYAGJ94EKA92PQGRHW7PQVVV
  author: Steve Vine
  at: 2026-07-24T16:50:32.206594Z
  text: |-
    Moved to Review. PR #239 → main (https://github.com/Steve-vine/ise/pull/239), stacked on ISE-256 (#237) + ISE-257 (#238).

    Vertical slice — backend + UI:
    - API: GET/PUT `/systems/{id}/kind-dictionary` (viewer read, admin write, per-entry validation → 422 with problems on a bad/colliding entry, Kubernetes-only, audited) + POST `/kind-dictionary/probe` (reveals read credential, lists the CRD via new connector `probe_kind`; 404/403 surfaces typo'd GVK / missing RBAC). Schemas added; OpenAPI + api types regenerated.
    - UI: KindDictionaryCard on SystemDetailPage (kubernetes only) — built-ins shown locked, custom entries add/remove, add form (GVK/plural, entity-type, owner-chain, DataDog tag), "Test against cluster" probe with inline result, inline save-validation problems, "applies on next sync (every N)" note.

    Acceptance met: an operator can add Rollout.argoproj.io/v1alpha1 → workload from the UI, see validation pass, and know when discovery applies it.

    Tests: 8 API integration + 2 card tests. All gates green (FE build/eslint/prettier/vitest, BE ruff/format/mypy/pytest).
assignee: steve
label: null
priority: medium
task_status: done
---
The screen for ISE-256/257: each Kubernetes integration instance gets a **Kind Dictionary** panel on its detail/settings surface (per-instance, not global Settings — mirrors how the tag dictionary made classification legible, ADR 0041).

- Lists the built-in entries (Deployment/StatefulSet/DaemonSet → workload) locked, with the mapping visible: `{kind} — is a — {entity type}`.
- Add/edit/remove custom entries: GVK + plural, canonical entity type (dropdown of ENTITY_TYPES), optional replica JSONPaths, optional DataDog scope tag, owner-chain mode. Sensible defaults pre-filled.
- Validation on save: probe the cluster for the CRD (exists? listable with current RBAC?) and surface the result inline — a typo'd GVK or missing RBAC must be visible at authoring time, not a silent empty discovery.
- Changes audited; next sync picks them up (show "takes effect on next sync" with the sync cadence).

Acceptance: an operator can add `Rollout.argoproj.io/v1alpha1 → workload` on the env-staging-us integration from the UI, see validation pass, and know when discovery will apply it.

Depends on ISE-256 (schema) and ISE-257 (connector honours it).