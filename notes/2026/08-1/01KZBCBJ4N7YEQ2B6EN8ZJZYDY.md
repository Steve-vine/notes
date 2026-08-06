---
id: 01KZBCBJ4N7YEQ2B6EN8ZJZYDY
created: 2026-08-06T11:11:54.00574Z
updated: 2026-08-06T11:11:54.00574Z
type: task
title: 'MCP: assign_incident — "assign this incident to me" from a pinned Claude Code session'
label: improvement
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 589
---
Found during ISE Test Plan execution (2026-08-06): "assign the incident to me" has no MCP path. The surface has `update_incident_status` (acknowledge/resolve/dismiss/close/reactivate) but no assignment tool, even though assignment is a first-class app capability (Active = "assigned to a person to deal with") and the session already knows exactly who "me" is — the pinned user.

Scope:
- Add `assign_incident` to the MCP registry: min_role responder (same tier as `update_incident_status`), needs_session, is_write. Default target is the session's own user ("assign to me" needs no lookup); optionally accept another user by name/email, resolved against ISE users, refusing ambiguity rather than guessing.
- Go through the same service path as the app's assignment (status transition to Active, timeline entry, any notification hooks) — no parallel logic.
- Recorded as `mcp_activity` (is_write) on the incident like the other writes.
- Integration tests alongside `test_mcp_actions.py`; add a checkbox to ISE Test Plan memo §3 (incident actions).

Done when: from a pinned session, "assign this incident to me" assigns and activates the incident, visible in the app with the assignee's name on the incident and the change on the timeline.