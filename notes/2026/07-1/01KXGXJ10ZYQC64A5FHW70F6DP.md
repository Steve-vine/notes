---
id: 01KXGXJ10ZYQC64A5FHW70F6DP
created: 2026-07-14T18:17:20.159996364Z
updated: 2026-07-19T19:26:39.097205Z
type: task
title: 'Flaky frontend CI: unhandled React scheduler error after jsdom teardown (LoginPage.test.tsx)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 159
order: 1.0
assignee: steve
label:
- follow_up
- tech_debt
priority: medium
task_status: todo
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