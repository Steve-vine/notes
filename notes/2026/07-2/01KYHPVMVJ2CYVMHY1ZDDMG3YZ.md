---
id: 01KYHPVMVJ2CYVMHY1ZDDMG3YZ
created: 2026-07-27T11:55:11.602698Z
updated: 2026-08-07T10:56:11.390654Z
type: task
title: Every MCP interaction recorded on the ticket + live investigation activity in the UI
project: 01KX671DATY39VW6GWK3M2T3DN
number: 334
sprint: sax9eff
assignee: steve
priority: high
task_status: done
---
Steve must-have #3: ALL get and put interactions recorded against the pinned incident — and the pane-of-glass compensation that makes Variant A honest.

- **Writes are first-class timeline events** (existing event types where they exist: status change, merge, note, diagnosis, approval), attributed to the user with a "via Claude" marker so in-app vs MCP provenance is always visible.
- **Reads are recorded but collapsed**: a session-grouped "investigation activity" timeline block (new event kind) — "Steve via Claude: 14 reads, 3 evidence fetches" — expandable to the per-call list (tool, args summary, timestamp). Full detail in the audit trail; the timeline stays legible (the Sprint 16 timeline-legibility lesson).
- Capture at the MCP dispatch layer so a tool CANNOT be added later that skips recording — recording is structural, not per-tool discipline.
- **UI (pane-of-glass DoD)**: the incident timeline updates **live** while a session runs (reuse/extend the existing refresh pattern) — an operator watching the incident screen sees evidence arriving and notes landing as the Claude conversation proceeds. Paired with the session chip, the app remains the real-time record even though the conversation is elsewhere.
- Retention: investigation-activity events follow the existing event-retention policy.

Vertical DoD: run a Claude session against a staging incident; every call appears on the ticket; a second browser watching the incident sees activity appear without refreshing.