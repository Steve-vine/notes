---
id: 01KYAE4P4W4M4A1T1H6ESNSX83
created: 2026-07-24T16:08:09.628518Z
updated: 2026-07-24T16:08:25.420491Z
type: task
title: Kind Dictionary editor on the Kubernetes integration screen
project: 01KX671DATY39VW6GWK3M2T3DN
number: 258
sprint: s5khymf
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
The screen for ISE-256/257: each Kubernetes integration instance gets a **Kind Dictionary** panel on its detail/settings surface (per-instance, not global Settings — mirrors how the tag dictionary made classification legible, ADR 0041).

- Lists the built-in entries (Deployment/StatefulSet/DaemonSet → workload) locked, with the mapping visible: `{kind} — is a — {entity type}`.
- Add/edit/remove custom entries: GVK + plural, canonical entity type (dropdown of ENTITY_TYPES), optional replica JSONPaths, optional DataDog scope tag, owner-chain mode. Sensible defaults pre-filled.
- Validation on save: probe the cluster for the CRD (exists? listable with current RBAC?) and surface the result inline — a typo'd GVK or missing RBAC must be visible at authoring time, not a silent empty discovery.
- Changes audited; next sync picks them up (show "takes effect on next sync" with the sync cadence).

Acceptance: an operator can add `Rollout.argoproj.io/v1alpha1 → workload` on the env-staging-us integration from the UI, see validation pass, and know when discovery will apply it.

Depends on ISE-256 (schema) and ISE-257 (connector honours it).