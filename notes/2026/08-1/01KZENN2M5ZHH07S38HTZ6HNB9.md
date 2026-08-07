---
id: 01KZENN2M5ZHH07S38HTZ6HNB9
created: 2026-08-07T17:52:06.277843Z
updated: 2026-08-07T17:59:32.624195Z
type: task
title: 'Breakglass slice 2: auto-approval inside an armed window — tiers and guards (ADR 0089)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 612
sprint: snk16ew
assignee: steve
priority: medium
task_status: backlog
---
Slice 2 of 4 of the breakglass build (split from ISE-592, which now carries slice 1: the window lifecycle, table and grant).

Make an armed window actually pre-satisfy the approval gate. **Bypass the waiting, never the machinery** — every action still flows propose → approve → execute through the action catalogue, schema validation, tier resolution and the governed executor.

- In `changes.propose()`, when an armed window covers (proposer, incident), approve instead of routing to `awaiting_approval`. Stamp `approved_via: breakglass` on the ProposedChange and in the audit line.
- **T0–T2** auto-approve silently.
- **T3** auto-approves only after the proposal restates its target and the engineer confirms it back — friction, not prohibition. An irreversible action gets one deliberate look, not a queue. (Needs a confirm-back state on the change or the MCP tool; decide which when built.)
- **Protected targets (ADR 0021) LIFT** inside the window — the protected resource may be exactly what is down. The refusal becomes a stamp: the record shows the guard was crossed under breakglass.
- **The EntraID self-escalation guard (ADR 0064) NEVER lifts.** It protects ISE's own control plane, not the estate; a compromised breakglass is precisely the attack it exists for. Fails closed, breakglass included.
- No new capability appears — the action catalogue is still the wall.

Tests: the tier matrix, the guard matrix (protected lifts / self-escalation refuses), the stamp on every record, and that a proposal from someone WITHOUT a window on the same incident still queues normally.

Depends on ISE-592 (slice 1).