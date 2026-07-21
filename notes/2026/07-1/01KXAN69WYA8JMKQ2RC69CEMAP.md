---
id: 01KXAN69WYA8JMKQ2RC69CEMAP
created: 2026-07-12T07:55:40.830682572Z
updated: 2026-07-21T15:30:34.059414Z
type: task
title: AI foundation — deps, provider config, model-config store + ADR
project: 01KX671DATY39VW6GWK3M2T3DN
number: 35
sprint: syv1q8m
comments:
- id: 01KXAQ3RERA0XHJNERMFPQX3VX
  author: Steve Vine
  at: 2026-07-12T08:29:14.584892314Z
  text: 'Development complete on feature/ise-035-ai-foundation. PR #33: https://github.com/Steve-vine/ise/pull/33. AI-engine foundation (ADR 0013): added pydantic-ai-slim[anthropic,openai] (Pydantic AI 2.9, Anthropic 0.116 + OpenAI 2.45 providers, both typed → no mypy overrides). Env settings: ISE_ANTHROPIC_API_KEY, ISE_OPENAI_API_KEY, per-provider ai_daily_spend_ceiling_usd + per-run token/iteration caps (.env.example documented). New DB-backed ai_model_config table (migration 0008): one row per AI task type — provider, model_id, settings JSONB, fallback provider/model — CHECK-constrained enums, seeded with Claude defaults (haiku for summarise-state, opus for analyse/diagnose) + OpenAI fallback. Admin-only /api/v1/ai-config (GET list, PUT upsert per task type), audited — switching a task type Claude↔OpenAI is a row update, no redeploy. ADR 0020 records the split (provider keys in env, model selection in DB — first DB-backed admin config mechanism). Also hardened test_audit''s scalar_one() (assumed global uniqueness of ''updated'' rows — only true by alphabetical test-order luck). Tests: mypy/ruff clean, migration 0008 up/down round-trips + seeds, new test_ai_config_api (defaults/admin-gating/upsert-persist-audit/validation/OpenAPI), full suite 138 passed; frontend tsc clean + regenerated types pass prettier. CI note: first push failed ruff format --check on the test file (I''d run ruff check not ruff format on it) — fixed. PR CI green. Merged to staging (0b19c28); deploy-staging fully GREEN incl. smoke check; migration 0008 applied via the pre-upgrade hook (Helm upgrade success). Verified pods freshly rolled + healthy on g5. NOTE: backend-only foundation — no UI surface yet (model-config UI is ISE-42), so little to click-smoke-test; acceptance rests on tests + healthy deploy + migration applied. Next: ISE-36 (engine core + summarise-state) — needs the Anthropic API key provisioned for its live check.'
- id: 01KXARWVTJTHMAY5RB1KSXS12E
  author: Steve Vine
  at: 2026-07-12T09:00:25.810250617Z
  text: 'Smoke tests passed. PR #33 merged to main (e0a11f6), branch deleted. Belt-and-braces main run green. Done. First task of Sprint 4 (Phase 3) complete.'
assignee: steve
label: null
priority: medium
task_status: done
---
Foundation for the Phase 3 AI engine (ADR 0013). Add pydantic-ai + anthropic + openai deps (+ mypy overrides, per the datadog pattern). Env settings: provider API keys (ISE_ANTHROPIC_API_KEY, ISE_OPENAI_API_KEY) + per-provider daily_spend_ceiling_usd. New DB-backed ai_model_config table (per task-type: provider, model_id, settings JSONB [temperature/thinking-budget/max-tokens], fallback_provider, fallback_model) + Alembic migration + seeded defaults (Claude everywhere; fast/cheap model for summarise-state, top-tier for analyse/diagnose). Admin read/write API + audit. ADR 0020 recording the AI engine + DB-backed admin-editable config approach (required — new architecture decision; first DB-backed config mechanism). Provider keys env-based → model selection stays no-redeploy.