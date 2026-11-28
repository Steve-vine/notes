---
id: 01M8GQ2WCN09QTDT2BW00J7A0H
created: 2026-11-28T09:16:52.501109Z
updated: 2026-11-28T14:03:38.615645Z
type: task
title: 'A sealed-off runner for PowerShell and Python generators: one container per run, no network, no credentials, only the run''s input values in'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2230
sprint: s09wwd3
comments:
- id: 01M8H7FX6YW00QBB2VBGAGRESA
  author: Steve Vine
  at: 2026-11-28T14:03:36.542774Z
  text: |-
    Done in PR #2238 (merged). There's a new image, compass-generator: Python 3.12 and PowerShell 7 with their standard libraries only, plus a small harness for each. Each PowerShell or Python run gets a pod of its own, started by the worker and deleted afterwards.
    How the pod is sealed off:
    - No network: the chart's deny-all network policy, which the worker checks exists before starting a pod.
    - No DNS.
    - No service account token, no Compass settings, and no secret except that run's inputs, mounted as a read-only file.
    - A read-only disk, a non-root user, every capability dropped, CPU and memory limits, and the script's time limit.
    What the script hands back is the only thing read from it. A local runner (a plain process) exists for development and Compass's own tests, and Compass refuses it on staging and production. System status now has a "Script runner (PowerShell and Python)" line.
    In the chart it's scriptRunner.enabled: off by default, on in staging. Production needs its network plugin to enforce network policy before it's switched on (on EKS, the VPC CNI's network policy agent). CI builds, promotes and releases the new image with the others. The first release that carries it creates the GHCR package as private, so it needs the same one-off "make public" flip the converter needed.
    Before the staging deploy I'll apply an updated CI deployer role, so the deploy can create the runner's Role and RoleBinding.
    What I checked: in the built image with no network and a read-only disk, PowerShell turned inputs (including a list) into values, Python couldn't connect anywhere and saw no secrets, and a thrown error came back with its message. The rest of Done-when (a test script on staging) I'll check in pre-UAT.
assignee: steve
label:
- feature
priority: high
task_status: review
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