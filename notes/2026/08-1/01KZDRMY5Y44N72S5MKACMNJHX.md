---
id: 01KZDRMY5Y44N72S5MKACMNJHX
created: 2026-08-07T09:25:13.022499Z
updated: 2026-08-07T13:35:45.947259Z
type: task
title: Assist thread titles — auto-generate from first exchange, rename in sidebar
project: 01KX671DATY39VW6GWK3M2T3DN
number: 600
sprint: snk16ew
assignee: steve
label: null
priority: medium
task_status: active
---
Every Assist thread is permanently titled "New conversation" — the sidebar is unusable past a handful. 

- Auto-title after the first turn completes: cheap model call (respects ai_limits/budget accounting) summarising the first question into ≤6 words; falls back to a truncated first question if the call fails. Set once, never regenerated.
- `PATCH /threads/{id}` rename endpoint (owner-only, same 404-for-foreign rule) + inline rename in the sidebar.
- Existing threads: backfill title from first user message on next load (no migration of prose needed — a data backfill or lazy fill, decide in implementation).

Screen: AssistPage sidebar shows real titles with rename affordance.