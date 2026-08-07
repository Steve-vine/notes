---
id: 01KZEPX1EN1FEVG34T5V9HTY15
created: 2026-08-07T18:13:55.797407Z
updated: 2026-08-07T18:14:25.186991Z
type: task
title: AI-drafted report queries
project: 01KX671DATY39VW6GWK3M2T3DN
number: 619
sprint: sw5yz4n
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Describe a report in English; AI drafts the spec; user reviews, previews, saves — runs never touch AI. New `draft-report-query` task type (AI_TASK_TYPES + descriptions + migration 0107 rebuilding the agent_run CHECK — 0104 precedent; stacks on 0106 per the parallel-migration rule). AgentDefinition with `output_type = ReportQuerySpec` (drafted object IS the saved object), no tools; prompt embeds ENTITY_TYPES, AttributeOp vocabulary, built-in columns, identity-groups, and a new `attribute_key_inventory(db)` helper (jsonb_object_keys by type). `POST /api/v1/reports/draft-query {description} → {spec}`, computed on read like the learning endpoint, operator-gated, AgentRun recorded for spend. Modal gains the Draft-with-AI panel populating the builder.

Done = a described report drafts into the builder and saves unchanged. Carries migration 0107; api-types regen. Depends on the definitions task; last in the stack. Migration data-path test: insert agent_run rows at 0106, upgrade, rows survive.