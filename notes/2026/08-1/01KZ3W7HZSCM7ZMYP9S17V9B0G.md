---
id: 01KZ3W7HZSCM7ZMYP9S17V9B0G
created: 2026-08-03T13:15:24.53733Z
updated: 2026-08-03T13:15:24.53733Z
type: task
title: 'Estate: surface kind-dictionary gaps — cluster serves a CRD that ISE isn''t watching'
assignee: steve
priority: medium
task_status: backlog
label: improvement
project: 01KX671DATY39VW6GWK3M2T3DN
number: 513
---
Improvement from Sprint 46 Estate testing. The prod-Rollouts gap (ISE-512) went unnoticed because kind dictionaries are configured per cluster and nothing warns when a cluster serves a CRD that ISE maps on other clusters (or that matches a shipped preset). Suggestion: during sync, check served CRDs against the presets + other Systems' dictionaries, and surface a hint on the System detail page (or Unknown assets) — e.g. "this cluster serves argoproj.io/Rollout but has no dictionary entry; 34 objects invisible".