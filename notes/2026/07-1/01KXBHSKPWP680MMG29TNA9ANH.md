---
id: 01KXBHSKPWP680MMG29TNA9ANH
created: 2026-07-12T16:15:33.596899984Z
updated: 2026-07-23T18:32:53.575349Z
type: task
title: Risk policy + tier resolution + ADR 0021
project: 01KX671DATY39VW6GWK3M2T3DN
number: 47
sprint: sdcd2jr
blocked_by:
- 01KXBHSA4S1XGSAHQNTPGEHSD8
assignee: steve
label: null
priority: high
task_status: done
---
The engine that finally reads System.risk_policy (models.py:109 — the column exists, defaults {}, and NOTHING reads it today).

- resolve_tier(system, spec): policy may RAISE a declared tier, never lower (ADR 0017). Explicit test that an attempt to LOWER is ignored.
- requires_approval(tier, policy): DEFAULT-DENY (Steve's decision) — every system ships with auto_apply {T0: false, T1: false}, so every mutation goes through the approvals queue. Auto-apply is a deliberate per-system, per-tier opt-in. ADR 0017 explicitly permits policy to raise a tier, so this is compliant, not a violation.
- protected_targets: a per-system deny-list evaluated INSIDE act(), refusing any operation whose target matches — regardless of tier, and regardless of approval. THE BLAST-RADIUS GUARD: approval gates intent, but nothing else gates blast radius, and ISE now holds delete rights on the shared g5 cluster (which runs ISE itself + Compass). An approver cannot click past it. Seed: kube-system, ise, arc-runners, CNPG namespaces.

risk_policy = {
  "auto_apply": {"T0": false, "T1": false},
  "tier_overrides": {"restart_rollout": "T2"},   # raise only
  "protected_targets": ["kube-system", "ise", "arc-runners"]
}

ADR 0021 records: the default-deny auto-apply posture, the policy schema, and the protected-targets guard. Required — CLAUDE.md: no new architecture decision without an ADR.