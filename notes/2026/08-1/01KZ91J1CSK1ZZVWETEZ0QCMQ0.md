---
id: 01KZ91J1CSK1ZZVWETEZ0QCMQ0
created: 2026-08-05T13:24:43.033633Z
updated: 2026-08-05T15:29:36.991806Z
type: task
title: 'Incident chat: tools for basic ticket actions (assign, acknowledge, resolve, severity)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 561
sprint: scb3vol
assignee: steve
priority: medium
task_status: todo
---
Found during Sprint 50 incident-management testing: "Assign this incident to me" in incident chat → the AI correctly reports it has no tool for it; its actions are limited to reanalyse / diagnose / propose.

## Scope

Give issue-chat tools for ISE-internal ticket mutations — the same operations the page's buttons already offer an operator:

- assign / unassign (incl. "to me" — resolve from the chatting user)
- acknowledge / status transitions (incl. resolve, with the usual guards)
- set severity

These are ticket operations, not infrastructure writes — the ADR 0049/0050 boundary (infra changes only via proposed-change + tiered approval) is unchanged. Tools act as the chatting user, require the same operator role as the buttons, and each action is audited against the issue so it lands on the timeline (depends on/relates to ISE-557).

Confirm each action in the chat response ("Assigned to Steve Vine") and refresh the header state.