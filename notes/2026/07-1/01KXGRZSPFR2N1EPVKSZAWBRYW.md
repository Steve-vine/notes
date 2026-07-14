---
id: 01KXGRZSPFR2N1EPVKSZAWBRYW
created: 2026-07-14T16:57:28.527468417Z
updated: 2026-07-14T16:57:28.527468417Z
type: task
title: Worker/beat CrashLoopBackOff — Celery workloads deployed but Celery isn't implemented
task_status: done
label: chore
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 29
---
## Symptom

`compass-worker` and `compass-beat` have been in **CrashLoopBackOff** since deploy (hundreds of restarts). Rolling images to `a8c4379` did not help — they crash on the new image too. Containers fail with `StartError` **/ exit 128** and emit **no application logs**: the container runtime can't start the process before app code runs.

## Root cause

The Helm chart unconditionally deploys `worker` (`chart/templates/worker/deployment.yaml`) and `beat` (`chart/templates/beat/deployment.yaml`), both with command `celery -A compass_api.core.celery_app …`. But Celery was never actually implemented:

* `celery` **is not a dependency** — it's absent from `app/backend/pyproject.toml` `dependencies` (only a `# … Celery (later)` comment) and has **zero entries in** `uv.lock`, so the `celery` binary is not in the image's venv.
* **The Celery app module doesn't exist** — there is no `compass_api/core/celery_app.py` (no celery code anywhere in `src`).

So the container tries to exec `celery`, which isn't on `PATH` → `StartError` exit 128 → crashloop. The API (`uvicorn`) and frontend run fine on the **same** image because uvicorn *is* installed; only the celery command fails. The worker/beat workloads were scaffolded in the chart ahead of the implementation (ADR 0006 decided Celery; the code was deferred).

## Impact

* Two pods perpetually crashlooping in the live `compass` namespace — restart churn + log noise.
* The worker Deployment's rollout never completes (new pod never Ready), so an old ReplicaSet pod lingers.
* **No user-facing functionality is lost today** — the M2 MVP (read-only browse / assess / gaps / dashboard) has no background tasks.

## Resolution — two options

1. **Interim (recommended): gate the workloads off.** Add `worker.enabled` / `beat.enabled` to `chart/values.yaml` (default `false`) and wrap both deployment templates in `{{- if }}`. One small chart PR stops the crashloop immediately; re-enable when Celery lands.
2. **Full fix (ADR 0006): implement Celery.** Add `celery[redis]` to dependencies, create `compass_api/core/celery_app.py` (broker + result backend = the in-cluster Valkey), define at least a health/no-op task and the beat schedule, and verify worker/beat run. This is the real async-tasks brief — worth doing when a background-job need actually exists.

## Suggested path

Ship **option 1** now to clean up the deployment; track **option 2** as a separate `brief` for when a real task need arrives.

Refs: ADR 0006 (Celery), ADR 0008 (one image, four commands). Found while rolling the cluster to `a8c4379`.

Files: `chart/templates/worker/deployment.yaml`, `chart/templates/beat/deployment.yaml`, `chart/values.yaml`, `app/backend/pyproject.toml`.

---
*Migrated from Linear [DEV-429](https://linear.app/stevevine/issue/DEV-429/workerbeat-crashloopbackoff-celery-workloads-deployed-but-celery-isnt) · created 2026-06-15 · completed 2026-06-15*  
*Related to (Linear): DEV-416*