---
id: 01KZVE2BTK4G3EX466JCE1GHWY
created: 2026-08-12T16:49:40.691144Z
updated: 2026-08-12T16:49:40.691144Z
type: task
title: Cancelling a running step doesn't reap its K8s Job (DEV-564 regression)
priority: high
assignee: steve
task_status: done
imported_from: linear
label: bug
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 212
---
Found while cancelling a slow vuln scan (run `a1c0de12`). The step flipped to `cancelled`, but the **nuclei pod kept running** — I had to `kubectl delete job` manually to stop it.

### Root cause (DEV-564)

Cancellation is single-writer (Brief 016): the cancel route writes `status=CANCELLED`; the dispatcher is supposed to reap the K8s Job. In the new per-step dispatch, `delete_job` lives only in `_ingest_step_run_terminal` (`tasks/workflow_runs.py:2233`). But once the route has set `CANCELLED`, the next `run_step_task` hits the **terminal short-circuit** in `_run_step` Stage 1 (line ~2774) and returns via `_finalize_and_advance` **before** reaching the poll/ingest path — so `delete_job` is never called. The Job survives until its `activeDeadlineSeconds` (~wall_clock×1.2) or the engine's own wall-clock watchdog (up to ~4 h), so a cancelled scan keeps burning CPU.

(The in-flight-poll cancel path — `_poll_step_once` detecting the cancel mid-iteration → `_ingest_step_run_terminal` → delete — still reaps correctly, but that's a tiny timing window; the common case is route-sets-CANCELLED-then-short-circuit.)

### Fix

In `_run_step`'s terminal short-circuit, when the step is terminal **and** still carries a `k8s_job_name`, delete the Job (best-effort, `Background` propagation, 404 OK / idempotent) before finalising. For SUCCEEDED/FAILED/TIMED_OUT the Job was already deleted by the original ingest, so it's a no-op; for route-CANCELLED it reaps the live pod.

### Test

* A step pre-set to `CANCELLED` with a `k8s_job_name` → `run_step_task` calls `delete_job` and finalises (extend the existing cancel test / `_patch_k8s` `delete` mock).

### Acceptance

Cancelling a running workflow stops the scanner pod promptly (the dispatcher reaps the Job on the next poll), not only after the Job deadline.

---

Imported from Linear [DEV-570](https://linear.app/stevevine/issue/DEV-570/cancelling-a-running-step-doesnt-reap-its-k8s-job-dev-564-regression)