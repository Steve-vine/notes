---
id: 01KZBCBJ4N7YEQ2B6EN8ZJZYDY
created: 2026-08-06T11:11:54.00574Z
updated: 2026-08-06T15:05:41.330778Z
type: task
title: 'MCP: assign_incident — "assign this incident to me" from a pinned Claude Code session'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 589
sprint: sp337by
comments:
- id: 01KZBSQF90YQ77R2NND3RDPKX0
  author: Steve Vine
  at: 2026-08-06T15:05:35.775945Z
  text: |-
    Built — PR #504 (branch feature/ise-589-mcp-assign-incident).

    `assign_incident` is registered (responder, session-required, write). The argument is optional, which is the whole point of the task: with nothing passed it assigns to the token's own user, because the pinned session already knows who "me" is and no lookup is needed. A name, an email, or "nobody" also work.

    Responder-tier as scoped, matching `update_incident_status` — picking work up is the desk's job. The test proves that from both sides: a responder token sees `assign_incident` in `tools/list` and still cannot see `commit_diagnosis`.

    It goes through `apply_assignee_change`, so everything the button does happens here too: claiming acknowledges the incident (ADR 0038 §3, so New → Active as you asked), a disabled user is refused, and the timeline names the assignee rather than carrying a bare id — that last one matters because a viewer reads the timeline but not the admin-gated user list, so it cannot resolve an id itself.

    One refactor worth flagging: the name-resolution rule was `_resolve_assignee`, private to issue-chat's ticket tool from ISE-561. Copying it would have left two answers to "which Steve did you mean?", so it is now `resolve_assignee` beside `apply_assignee_change`, raising `AssigneeUnresolved` and each surface rendering the refusal its own way — a chat reply there, a tool error here. `ticket_tools.py` behaviour is unchanged; its integration tests still pass untouched.

    A happy accident in testing: every dev-login user is named "Dev User", which made the ambiguity path trivially provable — asking for "Dev User" refuses and lists the candidates instead of picking one.

    Tests: ruff, mypy strict, 711 unit and the MCP + ticket-tool integration modules green.

    ISE Test Plan memo §3 checkbox lands in the batched memo edit with ISE-587 and ISE-590.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Found during ISE Test Plan execution (2026-08-06): "assign the incident to me" has no MCP path. The surface has `update_incident_status` (acknowledge/resolve/dismiss/close/reactivate) but no assignment tool, even though assignment is a first-class app capability (Active = "assigned to a person to deal with") and the session already knows exactly who "me" is — the pinned user.

Scope:
- Add `assign_incident` to the MCP registry: min_role responder (same tier as `update_incident_status`), needs_session, is_write. Default target is the session's own user ("assign to me" needs no lookup); optionally accept another user by name/email, resolved against ISE users, refusing ambiguity rather than guessing.
- Go through the same service path as the app's assignment (status transition to Active, timeline entry, any notification hooks) — no parallel logic.
- Recorded as `mcp_activity` (is_write) on the incident like the other writes.
- Integration tests alongside `test_mcp_actions.py`; add a checkbox to ISE Test Plan memo §3 (incident actions).

Done when: from a pinned session, "assign this incident to me" assigns and activates the incident, visible in the app with the assignee's name on the incident and the change on the timeline.