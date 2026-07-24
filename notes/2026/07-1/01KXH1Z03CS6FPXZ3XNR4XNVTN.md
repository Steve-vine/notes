---
id: 01KXH1Z03CS6FPXZ3XNR4XNVTN
created: 2026-07-14T19:34:19.500243276Z
updated: 2026-07-24T12:07:56.478679Z
type: task
title: Stale-run reaper — no permanent spinners
project: 01KX671DATY39VW6GWK3M2T3DN
number: 69
sprint: syz8rn1
blocked_by:
- 01KXH1X85G8DQYM4DJ5GD5E0W2
assignee: steve
priority: medium
task_status: done
---
`stream_chat` (ISE-65) persists its `AgentRun` from a **shielded** `finally`, so an ordinary client disconnect is handled deterministically.

A **pod kill is not**. `kubectl rollout restart` — or an OOM, or a node eviction — mid-chat leaves an `AgentRun` stuck at `status='running'` and its `AssistMessage` stuck mid-stream, forever. The UI then shows a **permanent spinner** on that thread, on every reload, and nothing will ever clear it.

## Fix

A Beat sweep (`reap_stale_assist_runs`, ~every 5 min) that fails `AgentRun`s left `running` past a timeout, and marks their messages failed.

Follow the existing Beat/task conventions: idempotent, takes ids not objects, JSON serialisation only (ADR 0006). Register in `worker.py`'s beat schedule alongside `dispatch_summaries` / `dispatch_analyses`.

Worth applying to **all** task types, not just assist — a worker OOM during an `analyse` run leaves the same orphan today, it is just less visible because nobody is staring at it.

Blocked by: ISE-65.