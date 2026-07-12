---
id: 01KXAN71BBPTMMVGD9BNTCDSWB
created: 2026-07-12T07:56:04.843339466Z
updated: 2026-07-12T07:56:04.843339466Z
type: task
title: UI — AI on Overview, System detail & Issues
priority: medium
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 41
---
Surface AI across the existing screens (ui-brief). summarise-state summary line on the Overview SystemCard + an AI-summary panel on System detail. Role-gated 'Run analysis' (System detail) and 'Diagnose' (Issue detail) buttons — TriggerSyncButton mutation shape, operator-gated. AI-created Issues show source='ai' (add STATUS_COLORS entry + refine the 2-way source label into a 3-way map) with an evidence link to their originating agent run (agent_run_id) in the Issues queue + Issue-detail evidence panel. Uses the AgentRun read API + generated types.