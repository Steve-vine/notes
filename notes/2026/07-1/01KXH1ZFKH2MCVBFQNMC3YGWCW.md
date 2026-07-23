---
id: 01KXH1ZFKH2MCVBFQNMC3YGWCW
created: 2026-07-14T19:34:35.377324512Z
updated: 2026-07-23T18:34:27.182469Z
type: task
title: Assist chat UI
project: 01KX671DATY39VW6GWK3M2T3DN
number: 70
sprint: syz8rn1
blocked_by:
- 01KXH1Y5K7BHEG7KJGRQST6763
assignee: steve
priority: high
task_status: done
---
Replace the `PlaceholderPage` at `/assist` (`App.tsx`) — the last placeholder in the nav.

## Use `fetch` + `ReadableStream`, NOT `EventSource`

**`EventSource` auto-reconnects on *any* transport close — including the legitimate close at the end of our stream.** Every network blip mid-answer, every Vite HMR reload, every React StrictMode double-mount fires a fresh GET → **a second model run and a second charge**, silently, invisible to the user. This cannot be turned off. That alone disqualifies it.

`fetch` also gives us:
- Real HTTP status codes (401 / 403 / **429** / 503). `EventSource.onerror` is opaque — we could not tell "assist is busy" from "you are logged out".
- A request body (so `POST .../turns` can carry the message in one round trip).
- `AbortController` → a **Stop** button the server sees as a clean disconnect.

Cookies flow either way (`fetch` defaults to `credentials: 'same-origin'`, and the session cookie is HttpOnly same-origin). Cost: ~40 lines of SSE line-parsing in a new `app/frontend/src/lib/assistStream.ts`, typed against the generated `AssistEvent` union from ISE-67.

## The screen

- Thread list + new thread; message history.
- Streaming render of `delta` events.
- **Tool-call trace** (`tool_start` / `tool_end`) — visible, not hidden. This is the "evidence over vibes" principle: the operator can see what assist actually read.
- **Citation chips** → links into `/systems/{id}`, `/issues/{id}`, `/approvals?change={id}`, `/agent-runs/{id}`. An unresolved citation renders as plain text, never a broken link.
- Stop button (`AbortController`).
- Error states: `budget_exceeded` and a cut-off partial answer with a **Retry** affordance (see ISE-65's first-token rule — a truncated answer is shown honestly, not silently retried).
- Suggestions link **into the proposal flow** rather than acting (ui-brief §7: assist is read-only).

## Housekeeping

- `components/nav.ts` — drop `arrivesInPhase: 5` from the Assist item.
- `App.test.tsx:185-187` asserts the placeholder at `/assist` — update it.

Blocked by: ISE-67.