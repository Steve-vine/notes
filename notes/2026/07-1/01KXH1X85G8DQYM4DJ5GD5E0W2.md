---
id: 01KXH1X85G8DQYM4DJ5GD5E0W2
created: 2026-07-14T19:33:22.224215896Z
updated: 2026-07-19T11:52:32.68852349Z
type: task
title: ai/chat.py — stream_chat(), the multi-turn streaming runner
priority: high
task_status: done
label:
- feature
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 65
blocked_by:
- 01KXH1VEB2V61291GN26DC0QP5
- 01KXH1VZV34ZQA7XCBYG2YJRNJ
- 01KXH1WFKCER3XHQY1GQMRYRFR
sprint: syz8rn1
tech: null
---
The engine today (`ai/engine.py`, `run_agent`) is **single-shot**: one prompt, structured Pydantic output, no message history. Assist needs multi-turn, streamed prose.

## A NEW module — do not generalise `run_agent`

`ai/chat.py` with `stream_chat()`. `run_agent`'s signature, semantics and tests stay byte-for-byte identical; the four existing task types are untouched; **zero regression risk**.

Assist's definition lives in a new `ai/assist.py` as a separate `ChatAgentDefinition` (output type is `str`, not a Pydantic model), keeping `AgentDefinition` frozen and its four instances untouched.

## Reuse by extraction, NOT duplication

Promote out of `engine.py` (rename `_` → public — they are already pure functions):

- `daily_spend`, `budget_for`, `_budget_exhausted` — **used as-is**
- `_finish` → `finish_run(run, *, status, outcome, provider, model)`
- `_usage_limits` → `usage_limits_for(settings)`
- **new** `record_usage(run, usage, model_id)` — the four lines at `engine.py:125-128` (`redact(json.loads(all_messages_json()))`, tokens, `estimate_cost_usd`). Both `run_agent` and `stream_chat` call it. **Redaction is reused, not reimplemented.**
- `build_model` from `providers.py` — as-is

## Async generator + `agent.run_stream()` — NOT `run_stream_sync()`

`run_stream_sync` exists and looks tempting. It is wrong here: `StreamingResponse` wraps a sync iterator in `iterate_in_threadpool`, and an in-flight `to_thread.run_sync` **cannot be cancelled**. On client disconnect the generator is *abandoned* and its `finally` runs at GC — nondeterministically, or never if the pod dies — leaving `AgentRun.status='running'` **forever** and breaking the engine's "always records" contract.

With `async def` + `run_stream()`: disconnect → `aclose()` → `GeneratorExit` → our `finally` runs **deterministically**. Wrap the persistence in a **shielded cancel scope** so the write completes even as the task is cancelled. **The tokens were spent; the run must be recorded.**

## No DB connection is held across the model call

Three touchpoints, three short-lived sessions: load history + insert the `running` AgentRun (threadpool, commits *before* the model call); one read-only session **per tool call**, opened inside the tool (ISE-63); persist text + citations + transcript + usage (threadpool, shielded). The naive alternative — passing the request session as `deps.db` and holding it for 90s — parks an idle-in-transaction connection per chat turn.

## The first-token rule for provider fallback

Once a delta has reached the browser, a silent retry is a **lie** — it would either duplicate or contradict text already on screen.

- **Before the first delta:** a `_FALLBACK_ERRORS` exception retries on the fallback provider transparently (same list, same order as `_run_with_fallback`). Emit `event: provider_fallback`; set `outcome["fallback_used"] = True`.
- **After the first delta:** a provider failure is **terminal**. `event: error {reason: "provider_error", partial: true}`, stream closes, partial text stays on screen with a Retry affordance, `AgentRun` is `failed` with the partial recorded. The user re-sends; that is a new turn, and it is honest.
- `UsageLimitExceeded` → `budget_exceeded`, **no fallback** (a different model won't help) — same rule as `engine.py:108-117`.

Implementation is one boolean: `emitted_any_text`. Do **not** buffer the whole answer to preserve fallback — that throws away the only reason we are streaming.

Log `agent_run_id` on every line — ADR 0010's pipeline carries no request id, so a failed stream is otherwise unfindable in prod.

Blocked by: ISE-62, ISE-63, ISE-64.