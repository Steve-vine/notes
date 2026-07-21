---
id: 01KXH1Y5K7BHEG7KJGRQST6763
created: 2026-07-14T19:33:52.359138015Z
updated: 2026-07-21T16:23:19.898985Z
type: task
title: Assist API + SSE endpoint
project: 01KX671DATY39VW6GWK3M2T3DN
number: 67
sprint: syz8rn1
blocked_by:
- 01KXH1X85G8DQYM4DJ5GD5E0W2
- 01KXH1XNKNP1M4MTRPMH4N7N4C
assignee: steve
label: null
priority: high
task_status: done
---
New `app/backend/src/ISE_api/api/v1/assist.py`.

## Endpoints

```
POST   /api/v1/assist/threads                 -> AssistThreadRead     (operator)
GET    /api/v1/assist/threads                 -> list                 (viewer)
GET    /api/v1/assist/threads/{id}/messages   -> list                 (viewer)
POST   /api/v1/assist/threads/{id}/turns      -> text/event-stream    (operator)  ← the stream
DELETE /api/v1/assist/threads/{id}            -> 204                  (operator)
```

**`POST .../turns` is a single request whose response *body* is the SSE stream** — not POST-then-GET-to-stream. The user message is persisted and the model call starts in one round trip, so there is no orphaned "created a message but never streamed it" state.

## SSE event types

`start` · `tool_start` · `tool_end` · `citation` · `delta` · `provider_fallback` · `done` · `error` · `: ping` (heartbeat)

## Degradation — the "never raises" contract survives, and gets stronger

The stream generator always terminates the HTTP response **cleanly**: `200` + `event: error`, **never a 500 mid-body** — a browser cannot distinguish a 500 mid-body from a truncated success. Budget exhaustion is checked *before* the model call → `event: error {reason: "budget_exceeded"}` + `AgentRun(status="budget_exceeded")`, identical semantics to `_budget_exhausted` today, just delivered down the wire.

## Keep the SSE contract in OpenAPI

`openapi-fetch` cannot type a non-JSON response, so the event shapes would **silently drift** — the streaming contract would be the only untyped part of the whole app.

Fix: define the events as Pydantic models in `api/v1/schemas.py` as a discriminated union (`AssistEvent = Annotated[Start | ToolStart | ... , Field(discriminator="event")]`) and reference it from the route via `responses={200: {"model": AssistEvent, "content": {"text/event-stream": {}}}}`. FastAPI then emits them into `components/schemas`, `npm run generate:api` picks them up, the frontend parser gets a typed union, and **the existing `api-types` CI drift job covers the streaming contract**.

## Idempotency

Redis `SETNX ise:assist:turn:{key}` so a retried POST can never start a second model run and a second charge.

RBAC per the table above; threads are scoped to their owner.

Blocked by: ISE-65, ISE-66.