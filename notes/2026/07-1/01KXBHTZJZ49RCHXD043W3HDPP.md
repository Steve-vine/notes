---
id: 01KXBHTZJZ49RCHXD043W3HDPP
created: 2026-07-12T16:16:18.527836242Z
updated: 2026-07-19T13:25:17.522549861Z
type: task
title: UI — proposal flow from Issues + execution results
priority: medium
task_status: done
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 52
blocked_by:
- 01KXBHT6V41A6SQTJ1DQVPVGS0
- 01KXBHTFPBS03TV3ZQPNWCVBJ4
- 01KXBHTRF3FM8ETEF7SX5X90AQ
label: null
sprint: sdcd2jr
---
Close the loop in the UI.

- Issue detail: role-gated "Propose remediation" button (runs the ISE-50 drafting agent — same shape as the ISE-41 Diagnose button), plus the issue's linked ProposedChanges with their status.
- Tier badges wherever a change appears.
- Execution result + the `before` snapshot on the change detail (what it did, and what it would take to undo).
- Overview: pending-approvals count on the system cards and the estate strip (ui-brief §1 — "pending approvals count" is specified there and has never been built).
- Audit UI: colours for the new action verbs proposed / approved / rejected / executed (statusColors.ts:46-50 currently covers only created/updated/deleted/break_glass_login). The ProposedChange status colours already exist and should be reused.

Needs ISE-49 (executor, for results), ISE-50 (the agent), ISE-51 (the approvals screen to link into).