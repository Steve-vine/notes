---
id: 01KZ1T7T0HKX0FY8VKN406A6MX
created: 2026-08-02T18:02:06.737304Z
updated: 2026-08-02T18:02:06.737304Z
type: task
title: 'Frontend tests: raise vitest testTimeout — 5s is too tight under CI load'
label:
- tech_debt
- follow_up
assignee: steve
task_status: backlog
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 492
---
The frontend suite intermittently fails on CI with bare 5-second timeouts in tests that have nothing to do with the change under test. It reddened **main** during the ISE-477..490 release and had to be cleared with a re-run.

## Evidence — three hits in one release (2026-08-02)

| Where | Test that timed out | Related to the change? |
|---|---|---|
| PR #426 (Proposals) | `MasterIncidents.test.tsx > releasing every child asks for a status once and posts to demote` | No — file untouched |
| main push `9aa88d0` | `IncidentSignalLink.test.tsx > the description opens the signal it was promoted from (ISE-189)` | No |
| main push `9aa88d0` | `UserManagement.test.tsx > an admin sees the user list and can disable a user` | No |

In every case the **full 518-test suite passed locally on the identical commit**, and each CI job passed on `gh run rerun --failed` with no code change.

## Diagnosis

`app/frontend/vite.config.ts` sets no `testTimeout`, so vitest's default **5000 ms** applies:

```ts
test: {
  environment: 'jsdom',
  setupFiles: ['./src/test/setup.ts'],
},
```

The suite reports roughly **335 s of test time inside a 49 s wall-clock run** — vitest is running files across all cores, so any individual test can be starved for several seconds while its neighbours hold the CPU. On the shared `ise-runners` ARC pool (dind, alongside backend testcontainers) that starvation regularly exceeds 5 s, and an async `findBy*` that would have resolved fine simply runs out of clock.

## This is NOT ISE-460

ISE-460 was the time-of-day flake, fixed in PR #399 by anchoring fixtures to the real clock. Different signature: that one **failed assertions**; this one produces a **bare `Test timed out in 5000ms`** with no assertion reached. Don't conflate them — see [[ise-flaky-time-of-day-tests]].

## Proposed fix

Raise `testTimeout` (and `hookTimeout`) in the `test` block of `app/frontend/vite.config.ts` — 15000 ms is the obvious starting point, matching the headroom the backend suite already gets. A slower timeout costs nothing when tests pass; it only changes how long a genuinely hung test takes to report.

Worth considering alongside it: capping `poolOptions.threads.maxThreads` so the suite stops competing with itself, which would treat the cause rather than the symptom.

## Why it matters

A red main that is actually fine is the most expensive kind of CI signal — it trains everyone to re-run first and read second, which is exactly how a real failure gets waved through. Per CLAUDE.md, push→main "should never go red".

## Acceptance

- CI frontend job passes reliably across consecutive runs with no code change.
- A genuinely failing test still fails, and still reports clearly.