---
id: 01KXAN6PK9DRP6D3CSMRNZB0FB
created: 2026-07-12T07:55:53.83387892Z
updated: 2026-07-12T13:55:00.633589471Z
type: task
title: diagnose agent — root-cause narrative on an Issue
priority: medium
task_status: active
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 38
blocked_by:
- 01KXAN6FR3SF2G2SGM56A419Z7
sprint: syv1q8m
---
diagnose task type (ai-engine brief): triggered when an operator diagnoses an Issue. Read-only tools scoped to the involved system(s) → root-cause narrative + evidence chain + remediation OPTIONS (descriptive only — NO ProposedChange in Phase 3; proposals are Phase 4). Result attached to the Issue via its AgentRun (agent_run_id / outcome). POST /issues/{id}/diagnose operator trigger. Tests with a stubbed model. Read-only tool set allow-listed per task type.