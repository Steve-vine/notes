---
id: 01KYS2T24D6R197YB8FAN5BH0V
created: 2026-07-30T08:38:43.597033Z
updated: 2026-07-30T09:12:18.005936Z
type: task
title: Worker OOM-killed under concurrent cloud syncs — right-size memory + recycle children
project: 01KX671DATY39VW6GWK3M2T3DN
number: 371
order: 1.0
sprint: s0d5f5q
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found 2026-07-30 while debugging the first Azure sync on staging: ise-worker was OOMKilled (exit 137, 512Mi limit) every ~9 minutes all night — 62 restarts since the 2026-07-29 deploy, BEFORE the Azure system existed — and caught dying again exactly when the AWS and Azure syncs ran concurrently. Syncs are idempotent so no corruption, but the worker is burning restarts and losing in-flight tasks.

Scope: raise the worker memory limit in the Helm values (512Mi → 1Gi, requests to match), and add Celery `worker_max_tasks_per_child` so slow per-process leaks (boto3 builds clients fresh per call and loads service models each time) are bounded by recycling. Verify on staging: restart count stays 0 across several concurrent AWS+Azure sync cycles. Genuinely headless/infra work — no UI surface.