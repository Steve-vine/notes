---
id: 01KXKTN82J22HZXMVCN9E0TFEN
created: 2026-07-15T21:24:23.250121058Z
updated: 2026-07-21T16:17:10.128223Z
type: task
title: Golden-run eval harness — a manual/nightly agent-regression job
project: 01KX671DATY39VW6GWK3M2T3DN
number: 80
sprint: sd1gs0p
assignee: steve
priority: medium
task_status: backlog
---
The ai-engine brief calls for it: "curate a small regression set of snapshot/finding fixtures with expected analyses ('golden runs') to smoke-test prompt or model changes before rollout." Prompts and agent definitions have been versioned in git from day one precisely to make this possible. Nothing exists yet — no fixtures, no eval job.

## Scope

- A **curated golden-run fixture set**: snapshot/finding/issue datasets with expected analyses/diagnoses — seeded from real anomalies the estate has produced.
- An eval that runs the actual task types (`analyse`, `diagnose`, `propose-remediation`, and now `assist`) against **real models** and scores the output against the golden expectations. Catches a model or prompt *getting worse at the task* — which `FunctionModel` unit tests cannot.

## Where it runs — decided in Sprint 6 planning

A **separate manual and/or nightly workflow**, **never in the PR gate**:
- CI has **no provider API keys** (`ANTHROPIC_API_KEY`/`OPENAI_API_KEY` are runtime deploy secrets only) — they'd need adding as GitHub secrets for this job alone.
- The backend PR job is already 6–8 min; real model calls would add cost + latency to every PR and make the primary gate depend on provider uptime.

So: fixtures + a dedicated workflow with provider keys as secrets, triggered manually and/or nightly. `feature`/`brief`.