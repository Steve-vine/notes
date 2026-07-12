---
id: 01KXAN6KNK5VX3WR8R69Q2C9G0
created: 2026-07-12T07:55:50.835157694Z
updated: 2026-07-12T10:17:01.215890229Z
type: task
title: analyse agent — AI-created Issues with evidence
priority: medium
task_status: active
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 37
blocked_by:
- 01KXAN6FR3SF2G2SGM56A419Z7
sprint: syv1q8m
---
analyse task type (ai-engine brief): read-only connector tools + snapshot/finding lookups → structured list of Issues (title, severity, confidence, evidence refs). Persist as Issue rows with source='ai' (extend ISSUE_SOURCES) linked to the AgentRun (agent_run_id). Deterministic dedup/idempotency against existing open AI issues per system so the scheduled pass never spams duplicates. Scheduled Beat pass (per-system, gated) + POST /systems/{id}/analyse operator trigger. No mutation (Phase 3 analysis-only). Tests with a stubbed model asserting issue creation + dedup + evidence links + tool allow-listing (analysis agent cannot reach a mutating capability).