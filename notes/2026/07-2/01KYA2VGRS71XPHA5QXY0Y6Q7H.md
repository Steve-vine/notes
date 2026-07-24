---
id: 01KYA2VGRS71XPHA5QXY0Y6Q7H
created: 2026-07-24T12:50:54.873356Z
updated: 2026-07-24T12:51:14.664449Z
type: task
title: 'AI spend: Incident Spend panel — running cost per incident'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 252
sprint: sthz8ne
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
New panel at the bottom of the AI tab: **Incident Spend** — every incident, most recently active first, with its cumulative AI cost. Columns per row: ID (`I<number>`), Severity, Title, Status, Assignee, Running cost.

Data: incidents are the `Issue` model. `AgentRun.issue_id` (FK + `ix_agent_run_issue` index) already links runs to incidents — running cost is `SUM(agent_run.cost_usd) GROUP BY issue_id`. Implementation notes:

- **Last-active ordering**: `Issue` has no `last_active` column — order by something like `GREATEST(issue.updated_at, MAX(agent_run.started_at))`.
- **Verify issue-chat runs carry `issue_id`** — the AgentRun docstring lists diagnose / analyse-issue / propose-remediation / execution-followup as issue-scoped; issue-chat spend must be included in the per-incident total or the biggest interactive cost driver goes missing.
- Include merged children's cost under the master, or show both — decide with the master/child incident model (Sprint 16) in mind.
- Paginate or cap (e.g. top 50 by recency) — incident count grows unboundedly.

Acceptance: an operator can see which incidents are consuming AI budget and how much each investigation has cost so far.