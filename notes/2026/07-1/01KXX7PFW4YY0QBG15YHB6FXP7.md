---
id: 01KXX7PFW4YY0QBG15YHB6FXP7
created: 2026-07-19T13:05:25.38060748Z
updated: 2026-07-19T23:28:31.743743556Z
type: task
title: Evidence-on-demand in investigation
project: 01KX671DATY39VW6GWK3M2T3DN
number: 149
task_status: review
blocked_by:
- 01KXX7PAG43P7R1H57ZYS5R2EQ
assignee: steve
label:
- feature
priority: medium
sprint: sehghhk
---
**Sprint 15 (vertical slice: backend + UI).** Let the investigator pull Evidence from any Evidence-capable integration — the read path the whole contract exists for.

- **Backend**: wire the **Evidence** capability into the investigation path (diagnose / issue-chat tools) so the AI can pull logs/metrics/resource state on demand from any Evidence-capable integration, directed by the estate traversal (ISE-129). Bounded/cited like every other tool.
- **UI**: Evidence pulls appear in the **incident conversation / agent-run trace** ("pulled logs from MCP source X"), one click from the conclusion (the evidence-is-one-click UI principle).

**DoD**: during an incident, the investigator pulls Evidence from an MCP integration and it shows in the timeline/agent-run trace, cited. Not done until the pull is visible and clickable in the conversation.

Depends on the generic MCP Evidence Type.