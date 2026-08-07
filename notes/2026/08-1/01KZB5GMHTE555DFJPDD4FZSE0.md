---
id: 01KZB5GMHTE555DFJPDD4FZSE0
created: 2026-08-06T09:12:20.282811Z
updated: 2026-08-07T12:16:04.800775Z
type: task
title: Register propose_change on the MCP surface — operators can propose governed changes from Claude Code
project: 01KX671DATY39VW6GWK3M2T3DN
number: 584
sprint: sp337by
comments:
- id: 01KZBS3TX2SDCZYJ8X9QAQMDWW
  author: Steve Vine
  at: 2026-08-06T14:54:52.322768Z
  text: |-
    Built — PR #502 (branch feature/ise-584-mcp-propose-change).

    `propose_change` is registered on the MCP surface (operator, session-required, write). It calls `changes.create_proposal` — the same function the Approvals screen's own POST calls — so catalogue validation, parameter schemas, the protected-target guard (ADR 0021) and tier resolution cannot drift between the two surfaces. The integration is named by name (as `describe_resources` lists it) or by id; ambiguity refuses rather than guesses, because proposing against the wrong integration is proposing against the wrong estate.

    The proposal lands as an ordinary ProposedChange on the pinned incident, awaiting approval, with `via: claude` on its `proposed` audit line — `create_proposal` gained the `extra_details` kwarg `apply_status_change` already had, rather than growing a parallel provenance path. Separation of duties applies unchanged: proving that took the tidiest test in the batch — propose over MCP, be refused approving your own T2 over MCP, then have a second human approve it.

    Blurb reconciliation cut the other way for playbooks: the responder tier advertised desk-executable *runs* over MCP and no such tool has ever existed. Per your call, runs stay app-only and the blurb no longer claims it. Recorded as an amendment to ADR 0055 §4 along with the rule it leaves behind — `describe_resources` may only name capabilities that are registered, because the model reads it as a promise.

    Worth knowing: the protected-target guard caught the first version of the happy-path test, which tried to restart a Deployment in the `ise` namespace. It fires at proposal time, so an approver never spends attention on a change that could never have run. That refusal is now its own assertion.

    ISE Test Plan memo updated: the ⛔ ISE-584 markers are gone from every section, three propose_change checkboxes added to §3, and §15 reworded — playbook runs are a deliberate decision now, not a gap.

    Tests: ruff, mypy strict, 711 unit + 153 integration green locally. No new screen — the proposal surfaces on the Approvals screen that already exists.
assignee: steve
label: null
priority: medium
task_status: done
---
Found while writing the ISE Test Plan (2026-08-06): `propose_change` is in the MCP design brief (`docs/briefs/mcp-investigation-surface.md`) and is advertised in `describe_resources`' operator blurb (`mcp_server/tools_discover.py`), but it is **not registered** in `mcp_server/registry.py` — there is no way to enter the governed remediation path from Claude Code today; changes can only be reviewed/approved.

Scope:
- Register a `propose_change` MCP tool (min_role operator, needs_session, is_write) that goes through the same `resolve_action` path as the app — action-catalogue validation, tier resolution, protected-target guard (ADR 0021), connector guards (e.g. EntraID self-escalation, ADR 0064).
- Proposal lands as a normal `ProposedChange` on the pinned incident, visible on the Approvals screen, with provenance `via: claude` — separation of duties then applies (proposer cannot approve own T2/T3).
- Reconcile the `describe_resources` blurbs with reality: advertise `propose_change` truthfully now that it exists, and **de-advertise desk-executable playbook runs** from the responder-tier blurb (Steve-decided 2026-08-06) — playbook runs stay app-only; no MCP run capability in this task.
- Integration tests alongside the existing `test_mcp_actions.py` / `test_mcp_approvals.py` suites, incl. self-approval refusal of an MCP-proposed change.
- Update the ISE Test Plan memo: move the propose_change items out of "Not testable yet" into the governance section, and drop the playbook-runs gap line (no longer advertised = no longer a gap).

Done when: from a pinned Claude Code session an operator can propose a T1/T2 change, see it appear on the Approvals screen in the UI, and a second user can approve it there or over MCP; `describe_resources` no longer advertises anything unregistered.