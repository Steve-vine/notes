---
id: 01KXAN6Y3SZ1BPMCR7ZWDJVHHQ
created: 2026-07-12T07:56:01.529336846Z
updated: 2026-07-14T19:31:42.189334567Z
type: task
title: UI — Agent runs list + transcript viewer
priority: medium
task_status: done
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 40
blocked_by:
- 01KXAN6SH66338KMEH39WG35K8
comments:
- id: 01KXB2V12FFWVEGETS0P4F0554
  author: Steve Vine
  at: 2026-07-12T11:54:11.407840377Z
  text: 'Development complete on feature/ise-040-agent-runs-ui. PR #37: https://github.com/Steve-vine/ise/pull/37. Replaces the agent-runs placeholder with the live viewer — makes Phase 3''s AI runs visible. AgentRunsPage: filterable table (system/task_type/status) — task→detail, status pill, system, model, tokens, cost, duration, when; per-screen polling. AgentRunDetailPage (/agent-runs/:id): run meta (provider/model/tokens/cost/duration + system link) + Outcome and Transcript JSON panels (the redacted why-did-the-AI-say-that record). Nav item live; routes replace PlaceholderPage; duration/cost formatters in lib/format. Uses the ISE-39 read API + generated types; run-status pills already coloured. Frontend-only — backend job correctly skipped. Tests: tsc/eslint/prettier clean, 26 vitest (2 new — list model/cost/status, detail outcome+transcript). PR CI green. Merged to staging (27cd688); deploy-staging fully GREEN incl. smoke check. REAL DATA to smoke test: staging has been running summarise-state (every 15min) + analyse (every 30min) since ISE-36/37, so the Agent runs list will show real runs (summaries + the analyse runs behind the 8 AI issues) with real transcripts/costs. Awaiting UI smoke test + merge clearance.'
sprint: syv1q8m
label: null
---
Replace the agent-runs PlaceholderPage with a live list + detail (ui-brief agent-run viewer). Remove arrivesInPhase from the Agent runs nav item. List: task_type, model, status pill (running/succeeded/failed/budget_exceeded — already coloured), system, tokens, cost, duration; per-screen polling. Detail: transcript viewer (Code block JSON, tool calls), outcome, cost/tokens/duration, links to produced Issue(s). Reuse IssueDetailPage / SystemDetailPage SlicePayload patterns + lib/systemStatus relativeTime. Uses the AgentRun read API + generated types.