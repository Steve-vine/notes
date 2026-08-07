---
id: 01KZDRMEHA2BYH83X980Q42YTT
created: 2026-08-07T09:24:57.002422Z
updated: 2026-08-07T10:57:38.992247Z
type: task
title: Verify the MCP gated-write path end to end — propose, approve, execute
project: 01KX671DATY39VW6GWK3M2T3DN
number: 598
sprint: snk16ew
assignee: steve
label: null
priority: medium
task_status: backlog
---
The Role Matrix's Claude Code row claims full Incident-Screen parity on gated writes. Prove it rather than assume it (matrix invariant "MCP completeness").

- Walk propose → approve → execute over the MCP surface against staging: `propose_change` with a real T1/T2 action, approval (in-app or MCP if registered), execution, audit rows.
- Check tier behaviour: T0/policy-T1 auto-apply; T2/T3 queue; separation-of-duties enforced with the token identity as proposer.
- Any gap (missing tool, wrong min_role, approval not reachable, execution not observable from Claude Code) becomes a fix within this task if small, or a spawned task if not.
- Extend the ISE Test Plan memo's checkboxes with this path.

Precedes breakglass (ISE-592) — breakglass auto-satisfies exactly this gate, so the gate must demonstrably work first.