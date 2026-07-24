---
id: 01KYA2VGRS71XPHA5QXY0Y6Q7H
created: 2026-07-24T12:50:54.873356Z
updated: 2026-07-24T14:48:47.131775Z
type: task
title: 'AI spend: Incident Spend panel — running cost per incident'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 252
sprint: sthz8ne
comments:
- id: 01KYA8A726VEY4WKR5ECNXTDQ1
  author: Steve Vine
  at: 2026-07-24T14:26:19.334643Z
  text: |-
    Done — PR #235 (feature/ise-252-incident-spend → main), stacked on 247→249→250→251.

    Verified the issue-chat attribution concern — and it was a real leak: `_open_turn` (ai/chat.py) built the AgentRun WITHOUT issue_id/system_id, even though both were already computed for the deps. So every issue-chat run carried a NULL issue_id and the per-incident total would have silently dropped the biggest interactive cost driver. Fixed: both are now set on the run (None for assist, which is estate-wide). Go-forward only — existing NULL-issue_id runs can't be reliably backfilled.

    Endpoint GET /ai-config/incident-spend: SUM(cost_usd) GROUP BY issue_id, ordered by GREATEST(issue.updated_at, MAX(run.started_at)) desc, capped at the 50 most recently active (incident count is unbounded — the cap is surfaced in the UI copy). Assignee resolved server-side.

    Master/child decision: each run counts once against the incident it actually ran for, so children appear in their own right — nothing double-counted, and no merged-away investigation's cost is hidden. (Chose "show both" over rolling children into the master, since hiding a child's real spend defeats the panel's purpose.)

    UI: IncidentSpendCard — ID (IN-nnnn, linked) / Severity / Title / Status / Assignee / Running cost — at the bottom of the admin AI tab, using the same issueId/StatusPill/incidentStatusLabel helpers as the Issues list.

    Tests: incident-spend endpoint (diagnose + issue-chat both counted), issue-conversation now asserts run.issue_id is set, App test asserts the panel renders. Backend + 393 vitest green; build/prettier/eslint clean.
assignee: steve
priority: medium
task_status: review
---
New panel at the bottom of the AI tab: **Incident Spend** — every incident, most recently active first, with its cumulative AI cost. Columns per row: ID (`I<number>`), Severity, Title, Status, Assignee, Running cost.

Data: incidents are the `Issue` model. `AgentRun.issue_id` (FK + `ix_agent_run_issue` index) already links runs to incidents — running cost is `SUM(agent_run.cost_usd) GROUP BY issue_id`. Implementation notes:

- **Last-active ordering**: `Issue` has no `last_active` column — order by something like `GREATEST(issue.updated_at, MAX(agent_run.started_at))`.
- **Verify issue-chat runs carry `issue_id`** — the AgentRun docstring lists diagnose / analyse-issue / propose-remediation / execution-followup as issue-scoped; issue-chat spend must be included in the per-incident total or the biggest interactive cost driver goes missing.
- Include merged children's cost under the master, or show both — decide with the master/child incident model (Sprint 16) in mind.
- Paginate or cap (e.g. top 50 by recency) — incident count grows unboundedly.

Acceptance: an operator can see which incidents are consuming AI budget and how much each investigation has cost so far.