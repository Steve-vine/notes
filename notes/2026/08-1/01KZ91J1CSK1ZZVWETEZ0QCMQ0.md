---
id: 01KZ91J1CSK1ZZVWETEZ0QCMQ0
created: 2026-08-05T13:24:43.033633Z
updated: 2026-08-05T19:29:49.616642Z
type: task
title: 'Incident chat: tools for basic ticket actions (assign, acknowledge, resolve, severity)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 561
sprint: scb3vol
comments:
- id: 01KZ9AM8X2WG5CZ918R82BP9N3
  author: Steve Vine
  at: 2026-08-05T16:03:13.442743Z
  text: |-
    Built on feature/ise-561-chat-ticket-tools, PR #477 (targeting main), merged to staging.

    issue-chat gains three ticket tools — governed ISE-record writes in the commit_diagnosis pattern (ADR 0049), no approve/execute, estate untouched:

    - assign_incident: "me" resolves to the chatting operator (AgentDeps gains actor, set by stream_chat); accepts full/partial names or emails, narrates ambiguity with candidates; "nobody"/null unassigns; claiming acknowledges exactly like the button (ADR 0038 §3).
    - update_incident_status: acknowledged/resolved/dismissed/closed/reactivated through the same apply_status_change rule as the PATCH endpoint and MCP tier — VALID_TRANSITIONS, merged-child guard, resolve cascades, notification emits.
    - set_incident_severity: new apply_severity_change service in issues.py (validated against ISSUE_SEVERITIES, merged-child guard, audits both grades); tool description distinguishes it from the forward-looking signal downgrade.

    Assignee logic extracted to apply_assignee_change — one service path per operation shared by endpoint and tool (the apply_status_change/ADR 0055 §4 precedent), so guards can't drift. Every action audits against the issue and lands on the timeline (ISE-557's reader — but this branch is independent: issue mutations always audited issue-scoped). Timeline renders "Severity changed high → medium". Header refresh: the existing on-turn-completion invalidation of the issue query covers it. Prompt: act only on an explicit ask, confirm by name ("Assigned to Steve Vine").

    Authority: the conversation-turn POST is already operator-gated — the same tier the buttons require; tools act and audit as that operator and refuse politely when identity is absent. Boundary exit test extended: still nothing that approves or executes. No OpenAPI change (verified).

    Tests: new test_ticket_tools.py (10 tests: boundary, assign-to-me + ack + audit, partial name, unassign, unknown/ambiguous/disabled refusals, transition guards, severity audit, actor-less refusal); loop-tools/commit/registration/assignee/acknowledgement suites all green.
assignee: steve
priority: medium
task_status: done
---
Found during Sprint 50 incident-management testing: "Assign this incident to me" in incident chat → the AI correctly reports it has no tool for it; its actions are limited to reanalyse / diagnose / propose.

## Scope

Give issue-chat tools for ISE-internal ticket mutations — the same operations the page's buttons already offer an operator:

- assign / unassign (incl. "to me" — resolve from the chatting user)
- acknowledge / status transitions (incl. resolve, with the usual guards)
- set severity

These are ticket operations, not infrastructure writes — the ADR 0049/0050 boundary (infra changes only via proposed-change + tiered approval) is unchanged. Tools act as the chatting user, require the same operator role as the buttons, and each action is audited against the issue so it lands on the timeline (depends on/relates to ISE-557).

Confirm each action in the chat response ("Assigned to Steve Vine") and refresh the header state.