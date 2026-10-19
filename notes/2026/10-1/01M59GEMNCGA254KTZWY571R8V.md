---
id: 01M59GEMNCGA254KTZWY571R8V
created: 2026-10-19T07:19:11.276703Z
updated: 2026-10-19T07:19:11.276703Z
type: task
title: CI's frontend tests use more than two workers, once each test file is light enough not to starve the runner
assignee: steve
label: improvement
priority: medium
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1107
---
Sprint 77, CI / Build optimisation. Raised 2026-10-19 from the review of sprint 77's tasks. Blocked by the task that stops frontend tests loading the whole app.

## Why

`vitest.config.ts` sets `maxWorkers: 2` under CI. COM-188 added the cap because one jsdom worker per core starved the runners and produced spurious 5s timeouts. Most of that load was each file loading the whole app (see the blocking task). Once that's gone, two workers leave the runner mostly idle: the backend integration job runs six workers on the same kind of pod.

## What changes

- CI's frontend tests run with more workers: try 4, and keep it only if it's faster and no timeouts come back.
- Nothing about what is tested changes, and the timeouts COM-188 / COM-468 set stay as they are.

## Notes (technical)

- Measure 2, 3 and 4 workers on the same commit: three CI runs each, both with g5 quiet and with another PR running. Record wall time and any flakes (memory: frontend vitest parallel flake: RecertPage/Portal tests flake under full-suite CPU load; prove any flake against clean main).
- Runner pods request 1 CPU with no limit (`scripts/infra/arc-compass-runners-values.yaml`), so extra workers burst onto shared cores. Check `kubectl top nodes` during a run (memory: g5 kubeconfig access).
- Also try `pool: 'threads'` against the default `forks` while you're measuring. Keep it only if it's faster and the suite stays green. Don't touch `isolate`.
- Update the COM-188 comment in `vitest.config.ts` with the new measurements.

**Done when:** the worker count is set from measurements recorded in the PR, the frontend job is faster than with 2 workers, and no new timeouts appear across the measurement runs.