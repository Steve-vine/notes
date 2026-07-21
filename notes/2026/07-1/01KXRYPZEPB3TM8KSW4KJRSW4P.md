---
id: 01KXRYPZEPB3TM8KSW4KJRSW4P
created: 2026-07-17T21:11:26.422122559Z
updated: 2026-07-21T18:31:25.255219Z
type: task
title: Prompt caching for the AI engine — stop re-billing context on every round-trip
project: 01KX671DATY39VW6GWK3M2T3DN
number: 107
sprint: scxrykd
assignee: steve
priority: high
task_status: done
---
**Sprint 10 (Spend issues) — lever #1, biggest bang.**

## Problem
There is **zero prompt caching** in the AI path. `build_model` (`ai/providers.py:56`) passes only `max_tokens` to `AnthropicModel` — no `cache_control` markers anywhere. So the full system prompt + tool schemas + accumulated tool output are re-sent **uncached on every model round-trip**.

This compounds badly with two existing multipliers:
- The judgement tasks loop up to **13 round-trips** (`ai_run_max_tool_iterations + 1`, `settings.py:86`); context accumulates each hop and is re-billed at full input price (a real diagnose measured **90k tokens**, `settings.py:83-84`).
- Both chat surfaces re-send up to **12 prior turns** every turn (`ai_chat_history_turns`, `settings.py:101`).
- Scheduled `summarise`/`analyse` re-send the same system prompt on every dispatch.

Not covered by any ADR — this is a gap, not a decision. **May warrant an ADR.**

## Scope
- Add Anthropic prompt caching (`cache_control: ephemeral`) on the stable prefix — system prompt + tool schemas — at the `build_model` / agent-construction seam (`ai/providers.py:56`, `ai/engine.py:108`, `ai/chat.py:696`).
- Confirm Pydantic-AI exposes cache-control and cached-token usage; wire cached tokens into `record_usage` / `AgentRun` so we can see the effect.
- Decide whether an ADR is needed.

## Acceptance
- Measurable input-token / `cost_usd` reduction on analyse & diagnose runs (compare `AgentRun` rows before/after).
- Cached-token counts observable per run.

Refs: `ai/providers.py:56`, `ai/engine.py:108-116`, `ai/chat.py:696-731`, `settings.py:86,101`.