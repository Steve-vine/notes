---
id: 01KZDRNNDFCRR164MCWJ8X35KX
created: 2026-08-07T09:25:36.815307Z
updated: 2026-08-07T16:52:39.992466Z
type: task
title: Assist message affordances — copy, regenerate, edit-and-resend
project: 01KX671DATY39VW6GWK3M2T3DN
number: 603
sprint: snk16ew
assignee: steve
label: null
priority: medium
task_status: active
---
Per-message actions on the Assist conversation (shared chat primitives in components/chat.tsx — issue-chat inherits where it makes sense):

- **Copy** an assistant answer as markdown (one click, with citations rendered as links).
- **Regenerate** the last answer: re-runs the turn with the same question; the superseded answer is replaced, not duplicated (idempotency-key handling — a regenerate is a NEW turn, not a 409 retry).
- **Edit-and-resend** the last user question: prefills the composer, superseding the last exchange.
- Respect the streaming state machine (useAssistTurn) — affordances disabled mid-stream; Stop remains the only mid-stream action.

Screen: AssistPage message bubbles gain a quiet hover action row.