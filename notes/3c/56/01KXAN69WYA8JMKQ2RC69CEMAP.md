---
id: 01KXAN69WYA8JMKQ2RC69CEMAP
created: 2026-07-12T07:55:40.830682572Z
updated: 2026-07-12T08:29:04.679716713Z
type: task
title: AI foundation — deps, provider config, model-config store + ADR
priority: medium
task_status: review
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 35
sprint: syv1q8m
---
Foundation for the Phase 3 AI engine (ADR 0013). Add pydantic-ai + anthropic + openai deps (+ mypy overrides, per the datadog pattern). Env settings: provider API keys (ISE_ANTHROPIC_API_KEY, ISE_OPENAI_API_KEY) + per-provider daily_spend_ceiling_usd. New DB-backed ai_model_config table (per task-type: provider, model_id, settings JSONB [temperature/thinking-budget/max-tokens], fallback_provider, fallback_model) + Alembic migration + seeded defaults (Claude everywhere; fast/cheap model for summarise-state, top-tier for analyse/diagnose). Admin read/write API + audit. ADR 0020 recording the AI engine + DB-backed admin-editable config approach (required — new architecture decision; first DB-backed config mechanism). Provider keys env-based → model selection stays no-redeploy.