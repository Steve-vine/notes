---
id: 01KXAN6FR3SF2G2SGM56A419Z7
created: 2026-07-12T07:55:46.819995458Z
updated: 2026-07-12T09:02:57.245779568Z
type: task
title: AI engine core + summarise-state agent
priority: medium
task_status: active
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 36
blocked_by:
- 01KXAN69WYA8JMKQ2RC69CEMAP
sprint: syv1q8m
---
The heart of Phase 3 (ai-engine brief). New ISE_api/ai/ package: agent builder assembling a Pydantic-AI Agent from a task-type definition (system prompt, output schema, model from ai_model_config) + a runtime tool set (read-only connector tools built from the registry via ConnectorContext/credentials.reveal, scoped to the run's systems, allow-listed per task type; plus ISE lookup tools: snapshots/findings/issue history). Run executor: creates the AgentRun (redacted transcript via redact(), tokens, cost estimate, outcome), enforces per-run budget (max tokens/tool-call iterations → budget_exceeded), one fallback-model retry, daily spend-ceiling check. Celery tasks/ai/ package on the pre-wired 'ai' queue (add to include list). First concrete agent: summarise-state (no tools, works from latest snapshot) — proves the engine end-to-end. Failures degrade never block (ADR 0006). Tests stub the model with canned structured outputs. Live check on staging against the real provider.