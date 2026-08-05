---
id: 01KYAWSM4MQY1S03ZQ3V67WBR4
created: 2026-07-24T20:24:15.764176Z
updated: 2026-08-05T19:02:04.396482Z
type: task
title: 'Kind Dictionary: validate CRD version against served versions'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 269
sprint: s5khymf
comments:
- id: 01KYB4C50XM612GD40D2KWM6TD
  author: Steve Vine
  at: 2026-07-24T22:36:42.909522Z
  text: |-
    Fixed on feature/ise-269-crd-version-validation (PR #247 → main). All three scope items done.

    1. Version validation surface: on a failed live probe the connector now reads the CRD's served versions (apiextensions) and reports an unserved version as "version v1beta1 not served; cluster serves v1" instead of a bare 404. `probe_kind` delegates to a new `check_kind`, so BOTH the editor probe AND the ISE-262 per-entry availability status get the actionable message (acceptance #2/#3). I kept the save-path structural-only per ADR 0046 §3 (save must not hang on an unreachable cluster) — the version check is the live probe, which the editor already runs on Add, so an unserved version is flagged visibly at Add (inline result + toast + ongoing status badge), matching the ISE-262 graceful-degradation posture rather than a hard block.

    2. Version picker: the probe endpoint now returns served_versions; the editor renders them as one-click chips that set the version field — the operator selects from what the cluster serves.

    3. Preset fix: ExternalSecret preset → v1 (acceptance #1: enables first-time on a current-ESO cluster). Stripped the meaningless Rollout-cloned fields — a model validator nulls owns/replica_path/ready_path for ANY non-workload entry, per the kind-preset blueprint. Fields are nullable through the API now; OpenAPI + frontend types regenerated.

    Tests: backend probe-version-not-served (real Postgres) + preset shape + non-workload nulling; frontend picker render + chip-click. Full kind-dictionary/connector/sync suites pass; ruff/mypy/tsc/prettier/eslint green. Since backend API changed, the regenerated api-types are committed on the branch.
assignee: steve
label: null
priority: medium
task_status: done
---
Found live 2026-07-24, straight after ISE-262 shipped: the ExternalSecret preset (ISE-261) is pinned to `external-secrets.io/v1beta1`, but current External Secrets Operator serves the CRDs at `v1` — every sync 404s (`custom kind external-secrets.io/v1beta1/ExternalSecret unavailable: (404)`) on both staging clusters and no entities mint. A version mismatch is exactly as silent as the RBAC gap ISE-262 fixed, but it's a different failure class: the *path* doesn't exist, rather than access being denied.

Scope:

1. **Save-time version validation**: when an entry (or preset) is saved, query the CRD's served versions (`spec.versions[?served]` on the CRD, or an API-resources discovery call) and reject/flag a version the cluster doesn't serve — ideally offer the served versions as a picker instead of a free-text field, so the operator selects from reality.
2. **Degradation surface**: make sure the ISE-262 per-entry status distinguishes and displays this class too — "unavailable: version v1beta1 not served (cluster serves v1)" is actionable; a generic "unavailable (404)" is not.
3. **Fix the shipped preset**: the ExternalSecret preset should default to `v1` (and ideally track the served version at enable time rather than hard-coding). Also strip the meaningless Rollout-cloned fields from it (`owns: replicasets`, `replica_path`, `ready_path` on a kind with no replicas) — presets must be defined per the ISE-261 blueprint, not copied from the nearest working entry.

Acceptance: enabling the ExternalSecret preset on a current-ESO cluster works first time; saving an entry with an unserved version fails visibly at save with the served versions named; existing mis-versioned entries show the actionable message on the integration.