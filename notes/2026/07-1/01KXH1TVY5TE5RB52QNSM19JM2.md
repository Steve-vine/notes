---
id: 01KXH1TVY5TE5RB52QNSM19JM2
created: 2026-07-14T19:32:04.165973961Z
updated: 2026-07-21T17:44:33.914394Z
type: task
title: ADR 0022 + SSE transport foundation
project: 01KX671DATY39VW6GWK3M2T3DN
number: 61
sprint: syz8rn1
blocked_by:
- 01KXH1T5E9JTBHHW772V2HM6KF
assignee: steve
label: null
priority: high
task_status: done
---
The first streaming code in the codebase. Lay the transport before anything rides on it.

## ADR 0022 — Server-Sent Events for streamed agent output

Records the departure from `ui-brief.md:45` ("polling per screen is sufficient for v1; no websocket infrastructure until something needs it"). Chat **is** the thing that needs it: a 15s poll for a chat reply is not usable.

- **SSE, not websockets** — one-way, passes through nginx/Traefik, no new infra beyond a `StreamingResponse`.
- **Assist runs in the API process, not Celery.** Celery + Redis pub/sub would hold the API request open for the model call *anyway*, so it buys nothing — while adding a publisher, a second (async) Redis client flavour, and reconnect semantics. It would also queue an interactive turn behind a scheduled `analyse` run, which is the ISE-57 asymmetry applied to time instead of money.
- **ADR 0002 (sync SQLAlchemy) is NOT superseded and must not be.** FastAPI already runs every `def` endpoint in the anyio threadpool, and pydantic-ai already offloads sync tools to threads — sync SQLAlchemy never touches the event loop. The only discipline: our own async generator does its DB work via `run_in_threadpool`.

## Transport plumbing

- `StreamingResponse` + a **15s `: ping` heartbeat**. The heartbeat is the universal fix — it defeats nginx `proxy_read_timeout`, Traefik's idle timeout, and any corporate proxy in between, all at once, and costs nothing.
- `X-Accel-Buffering: no` response header (belt and braces — works even if the nginx location regex is subtly wrong).
- **nginx** (`helm/templates/frontend/configmap-nginx.yaml`): a location scoped to the streaming path only, with `proxy_buffering off`, `gzip off`, `proxy_read_timeout 300s`. The existing `/api/` block already sets `proxy_http_version 1.1` and `Connection ""` (both needed), but buffers and would guillotine at the 60s default. Scope it to the one path — `proxy_buffering off` across all of `/api/` would degrade every normal JSON response.
- **vite** (`app/frontend/vite.config.ts`): `timeout: 0, proxyTimeout: 0`. Vite pipes rather than buffers, so SSE mostly works in dev today — which is exactly why the nginx problem only shows up in staging.
- `terminationGracePeriodSeconds: 90` on the API deployment, so a rolling deploy doesn't guillotine a 60s answer at the 30s default.
- Explicit DB pool sizing in `db.py` (currently SQLAlchemy defaults, 5+10 — tight for the first workload that holds a connection for more than 10ms).
- A concurrency semaphore (default ~4) → 429 "assist is busy". Stops assist eating the 40-thread anyio limiter shared with every sync endpoint. Note in a comment that the semaphore is **per-process** — if anyone later adds `--workers N` the cap becomes N×4.

Blocked by: ISE-60.