---
id: 01KXGT5PTW8H1T36DE4XGN8DQV
created: 2026-07-14T17:18:10.780928188Z
updated: 2026-07-14T17:18:10.780928188Z
type: task
title: 'Candidate: Maker-checker approval workflow'
task_status: backlog
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 73
---
**Candidate — to be scoped/decided in M17 (not yet a committed brief).**

Add a **submit → review → approve** workflow for assessments and risk acceptances (segregation of duties / audit rigour). The assessor proposes a status/score or a risk acceptance; a different reviewer (admin/approver role) approves before it becomes authoritative. Considerations: a new approver role, state machine on assessment/risk-acceptance, who-can-approve-what (not your own work), and how it interacts with the M14 audit log. Possibly over-engineering for the current stage — **decide whether it's warranted** before committing.

---
*Migrated from Linear [DEV-502](https://linear.app/stevevine/issue/DEV-502/candidate-maker-checker-approval-workflow) · created 2026-06-19*