---
id: 01KXH1T5E9JTBHHW772V2HM6KF
created: 2026-07-14T19:31:41.129757493Z
updated: 2026-07-14T19:31:48.337929111Z
type: task
title: Fix the parallel-tool-call SQLAlchemy Session race
priority: high
task_status: todo
label:
- bug
- tech_debt
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 60
sprint: syz8rn1
---
**A live bug in shipped code, found while planning Sprint 6. Fix it before assist adds load to the same seam.**

Pydantic-ai executes tool calls **in parallel by default**, dispatching sync tools to separate executor threads. A SQLAlchemy `Session` is **not thread-safe**.

Today `analyse`, `diagnose` and `propose-remediation` all share one `Session` (`deps.db` in `ai/deps.py`) across tools the model can legitimately emit in a single response — e.g. `get_state_slices` + `list_open_findings` in one turn will run concurrently on two threads against the same Session.

This has not bitten only because the estate is small and the models have been calling tools one at a time. Assist — more tools, a chattier model, more turns — will find it.

## Fix

- `Tool(fn, sequential=True)` on the tool definitions in `ai/tools.py`, and/or a fresh short-lived Session per tool call.

## ⚠️ The obvious fix is a trap — comment this in the code

`Agent.parallel_tool_call_execution_mode('sequential')` is a **ContextVar**. If it is ever combined with pydantic-ai's `run_stream_sync` (which runs the graph on an anyio blocking portal — a raw `Thread`), contextvars **do not cross the thread boundary** and the setting is a **silent no-op**. The tests would pass and the race would ship.

Only `sequential=True` as **data on the `Tool` object** is trustworthy. Say so in the comment, or the next person will "simplify" it back.

## Test

`FunctionModel` (used nowhere in the codebase today — new test infrastructure) emitting two tool calls in one response; assert they do not overlap.

Files: `app/backend/src/ISE_api/ai/tools.py`, `ai/deps.py`, `ai/agents.py`