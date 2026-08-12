---
id: 01KZVASY8Y9XM0RSFFZTC3RM3M
created: 2026-08-12T15:52:38.942039Z
updated: 2026-08-12T15:53:43.092584Z
type: task
title: 'Idea: K8s watch API for Job completion vs active-poll'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 62
sprint: svz96jc
assignee: steve
imported_from: linear
label:
- tech_debt
priority: low
task_status: backlog
---
Only if poll cost becomes meaningful at scale. Today the active-poll loop is fine; watch would reduce API server load when scan concurrency goes up.

Source: Obsidian To Do § Ideas / Parking Lot.

---

Imported from Linear [DEV-81](https://linear.app/stevevine/issue/DEV-81/idea-k8s-watch-api-for-job-completion-vs-active-poll)