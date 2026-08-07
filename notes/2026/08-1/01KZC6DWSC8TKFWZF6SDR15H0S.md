---
id: 01KZC6DWSC8TKFWZF6SDR15H0S
created: 2026-08-06T18:47:33.42098Z
updated: 2026-08-07T11:55:26.908742Z
type: task
title: 'Breakglass mode: trigger in Claude Code, arm in the app, time-boxed auto-approval (ADR 0089)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 592
sprint: snk16ew
blocked_by:
- 01KZC6DBRBH9CXTSQ4CQNZGRFN
- 01KZDRMEHA2BYH83X980Q42YTT
assignee: steve
priority: medium
task_status: backlog
---
Implement ADR 0089 (draft, `docs/decisions/0089-breakglass-mode.md`). Design finalised with Steve 2026-08-06. Principle: **bypass the waiting, never the machinery** — everything still flows propose → approve → execute; an armed window auto-satisfies the approval gate, stamped `approved_via: breakglass`. Access-parity rationale: holders already have direct access; ISE being fastest keeps the emergency inside the audit trail.

Flow:
- `break_glass` MCP tool (session-required, breakglass grant required) creates a **pending** request on the pinned incident; unapproved requests expire after 10 min; reply directs the engineer to the incident in the app.
- **Arm in the ISE app** on that incident: modal requires reason + duration (max 120 min). Self-approval deliberate — the SSO'd app session is the step-up; an MCP token alone can request but never arm.
- Armed: T0–T2 auto-approve silently; **T3 restates its target and requires confirm-back**; protected-target guard (ADR 0021) **lifts** (crossing it is stamped); **EntraID self-escalation guard never lifts** (ADR 0064, fails closed); action catalogue still the wall — no new capability.
- Ends on first of: timer expiry, manual disarm (Claude Code or app), **incident resolved**, or session superseded (window rides the pinned session; per-user, per-incident — a second engineer queues normally).

Record (the audit trail is the product — no mandatory post-hoc review, Steve-decided):
- Timeline event + Platform Log row on every armed/disarmed/expired transition.
- Teams **System event** notifications on arm and end (dependency: ISE-591).
- Every action an ordinary ProposedChange row distinguished by `approved_via: breakglass`.

UI (pane-of-glass rule):
- Incident screen: pending-request approval modal + armed banner with countdown.
- Claude Code statusline (`GET /mcp/session`): armed state + remaining minutes.
- Breakglass grant: per-user, out-of-band assignment (role editing stays unbuilt).

Tests: arming ceremony (MCP-only cannot arm), tier behaviour incl. T3 confirm-back, guard matrix (protected lifts / self-escalation refuses), all four end conditions, stamps on every record. Likely a sprint's worth of slices — split when planned.

Depends on: ISE-591 (Teams System event), `propose_change` (released). Finalise ADR 0089 to Accepted with the implementation.