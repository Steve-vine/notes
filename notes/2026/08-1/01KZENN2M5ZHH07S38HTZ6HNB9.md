---
id: 01KZENN2M5ZHH07S38HTZ6HNB9
created: 2026-08-07T17:52:06.277843Z
updated: 2026-08-13T19:00:13.722507Z
type: task
title: 'Breakglass slice 2: auto-approval inside an armed window — tiers and guards (ADR 0089)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 612
sprint: snk16ew
comments:
- id: 01KZF36FPRX2S9359FJPG1X3JT
  author: Steve Vine
  at: 2026-08-07T21:48:48.216862Z
  text: |-
    Built and merged to main — PR #531 (all checks green), migration 0107.

    What an armed window now does, and nothing else: the approval gate is pre-satisfied instead of queued, and the protected-target guard lifts for the change's own targets.

    TIER MATRIX
    - T0-T2 approve on proposal, silently, stamped approved_via: breakglass.
    - T3 lands awaiting_approval with breakglass_confirm_required in its trail; a new MCP tool confirm_change(change, target) spends the window on it. The confirm-back went on the tool rather than on the change, so the state machine gained no new status and no change can be half-approved. The target that was typed is on the approval line.
    - Refused at the moment of the transition, not when the caller looked the window up: somebody else's window, another incident's window, an expired one, a disarmed one (the playbook-preapproval pattern).

    GUARDS
    - Protected targets LIFT, scoped: the executor re-derives this change's targets from the live catalogue's target_fields and removes only those, so any other protected name in the same parameters still refuses. Lifted at proposal time AND inside act() — the guard runs twice, and lifting it once would have left the change approved and unrunnable, which is the worst outcome available (the record says it happened and nothing did).
    - The EntraID self-escalation guard does NOT lift. Asserted rather than assumed: the test drives it with the exact policy a breakglass execution produces (deny-list emptied) and it still refuses, because the guard is structural rather than policy-driven.
    - No new capability: unknown operation still refused, disabled integration still not written to.

    DESIGN CHOICE WORTH RECORDING — the window is PASSED INTO create_proposal, never looked up inside it. Only the MCP surface resolves one, so the AI remediation loop, the playbook runner and the app's own POST cannot acquire auto-approval by accident. (Looking it up inside would also have crashed playbook runs: create_proposal would return `approved`, and playbook_preapprove would then attempt approved→approved.)

    approved_via + breakglass_window_id are COLUMNS, not audit JSON — the executor reads the stamp, and "everything approved under breakglass" has to be a query somebody can run. The Approvals screen shows a red `breakglass` badge, displacing `self-approved`: same person as proposer and decider on both, but one is a process shortcut and the other a declared emergency.

    23 new integration tests; ADR 0089's Implementation status updated.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
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