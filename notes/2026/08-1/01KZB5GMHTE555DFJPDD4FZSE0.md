---
id: 01KZB5GMHTE555DFJPDD4FZSE0
created: 2026-08-06T09:12:20.282811Z
updated: 2026-08-06T09:19:14.924028Z
type: task
title: Register propose_change on the MCP surface — operators can propose governed changes from Claude Code
project: 01KX671DATY39VW6GWK3M2T3DN
number: 584
sprint: sp337by
assignee: steve
priority: medium
task_status: backlog
---
Found while writing the ISE Test Plan (2026-08-06): `propose_change` is in the MCP design brief (`docs/briefs/mcp-investigation-surface.md`) and is advertised in `describe_resources`' operator blurb (`mcp_server/tools_discover.py`), but it is **not registered** in `mcp_server/registry.py` — there is no way to enter the governed remediation path from Claude Code today; changes can only be reviewed/approved.

Scope:
- Register a `propose_change` MCP tool (min_role operator, needs_session, is_write) that goes through the same `resolve_action` path as the app — action-catalogue validation, tier resolution, protected-target guard (ADR 0021), connector guards (e.g. EntraID self-escalation, ADR 0064).
- Proposal lands as a normal `ProposedChange` on the pinned incident, visible on the Approvals screen, with provenance `via: claude` — separation of duties then applies (proposer cannot approve own T2/T3).
- Reconcile the `describe_resources` blurbs with reality: advertise `propose_change` truthfully now that it exists, and **de-advertise desk-executable playbook runs** from the responder-tier blurb (Steve-decided 2026-08-06) — playbook runs stay app-only; no MCP run capability in this task.
- Integration tests alongside the existing `test_mcp_actions.py` / `test_mcp_approvals.py` suites, incl. self-approval refusal of an MCP-proposed change.
- Update the ISE Test Plan memo: move the propose_change items out of "Not testable yet" into the governance section, and drop the playbook-runs gap line (no longer advertised = no longer a gap).

Done when: from a pinned Claude Code session an operator can propose a T1/T2 change, see it appear on the Approvals screen in the UI, and a second user can approve it there or over MCP; `describe_resources` no longer advertises anything unregistered.