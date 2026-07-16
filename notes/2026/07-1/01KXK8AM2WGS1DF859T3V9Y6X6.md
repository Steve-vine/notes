---
id: 01KXK8AM2WGS1DF859T3V9Y6X6
created: 2026-07-15T16:04:00.732313885Z
updated: 2026-07-16T07:53:59.760872201Z
type: task
title: 'Flaky frontend test: async "window is not defined" after teardown (LoginPage.test.tsx)'
task_status: backlog
label:
- follow_up
- bug
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 188
comments:
- id: 01KXMYP36GWY9ZKTF1TWX69YTW
  author: Steve Vine
  at: 2026-07-16T07:53:59.760780449Z
  text: 'Second occurrence: the same post-teardown "window is not defined" unhandled error (originating in LoginPage.test.tsx) failed the frontend job on the COM-174 main-push run (29480810010) — all 175 tests passed, the unhandled error alone failed the job. gh run rerun --failed fixed it again. That''s two hits in two days (COM-166 staging push, now a main push); worth prioritising this fix.'
---
Surfaced during COM-166's staging push (run 29430260853): the `frontend` job failed with a Vitest **unhandled error caught after test environment teardown** — `ReferenceError: window is not defined`, originating while `src/pages/LoginPage.test.tsx` was running. The identical commit passed PR CI (#157) minutes earlier, so it's a teardown race (an async task — likely a react-query mutation/fetch continuation — resolving after jsdom is gone), not a product bug.

- [ ] Reproduce (loop `vitest run src/pages/LoginPage.test.tsx`) and find the un-awaited async work.
- [ ] Fix by awaiting/cancelling the pending task before test end (e.g. `await waitFor` on the final state, or abort in `afterEach` before `cleanup()`).
- [ ] Check sibling tests for the same pattern.

References COM-166 (found during its staging merge; not caused by it — the change was docs-only).