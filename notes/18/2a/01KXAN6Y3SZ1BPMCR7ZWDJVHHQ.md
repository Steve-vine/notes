---
id: 01KXAN6Y3SZ1BPMCR7ZWDJVHHQ
created: 2026-07-12T07:56:01.529336846Z
updated: 2026-07-12T07:56:01.529336846Z
type: task
title: UI — Agent runs list + transcript viewer
priority: medium
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 40
---
Replace the agent-runs PlaceholderPage with a live list + detail (ui-brief agent-run viewer). Remove arrivesInPhase from the Agent runs nav item. List: task_type, model, status pill (running/succeeded/failed/budget_exceeded — already coloured), system, tokens, cost, duration; per-screen polling. Detail: transcript viewer (Code block JSON, tool calls), outcome, cost/tokens/duration, links to produced Issue(s). Reuse IssueDetailPage / SystemDetailPage SlicePayload patterns + lib/systemStatus relativeTime. Uses the AgentRun read API + generated types.