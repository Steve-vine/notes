---
id: 01KYHPWATHHAJK3R17BVTFJXMD
created: 2026-07-27T11:55:34.097121Z
updated: 2026-08-05T19:02:19.774255Z
type: task
title: 'Approvals in Claude: list, inspect, approve/reject — recorded in ISE'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 336
sprint: sax9eff
assignee: steve
label: null
priority: medium
task_status: done
---
Steve must-have #5: if the user has permission, approvals are surfaced in Claude and recorded in ISE.

- `list_pending_approvals` — role-filtered; scoped to the pinned incident by default, with an all-incidents variant for "anything waiting on me?". Pending approvals also appear in the session-start cues block.
- `get_proposed_change` — the full picture a human needs to judge: action, target, tier, diff/parameters, proposer, provenance (which run/conversation proposed it).
- `approve_change` / `reject_change` (with reason) — **identical rules to the Approvals screen**: tier limits, self-approval restrictions (the Sprint-4 lesson: server rules, not UI-side guesses), role checks. The MCP layer calls the same service path so the two surfaces can never drift.
- Every decision recorded in the ISE audit trail + incident timeline with the "via Claude" provenance marker; execution of an approved change stays in ISE exactly as today.
- Prompt-side: cue text has Claude present an approval as a decision with the evidence summarised, never as a rubber stamp — and T3-tier items should nudge toward reviewing in the UI (link in the tool result).

Vertical DoD: a proposed change on a staging incident is listed, inspected, and approved from a pinned Claude session by an operator — and rejected with 403 for a viewer token — with both attempts visible in the ISE audit trail.