---
id: 01KXRYQ1FRQY7ZPTP52EM981G5
created: 2026-07-17T21:11:28.504315343Z
updated: 2026-07-21T09:54:05.001514Z
type: task
title: AI model defaults — Opus on 6 of 8 task types is the base-rate cost driver
project: 01KX671DATY39VW6GWK3M2T3DN
number: 108
sprint: scxrykd
assignee: steve
priority: high
task_status: done
---
**Sprint 10 (Spend issues) — lever #2, cut the base rate.**

## Problem
**6 of 8 task types default to `claude-opus-4-8`** (seeded in `ai_model_config` migrations): `analyse`, `diagnose`, `propose-remediation`, `analyse-issue`, `assist`, `issue-chat`. Only `summarise-state` and `execution-followup` use Haiku.

Opus is the single largest per-token multiplier, and it is the default for the **30-minute scheduled `analyse`** — expensive AI running on a timer. Model config is DB-backed per task type and admin-editable (ADR 0013 / 0020), so re-tiering is a **config change, not a rebuild** — no new ADR strictly required, though the rationale should be recorded.

## Scope
- Reconsider the default tier per task type; bias toward cheaper models (Sonnet / Haiku) with escalation to Opus only where judgement quality genuinely demands it.
- Specifically question whether the scheduled `analyse` should ever run on Opus.
- Update the seeded defaults (new migration — append-only) and/or admin config; document the rationale.

## Acceptance
- Revised default model per task type with a written rationale.
- Measured cost-per-operation drop (compare `AgentRun.cost_usd` by task_type before/after) without unacceptable quality regression on a sample of analyse/diagnose runs.

Refs: `ai_model_config` seeds in `migrations/versions/20260712_0008_ai_model_config.py` (+ later task-type migrations); `ai/engine.py:54`, `ai/providers.py:56`. Pairs with the prompt-caching task.