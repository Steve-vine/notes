---
id: 01KXP6RDMDV8DV0TA21BZFARR2
created: 2026-07-16T19:34:19.021775553Z
updated: 2026-07-17T19:22:34.49023911Z
type: task
title: Progress indicator while awaiting an AI response
label:
- feature
task_status: done
priority: medium
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 101
blocked_by:
- 01KXP543Q76F4SQVAAE682B51X
- 01KXP54B0GC49QBJKX40YE2Y5N
sprint: s0v93ii
---
Show the operator that the AI is working, in both AI paths the redesigned Issues screen has — otherwise a click or a prompt looks like it did nothing until the answer lands.

**Two distinct waits to cover:**

1. **Streamed chat turn (ISE-91/ISE-97).** Between sending a prompt and the first `delta`, and again during `tool_start`→`tool_end`, show a "thinking…" affordance in the live bubble. Assist already renders `Loader type="dots"` while streaming (`AssistPage.tsx:258-298`) and tracks running tool calls in `useAssistTurn`; extend that to a clear pre-first-token state and a "using {tool}…" label during tool calls, reusing the same state machine.

2. **Async button-triggered agents (ISE-98).** Diagnose / Propose / Analyse return `202` and complete **later** via Celery (they are not streamed) — the result surfaces through the timeline (ISE-92) once the `AgentRun` finishes. Render a **pending placeholder bubble** the moment the trigger is accepted (an `AgentRun` in `status="running"`), so there's an in-progress marker in the feed until the run resolves.

**Must resolve, never hang:**
- Clear the indicator on the terminal event/state: streamed `done`/`error`; async `AgentRun` reaching `succeeded` / `failed` / `budget_exceeded`.
- Account for stale runs reaped by the Beat `reap-stale-agent-runs` job (`worker.py:86-89`) — a placeholder whose run was reaped must fall back to a failed state, not spin forever.

Frontend only; reuses the assist streaming state and the timeline feed. Blocked by the timeline feed (ISE-97) and the input panel (ISE-98). Label: feature.