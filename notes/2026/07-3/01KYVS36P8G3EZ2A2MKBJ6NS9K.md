---
id: 01KYVS36P8G3EZ2A2MKBJ6NS9K
created: 2026-07-31T09:46:40.712541Z
updated: 2026-07-31T09:46:40.712541Z
type: task
title: M365 signals — Service Health alerts + license observations
priority: medium
task_status: backlog
assignee: steve
label: feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 401
---
**Alerts (stateful presence contract — riskyUsers pattern, NOT the Cloudflare 24h window):** poll GET /v1.0/admin/serviceAnnouncement/issues; an issue with `isResolved=false` is an active Alert signal on its service entity, resolved when Microsoft flips `isResolved`. kind `service-health`; source_key from issue id, `_bounded_key`. Severity: classification+status → canonical ladder (`incident` + serviceInterruption → high, serviceDegradation → medium, `advisory` → low). Dedupe/reinforcement free via same-entity attribution — no new cross-source architecture. Message Center is deliberately NOT a signal source (pull-only evidence, ISE-402).

**License observations (deterministic Obs-loop detectors, no AI):** sweep GET /v1.0/subscribedSkus — consumedUnits/enabled ≥ threshold (default 90%) → license-pool-near-exhaustion Observation; SKU capabilityStatus warning/suspended/lockedOut → Observation. Thresholds respect existing settings override patterns where applicable.

Tests: contract transitions (new issue → active, isResolved → resolved), severity mapping table, detector threshold edges (0 enabled units guard), stubbed transport.