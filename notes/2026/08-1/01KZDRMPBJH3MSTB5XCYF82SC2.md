---
id: 01KZDRMPBJH3MSTB5XCYF82SC2
created: 2026-08-07T09:25:05.010101Z
updated: 2026-08-07T11:55:46.362412Z
type: task
title: Evidence catalogue extension — general-purpose read queries for estate Q&A
project: 01KX671DATY39VW6GWK3M2T3DN
number: 599
sprint: snk16ew
assignee: steve
priority: medium
task_status: backlog
---
The Evidence catalogues were built for incident diagnosis, not open estate questions — Kubernetes offers only six queries (describe_pod, node_capacity, recent_events, pending_pods, rollout_status, pod_logs); a question like "what images run in prod right now" or "top memory consumers in namespace X" has no matching query.

- Audit every integration's `evidence_catalogue` against the question bank (ISE-595); list the misses.
- Extend catalogues with general read queries where synced state can't answer (live-now questions). Kubernetes first; others as the bank demands.
- Keep the ADR 0031 contract untouched: named queries with parameter schemas, side-effect-free by contract, results untrusted, credential access audited. We widen what can be asked, never what can be done.
- All three interfaces inherit automatically (Evidence parity — no per-surface wiring).

Screen: answers in Assist; queries also visible wherever evidence pulls already render.