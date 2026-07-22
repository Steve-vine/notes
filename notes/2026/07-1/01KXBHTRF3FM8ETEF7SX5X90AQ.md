---
id: 01KXBHTRF3FM8ETEF7SX5X90AQ
created: 2026-07-12T16:16:11.235198904Z
updated: 2026-07-22T11:45:42.048186Z
type: task
title: UI — Approvals queue (the governance heart)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 51
sprint: sdcd2jr
blocked_by:
- 01KXBHSXM6Q078HBK00GJ5SGC4
assignee: steve
label: null
priority: high
task_status: done
---
Replace the Approvals PlaceholderPage (App.tsx:37-47); remove arrivesInPhase: 4 (nav.ts:26). NOTE: App.test.tsx:184 ("deferred sections still show their phase placeholder") currently asserts /approvals shows "Coming in Phase 4" — it MUST be repointed at /assist or it breaks.

ui-brief §4, the governance heart. Pending ProposedChanges with: target system, operation, EXACT PARAMETERS, tier badge, proposer (human, or agent + link to its AgentRun), rationale, expected effect, rollback note. Approve / Reject with a comment REQUIRED on reject. Self-proposed items visibly marked and BLOCKED from self-approval (the UI mirrors the state machine — the server is still the authority). History tab of past decisions.

Role-gate the nav item to approver+ (the nav is not role-gated today — nav.ts:14 notes this).

No colour work needed: statusColors.ts already maps T0-T3 (gray/blue/orange/red) and all six change statuses (proposed, awaiting_approval, approved, rejected, executed, failed).

Uses the ISE-48 API + generated types.