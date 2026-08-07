---
id: 01KZ8YMAK6QQ5AJMZR234JQC4N
created: 2026-08-05T12:33:32.26266Z
updated: 2026-08-07T09:40:40.814988Z
type: task
title: Propose-remediation burns its whole iteration budget on empty searches, dies with run_limit_exceeded
project: 01KX671DATY39VW6GWK3M2T3DN
number: 560
sprint: scb3vol
comments:
- id: 01KZ99HH8K9V41WGQRXDEHJSB8
  author: Steve Vine
  at: 2026-08-05T15:44:15.123679Z
  text: |-
    Fixed on feature/ise-560-empty-search-budget, PR #475 (targeting main), merged to staging.

    Three of the four fix ideas implemented:

    1. Tool-side guard (the model-agnostic one): AgentDeps now tracks consecutive empty results per search tool. From the 2nd consecutive empty result, the tool result carries an explicit "nothing is indexed for this — stop searching this source and proceed with the evidence you already have" hint. Wired into both variants of search_repo_knowledge/search_documents (single-shot tools.py — the actual IN-1210 burn site — and chat assist_tools.py) plus search_commit_history. A hit resets the count; counts are per-tool.

    2. Prompt: propose-remediation's system prompt now states repo/document knowledge is optional context and to draft a best-effort proposal from monitor/estate evidence when searches come up empty.

    3. Graceful degradation: on an ITERATION-cap kill the engine resumes the pending request once, tools-disabled, with a final-answer instruction — the gathered evidence becomes a structured best-effort outcome (outcome carries degraded:true + degraded_reason) instead of run_limit_exceeded with nothing. Token-cap kills stay fatal on purpose: that cap is the runaway guard, and the final call keeps the fresh-token cap — it grants one more request, never more tokens.

    4. Per-task iteration override: considered, NOT added — with the guard and the final call, the 12-iteration default is no longer the failure mode, and it keeps the admin cap a single knob.

    Tests: new unit tests for the guard (hint on 2nd empty, reset on hit, per-tool counts) and an integration test reproducing the IN-1210 shape (FunctionModel looping on tools forever → iteration-capped → degraded final call → succeeded run with the proposal). Existing token-cap kill tests unchanged and green. ruff/mypy/pytest all clean locally; PR CI is the gate.
assignee: steve
label: null
priority: high
task_status: done
---
Found during Sprint 50 incident-management testing: Propose remediation on IN-1210 (Datadog synthetics private-location monitor) returned "Run limit exceeded". Run `655551f8` hit the tool-iteration cap (`ai_run_max_tool_iterations` default 12 → request_limit 13, no admin override set), spending 221k input tokens and producing nothing.

## Why

The transcript shows 23 tool calls; 11× `search_repo_knowledge` + 3× `search_documents`, and **every one returned `{"results": []}`** — the agent kept reformulating queries against sources with nothing indexed for this system until the cap killed it, never reaching the proposal step.

## Fix ideas

- After ~2 consecutive empty results from the same search tool, have the tool return an explicit "nothing is indexed for this — stop searching, proceed with the evidence you have" hint (tool-side guard, model-agnostic).
- Prompt: tell propose-remediation that repo/document knowledge is optional context, and to produce a best-effort proposal from monitor/estate evidence when searches come up empty.
- Graceful degradation: when the next request would exceed the limit, do one final tools-disabled call to emit a best-effort proposal instead of finishing `run_limit_exceeded` with nothing.
- Consider whether 12 iterations is right for propose-remediation specifically (per-task-type override, like `run_max_tokens_for`).