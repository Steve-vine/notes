---
id: 01KYVS36P8G3EZ2A2MKBJ6NS9K
created: 2026-07-31T09:46:40.712541Z
updated: 2026-08-05T14:49:31.336345Z
type: task
title: M365 signals — Service Health alerts + license observations
project: 01KX671DATY39VW6GWK3M2T3DN
number: 401
order: 1.25
sprint: s10ybrs
blocked_by:
- 01KYVS2Y79HX5NJWFVRGJA6S1D
comments:
- id: 01KYW40KXVAMZAZXD1F096G3G9
  author: Steve Vine
  at: 2026-07-31T12:57:30.299566Z
  text: |-
    Built and in review — PR #373 (feature/ise-401-m365-signals, stacked on #372).

    - Alerts: detect() polls serviceAnnouncement/issues ($filter isResolved eq false + client-side skip); kind service-health, source_key servicehealth/{issue_id}; severity incident+serviceInterruption→high, serviceDegradation→medium, advisory→low, unmapped→medium; entity attribution via a healthOverviews name→id map (map failure costs attribution, never the alert). Recovery derives from absence through reconcile_findings — presence contract, no state machine.
    - Licence observations: subscribedSkus sweep — pool ≥ threshold (default 90%, per-System config override license_threshold_percent) → license-pool Obs (high once over-allocated); capabilityStatus warning/suspended/lockedOut → license-status Obs. 0-enabled-units guard, obs/-namespaced keys, no entity_key (System-card data).
    - Tests: test_m365_signals.py, 17 passing incl. real-Postgres presence-contract transitions and ADR 0030 loop separation (alert silence never recovers observations); ruff + mypy clean.
assignee: steve
priority: medium
task_status: done
---
**Alerts (stateful presence contract — riskyUsers pattern, NOT the Cloudflare 24h window):** poll GET /v1.0/admin/serviceAnnouncement/issues; an issue with `isResolved=false` is an active Alert signal on its service entity, resolved when Microsoft flips `isResolved`. kind `service-health`; source_key from issue id, `_bounded_key`. Severity: classification+status → canonical ladder (`incident` + serviceInterruption → high, serviceDegradation → medium, `advisory` → low). Dedupe/reinforcement free via same-entity attribution — no new cross-source architecture. Message Center is deliberately NOT a signal source (pull-only evidence, ISE-402).

**License observations (deterministic Obs-loop detectors, no AI):** sweep GET /v1.0/subscribedSkus — consumedUnits/enabled ≥ threshold (default 90%) → license-pool-near-exhaustion Observation; SKU capabilityStatus warning/suspended/lockedOut → Observation. Thresholds respect existing settings override patterns where applicable.

Tests: contract transitions (new issue → active, isResolved → resolved), severity mapping table, detector threshold edges (0 enabled units guard), stubbed transport.