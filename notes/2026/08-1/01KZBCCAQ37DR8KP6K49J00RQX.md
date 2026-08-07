---
id: 01KZBCCAQ37DR8KP6K49J00RQX
created: 2026-08-06T11:12:19.171504Z
updated: 2026-08-07T09:40:57.060217Z
type: task
title: 'MCP: list_playbooks — enumerate the playbook library, not just applicability matches'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 590
sprint: sp337by
comments:
- id: 01KZBT28ABA66G5FXCE3FH8S7D
  author: Steve Vine
  at: 2026-08-06T15:11:29.099449Z
  text: |-
    Built — PR #505 (branch feature/ise-590-mcp-list-playbooks).

    `list_playbooks` and `get_playbook` are registered, both viewer-tier and session-free as scoped: browsing the library is neither engineering nor incident work, so it should not need a pin, and anyone who can read the Playbooks screen can read this. Filters are `live_only` and a substring over name/kind/applicability; truncation is declared against the true total.

    Three judgement calls worth your eye:

    **Status vocabulary.** The task asked for draft/live/retracted, but only two states are actually persisted — `desk_state` is `advisory` or `desk_executable`, and retracting flips it back to `advisory` rather than recording a third state. Rather than invent a status the database cannot support, a row carries `desk_state` plus a plain `live` boolean and `published_by`. That answers the real question ("may the desk run this, and who signed it off") without fiction.

    **Two standings, not one number.** Advisory and remediation playbooks are scored by different rules (ISE-303 — an advisory playbook references no catalogue operation, so the executed-op efficacy rule can never credit it). A row says "guided 3/4 investigations" or "fixed 3/4 incidents" accordingly. Collapsing them to one ratio would make an unjudged advisory look like a failed fix.

    **last-used is derived**, from the changes a playbook bound and the verdicts operators gave it, rather than adding a `last_used_at` column that could only ever be true from the day it shipped — the history is already in those two tables.

    Writing the test surfaced something you may want to know: a playbook drafted over MCP is always "advisory"-typed, because `draft_playbook` takes prose and an envelope but not the V1 `remediation_options` list that `is_advisory` keys off. So a published, desk-executable playbook can still read as advisory type. Not wrong — the two axes are genuinely independent — but if that reads oddly on the Playbooks screen too, it may be worth a follow-up task.

    Tests in `test_mcp_playbook_authoring.py`: enumeration from a viewer token with no pin, both standing vocabularies, desk-executability visible, both filters, declared truncation, the detail path's envelope summary, and a bad id refused. The responder-token test now also asserts `list_playbooks` IS visible to a responder — the one playbook tool that is not authoring.

    ruff, mypy strict, 711 unit and the module's 6 integration tests green.

    ISE Test Plan memo updated (batched with ISE-587 and ISE-589): §14 gained three checkboxes, §11 two for `recent_commits`, §3 two for `assign_incident`, and §15 no longer lists any of the four as gaps.
assignee: steve
label: null
priority: medium
task_status: done
---
Found during ISE Test Plan execution (2026-08-06): "list all playbooks" has no MCP path. `find_playbooks` is applicability-matched against the pinned incident (Recall's job), and the authoring tools only cover pending learnings and drafts — there is no way to enumerate the playbook library itself.

Scope:
- Add `list_playbooks` to the MCP registry: read-only, min_role viewer. Session-free like the other cross-incident playbook tools (`list_pending_learnings` etc.) — browsing the library is not incident work and should not require a pin.
- Returns the library shortlist: name, status (draft/live/retracted), maturity, applicability summary, efficacy/feedback standing, last-used — the fields an operator scans to decide what exists and what is trustworthy. Optional filters: status, free-text over name/applicability.
- Truncation-honest (shortlist + total count) per the retrieval contract; a `get`/detail path for one playbook if the list row is not enough (or fold detail into existing tools if one fits).
- Integration tests alongside `test_mcp_playbook_authoring.py`; add a checkbox to ISE Test Plan memo §14 (playbooks).

Done when: from any Claude Code conversation (no pinned incident), "list all playbooks" returns the library with status and efficacy visible, matching what the Playbooks screen shows.