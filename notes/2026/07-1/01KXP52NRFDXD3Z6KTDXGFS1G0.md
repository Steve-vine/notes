---
id: 01KXP52NRFDXD3Z6KTDXGFS1G0
created: 2026-07-16T19:04:57.871310323Z
updated: 2026-07-19T13:25:16.769605698Z
type: task
title: 'Issue conversation: model + streaming turn endpoint (SSE)'
task_status: done
priority: high
label:
- feature
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 91
blocked_by:
- 01KXP51V7CR9VDWE6Z4T9WEV1F
sprint: s0v93ii
---
Stand up the **second SSE streaming surface** authorised by the ADR (ISE-89): a per-issue conversation the operator can chat into, streamed like assist but scoped to one issue and able to drive the loop.

**Persistence (migration, append-only):**
- Issue-scoped conversation thread + messages, analogous to the assist thread/message tables (`api/v1/assist.py`, models in `models.py`) but FK'd to `Issue`. One conversation per issue is fine to start.
- Messages persist via the *producer* session (ordinary, writable), cancel-shielded so an `AgentRun` + assistant message are recorded even on client disconnect (mirrors `ai/chat.py:492-510`).

**Endpoint:**
- `POST /api/v1/issues/{id}/conversation/turns` → `text/event-stream`. Operator-gated. The POST **is** the stream (ADR 0022). Reuse `sse.py` (`format_event`, `with_heartbeat`, `sse_response`, `X-Accel-Buffering: no`) and the `StreamLimiter` per-process concurrency cap → in-band `error` event on 429. Redis SETNX idempotency guard like `assist.py:166-169`.
- Runs in the **API process, not the `ai` Celery queue** (ADR 0022 rationale).

**The issue-chat agent:**
- New `ChatAgentDefinition`-style agent (see `ai/assist.py`), issue-scoped: system prompt + context = the issue, its evidence, and recent timeline. `output_type=str` so streaming works (`ai/chat.py:565`); tokens scrubbed through `StreamScrubber` before the browser; first-token rule for post-first-delta provider errors.
- Tools: read-only estate tools to start; the loop-driver tools are added in the follow-up task. Keep the `sequential=True` session wrapper (ISE-60).
- SSE event shapes declared as Pydantic models in the OpenAPI schema even though the body isn't JSON (ADR 0022), so the frontend parser is typed.

Blocked by the ADR (ISE-89). Label: feature.