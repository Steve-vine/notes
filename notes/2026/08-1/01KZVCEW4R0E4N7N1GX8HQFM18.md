---
id: 01KZVCEW4R0E4N7N1GX8HQFM18
created: 2026-08-12T16:21:33.464024Z
updated: 2026-08-12T16:22:33.414881Z
type: task
title: WorkflowRun execution — port Brief 011 dispatcher to the new model
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 150
sprint: sv5cbvq
assignee: steve
imported_from: linear
label: null
priority: null
task_status: done
---
Port Brief 011's chained-scan dispatcher into the Workflow model. Each Step dispatches a K8s Job per ADR 011, NDJSON ingest per ADR 014, chained rollup per Brief 016. Preserve the Brief 016 single-writer cancellation contract.

---

Imported from Linear [DEV-180](https://linear.app/stevevine/issue/DEV-180/workflowrun-execution-port-brief-011-dispatcher-to-the-new-model)