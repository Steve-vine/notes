---
id: 01KZBCCAQ37DR8KP6K49J00RQX
created: 2026-08-06T11:12:19.171504Z
updated: 2026-08-06T11:12:19.171504Z
type: task
title: 'MCP: list_playbooks — enumerate the playbook library, not just applicability matches'
label: improvement
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 590
---
Found during ISE Test Plan execution (2026-08-06): "list all playbooks" has no MCP path. `find_playbooks` is applicability-matched against the pinned incident (Recall's job), and the authoring tools only cover pending learnings and drafts — there is no way to enumerate the playbook library itself.

Scope:
- Add `list_playbooks` to the MCP registry: read-only, min_role viewer. Session-free like the other cross-incident playbook tools (`list_pending_learnings` etc.) — browsing the library is not incident work and should not require a pin.
- Returns the library shortlist: name, status (draft/live/retracted), maturity, applicability summary, efficacy/feedback standing, last-used — the fields an operator scans to decide what exists and what is trustworthy. Optional filters: status, free-text over name/applicability.
- Truncation-honest (shortlist + total count) per the retrieval contract; a `get`/detail path for one playbook if the list row is not enough (or fold detail into existing tools if one fits).
- Integration tests alongside `test_mcp_playbook_authoring.py`; add a checkbox to ISE Test Plan memo §14 (playbooks).

Done when: from any Claude Code conversation (no pinned incident), "list all playbooks" returns the library with status and efficacy visible, matching what the Playbooks screen shows.