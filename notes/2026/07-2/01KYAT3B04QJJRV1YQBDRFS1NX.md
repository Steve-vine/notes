---
id: 01KYAT3B04QJJRV1YQBDRFS1NX
created: 2026-07-24T19:37:08.356238Z
updated: 2026-07-24T20:54:23.576244Z
type: task
title: Map the AI interaction workflow end-to-end
project: 01KX671DATY39VW6GWK3M2T3DN
number: 263
sprint: svgrad3
assignee: steve
priority: medium
task_status: backlog
---
The sprint's first deliverable, and the input to everything else: a complete map of how every AI interaction actually works today. For each surface — analyse-issue, diagnose, propose-remediation, execution-followup, summarise-state, assist, issue-chat, summarise-document, extract-document-claims:

- **Context assembled**: what goes into the prompt (investigation context / blast radius traversal, entity annotations, playbooks/memory recall, history replay, document summaries), from where in the code, and roughly how many tokens each part contributes.
- **Tools available**: which tools the agent may call (connector evidence, DB lookups, loop tools), and which surfaces get which — including what chat surfaces *cannot* reach.
- **Caps applied**: token/iteration/spend caps per surface and where enforced.
- **Trigger + write path**: what starts it, what it may write.

Deliverable: a document in the repo (docs/briefs/ or similar) with one diagram per surface — the workflow is complex enough that Steve has asked for it mapped, not described. This map is what the audit (token spend) and limitations-review tasks work from, and what the sprint's tuning decisions get made against.