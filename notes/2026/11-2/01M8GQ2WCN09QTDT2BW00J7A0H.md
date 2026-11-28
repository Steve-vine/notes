---
id: 01M8GQ2WCN09QTDT2BW00J7A0H
created: 2026-11-28T09:16:52.501109Z
updated: 2026-11-28T09:16:52.501109Z
type: task
title: 'A sealed-off runner for PowerShell and Python scripts: one container per run, holding only its inputs and its one integration''s credential'
task_status: todo
assignee: steve
priority: high
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2230
---
**On the chain.** After the Scripting phase 2 ADR. **A condition of adding either language** (ADR 0185 §9): no PowerShell or Python script runs until this exists.

## What people see
- Nothing new on screen. Running a PowerShell or Python script (their own tasks) happens in a container of its own, started for that run and thrown away after it:
  - It holds **only** that run's input values and the one integration's credential. Never Compass's other secrets, its database, or its network.
  - It can reach **only** its integration's address (approved like any other). Everything else is blocked.
  - It has the script's time limit, and a memory and CPU limit. At the limit it's stopped, and the run reads Timed out.
  - Its output (the values handed back) and anything it writes as errors are read back and recorded on the run, as for a SQL script. Nothing else it writes is kept.
- **Run now, Retry, workflows and the run history** work exactly as for SQL scripts.
- An administrator can see on System status whether the runner is available. If it isn't, a run fails saying so, with its Action.

## Notes (technical)
- Kubernetes Job (or a dedicated runner pod) per run with a NetworkPolicy allowing only the integration's host and port, no service account token, a read-only root filesystem, non-root and dropped capabilities. The credential arrives as a short-lived secret mounted for that Job and deleted with it. The ADR settles the exact mechanism.
- Images: pinned PowerShell (pwsh) and Python images built by CI, no `latest` (ADR 0008).

**Done when:** on staging, a test script proves it can reach its integration, can't reach Compass's database, the cluster or the internet, sees no secret but its own, and is stopped at its time limit.