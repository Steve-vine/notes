---
id: 01M8GQ2WCN09QTDT2BW00J7A0H
created: 2026-11-28T09:16:52.501109Z
updated: 2026-11-28T12:09:18.364486Z
type: task
title: 'A sealed-off runner for PowerShell and Python generators: one container per run, no network, no credentials, only the run''s input values in'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2230
sprint: s09wwd3
assignee: steve
label:
- feature
priority: high
task_status: active
---
**On the chain.** After the Scripting phase 2 ADR (COM-2225). **A condition of adding either language** (ADR 0185 §9).

## What people see
- Nothing new on screen. A PowerShell or Python script runs **in Compass**, in a container of its own, started for that run and thrown away after it:
  - **Only that run's input values go in.** No credential, none of Compass's secrets, no access to its database.
  - **No network at all.** A generator works out what to send; Compass sends it (see the PowerShell and Python tasks).
  - It has the script's time limit and a memory and CPU limit. At the limit it's stopped, and the run reads Timed out.
  - **What comes out** is read back and recorded on the run: either values, or a request (a SQL command with parameters, or an API call) for Compass to send. Anything it writes as an error is kept on the run as the reason it failed. Nothing else is kept.
- Run now, Retry, workflows and the run history work exactly as for SQL scripts.
- System status shows whether the runner is available. If it isn't, a run fails saying so, with its Action and an Alert in the Event log.

## Notes (technical)
- A Kubernetes Job (or a warm runner pod handed one run at a time):
  - a NetworkPolicy denying all egress;
  - no service account token;
  - a read-only root filesystem, non-root, all capabilities dropped;
  - inputs passed as a mounted file, never environment variables (they leak into process listings).
- Images: pinned pwsh and Python images built by CI, with no `latest` (ADR 0008) and a fixed set of libraries.

**Done when:** on staging, a test script shows it can read its inputs and hand back values, can't reach any address (Compass, the cluster or the internet), finds no secret, and is stopped at its time limit.