---
id: 01KYW7S951E2EG7SQK6RBQNDZ6
created: 2026-07-31T14:03:24.19352Z
updated: 2026-08-05T12:34:07.19932Z
type: task
title: Notification emit points — incident lifecycle, action pending, integration broken
project: 01KX671DATY39VW6GWK3M2T3DN
number: 421
order: 1.0
sprint: s7qg63g
blocked_by:
- 01KYW7S336M90G37F936T5B612
label: null
task_status: done
---
Wire the five v1 events to the delivery layer. Emit = write the `notification_delivery` row(s) in the SAME transaction as the triggering change, then enqueue after commit.

- Incident opened: `promotion.promote_findings()` / `_new_issue()` (auto) + `issues.create_issue()` (manual), subject to channel min_severity.
- Incident escalated: `promotion._escalate()`.
- Incident resolved/closed: `issues.apply_status_change()` PLUS the two bypass paths the survey flagged — AI auto-resolve (`ai/verify.py:68`) and silence-cascade resolve (`severity_api.py:316`). All three must emit or recoveries silently go missing.
- Action awaiting approval: ProposedChange enters pending (nudges approvers into ISE).
- Integration broken: a System's sync health transitioning to failing — EDGE-triggered on the transition (not every failed sync), consider a recovered notice on the way back.
- Channel matching: enabled + event toggle + min_severity for incident events; severity-less events (action pending, integration broken) are toggle-only.