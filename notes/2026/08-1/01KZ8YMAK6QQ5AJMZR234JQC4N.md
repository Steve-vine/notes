---
id: 01KZ8YMAK6QQ5AJMZR234JQC4N
created: 2026-08-05T12:33:32.26266Z
updated: 2026-08-05T12:34:18.770987Z
type: task
title: Propose-remediation burns its whole iteration budget on empty searches, dies with run_limit_exceeded
project: 01KX671DATY39VW6GWK3M2T3DN
number: 560
assignee: steve
priority: high
task_status: backlog
---
Found during Sprint 50 incident-management testing: Propose remediation on IN-1210 (Datadog synthetics private-location monitor) returned "Run limit exceeded". Run `655551f8` hit the tool-iteration cap (`ai_run_max_tool_iterations` default 12 → request_limit 13, no admin override set), spending 221k input tokens and producing nothing.

## Why

The transcript shows 23 tool calls; 11× `search_repo_knowledge` + 3× `search_documents`, and **every one returned `{"results": []}`** — the agent kept reformulating queries against sources with nothing indexed for this system until the cap killed it, never reaching the proposal step.

## Fix ideas

- After ~2 consecutive empty results from the same search tool, have the tool return an explicit "nothing is indexed for this — stop searching, proceed with the evidence you have" hint (tool-side guard, model-agnostic).
- Prompt: tell propose-remediation that repo/document knowledge is optional context, and to produce a best-effort proposal from monitor/estate evidence when searches come up empty.
- Graceful degradation: when the next request would exceed the limit, do one final tools-disabled call to emit a best-effort proposal instead of finishing `run_limit_exceeded` with nothing.
- Consider whether 12 iterations is right for propose-remediation specifically (per-task-type override, like `run_max_tokens_for`).