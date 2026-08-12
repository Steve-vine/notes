---
id: 01KZVE8TAKMF1EYQXND0CNRZ8M
created: 2026-08-12T16:53:12.147083Z
updated: 2026-08-12T16:53:12.147083Z
type: task
title: Long workflow runs exceed the broker visibility timeout → task redelivered and runs concurrently, failing
task_status: done
imported_from: linear
assignee: steve
label: bug
priority: high
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 218
---
Found diagnosing the `vul-scan` run `91b7f09c` (Vulnerability Scanner "failure").

### What happens

The entire workflow runs as **one long Celery task** (`dispatch_workflow_run`). This run took **8,600 s total**, which exceeds the **Valkey broker visibility timeout (\~3,600 s, the Celery default — not overridden anywhere)**. Once a task outlives that window the broker assumes the worker died and **redelivers it**, so it runs **concurrently on m…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-564](https://linear.app/stevevine/issue/DEV-564/long-workflow-runs-exceed-the-broker-visibility-timeout-task)