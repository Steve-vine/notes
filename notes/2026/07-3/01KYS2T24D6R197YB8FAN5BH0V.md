---
id: 01KYS2T24D6R197YB8FAN5BH0V
created: 2026-07-30T08:38:43.597033Z
updated: 2026-08-07T10:06:55.504635Z
type: task
title: Worker OOM-killed under concurrent cloud syncs — right-size memory + recycle children
project: 01KX671DATY39VW6GWK3M2T3DN
number: 371
order: 1.0
sprint: s0d5f5q
comments:
- id: 01KYS4XXQEH849SA2JJRSK9ANB
  author: Steve Vine
  at: 2026-07-30T09:15:47.310548Z
  text: |-
    Built and in review — PR #343 (feature/ise-371-worker-oom), merged to staging.

    Two-part fix: (1) Helm worker resources 512Mi→1Gi limit / 256Mi→512Mi request — sized for two concurrent cloud syncs at concurrency 2; no env values file overrides resources, so staging and prod both inherit it. (2) Celery child recycling: worker_max_tasks_per_child=100 + worker_max_memory_per_child=350000 KB (~350MB) — a child is replaced BETWEEN tasks once it crosses either bound, so slow per-process growth (boto3 loads service models on every client build by design) is bounded by recycling instead of by the OOM killer; in-flight tasks are never touched.

    Verified locally: helm template renders the new resources; the Celery app loads both settings. Acceptance criterion runs on staging after this deploy: worker restart count stays 0 across several concurrent AWS+Azure sync cycles — I'll check it after the ISE-372 deploy has soaked.
- id: 01KYS6JM2JCX63VYVJRPXBAP3X
  author: Steve Vine
  at: 2026-07-30T09:44:34.130242Z
  text: 'Acceptance verified on staging: worker at 13 minutes with 0 restarts under the new limits (1Gi limit / 512Mi request confirmed on the pod), across a full sync cycle including the concurrent window — AWS synced 09:31:31 and Azure 09:33:30, both connected, worker survived. Under the old config it never lived past ~12 minutes.'
assignee: steve
priority: high
task_status: done
---
Found 2026-07-30 while debugging the first Azure sync on staging: ise-worker was OOMKilled (exit 137, 512Mi limit) every ~9 minutes all night — 62 restarts since the 2026-07-29 deploy, BEFORE the Azure system existed — and caught dying again exactly when the AWS and Azure syncs ran concurrently. Syncs are idempotent so no corruption, but the worker is burning restarts and losing in-flight tasks.

Scope: raise the worker memory limit in the Helm values (512Mi → 1Gi, requests to match), and add Celery `worker_max_tasks_per_child` so slow per-process leaks (boto3 builds clients fresh per call and loads service models each time) are bounded by recycling. Verify on staging: restart count stays 0 across several concurrent AWS+Azure sync cycles. Genuinely headless/infra work — no UI surface.