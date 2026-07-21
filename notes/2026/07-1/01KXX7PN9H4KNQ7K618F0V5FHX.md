---
id: 01KXX7PN9H4KNQ7K618F0V5FHX
created: 2026-07-19T13:05:30.929199361Z
updated: 2026-07-21T17:43:55.122306Z
type: task
title: DataDog metrics/events/logs → on-demand Evidence
project: 01KX671DATY39VW6GWK3M2T3DN
number: 150
sprint: sehghhk
blocked_by:
- 01KXX7PFW4YY0QBG15YHB6FXP7
assignee: steve
priority: medium
task_status: done
---
**Sprint 15 (vertical slice: backend + UI).** Move DataDog's read path onto the Evidence capability — redeeming ADR 0014/0027 and cutting the last big idle-spend source.

- **Backend**: move DataDog metrics / events / logs from eager `read_state` slices to **on-demand Evidence** (optionally via the DataDog MCP server). The eager `metrics` slice (a standing idle-spend drain, ISE-109) stops being polled every cycle; it is fetched only during investigation.
- **UI**: DataDog Evidence is pulled during investigation (in the conversation/agent-run trace), and the retired eager slice no longer appears on **System detail**.

**DoD**: DataDog metrics/logs are fetched as Evidence during an incident, not synced every cycle; the eager metrics slice is gone from System detail; idle DataDog spend drops. Not done until the on-demand path is used and the eager slice is removed from the UI.

Depends on Evidence-on-demand.