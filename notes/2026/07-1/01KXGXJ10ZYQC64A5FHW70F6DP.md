---
id: 01KXGXJ10ZYQC64A5FHW70F6DP
created: 2026-07-14T18:17:20.159996364Z
updated: 2026-07-19T21:30:26.073095769Z
type: task
title: 'Flaky frontend CI: unhandled React scheduler error after jsdom teardown (LoginPage.test.tsx)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 159
order: 1.0
task_status: done
comments:
- id: 01KXXXVGS57GKH3463STEQJQ24
  author: Steve Vine
  at: 2026-07-19T19:32:38.820980024Z
  text: |-
    Verification (2026-07-19): this defect appears already fixed by COM-188 (PR #179, merged to main 2026-07-17 as bfefefc).

    COM-188's root-cause analysis matches this report exactly: with `globals: false` testing-library never auto-cleaned, so LoginPage's login mutation kept running after its test ended and died post-teardown with the "window is not defined" scheduler error. The fix was structural — a central afterEach in test-setup.ts that unmounts, cancels/clears every QueryClient from renderWithProviders and drains a task tick; the LoginPage test now awaits the me refetch; CI starvation addressed with asyncUtilTimeout 5s, testTimeout 15s and a 2-worker cap on CI.

    Evidence of resolution:
    - Every frontend CI job since the fix merged is green — 10+ runs across PR/staging/main over 2026-07-17..19 (including today's COM-189/COM-190 cycles), no recurrence.
    - 5 consecutive local full-suite runs today: 199/199 passed each time, no unhandled errors, no "window is not defined".

    Recommendation: close as fixed-by-COM-188 (this task predates it — migrated from Linear DEV-851, reported 2026-07-05).
---
First staging CI run (28749057843) failed the `frontend` job with all **154 tests passing** but one unhandled error:

```
ReferenceError: window is not defined
 ❯ node_modules/react-dom/cjs/react-dom-client.development.js:17920:15
 ❯ Immediate.performWorkUntilDeadline node_modules/scheduler/cjs/scheduler.development.js:45:48
This error originated in "src/pages/LoginPage.test.tsx" ... caught after test environment was torn down.
```

A React scheduler tick fires after Vitest tears down the jsdom environment — a queued render/effect task from LoginPage tests isn't flushed before the file completes. Timing-dependent: passes locally and passed the PR run on the same tree; surfaced under load on the shared single-node runners (6 jobs, 4 runner cap).

Fix ideas: ensure the login-page tests await pending React work (`await waitFor`/`act` on the last assertion, unmount in `afterEach`), or clear stray timers; avoid blanket `dangerouslyIgnoreUnhandledErrors`.

Workaround applied: re-ran the failed job (staging CI is allowed to go red — ADR 0036).

---
*Migrated from Linear [DEV-851](https://linear.app/stevevine/issue/DEV-851/flaky-frontend-ci-unhandled-react-scheduler-error-after-jsdom-teardown) · created 2026-07-05*