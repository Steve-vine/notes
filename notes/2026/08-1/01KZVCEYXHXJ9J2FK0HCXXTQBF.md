---
id: 01KZVCEYXHXJ9J2FK0HCXXTQBF
created: 2026-08-12T16:21:36.305898Z
updated: 2026-08-12T16:22:35.830468Z
type: task
title: Workflow and WorkflowStep data model + CRUD API
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 151
sprint: sv5cbvq
assignee: steve
imported_from: linear
label: null
priority: null
task_status: done
---
New `Workflow` and `WorkflowStep` tables, project-scoped. Step types: Selector and Scan (Report/Alert/branching schema-reserved per ADR 020, not exposed). CRUD endpoints with validation: ≥1 Selector, all Selectors before any Scan.

---

Imported from Linear [DEV-179](https://linear.app/stevevine/issue/DEV-179/workflow-and-workflowstep-data-model-crud-api)