---
id: 01KXK8AM2WGS1DF859T3V9Y6X6
created: 2026-07-15T16:04:00.732313885Z
updated: 2026-07-17T17:24:57.867632211Z
type: task
title: 'Flaky frontend test: async "window is not defined" after teardown (LoginPage.test.tsx)'
task_status: active
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
- id: 01KXNJGJG3PTJHDJRRTCC93VXB
  author: Steve Vine
  at: 2026-07-16T13:40:30.339061074Z
  text: 'Three more occurrences in one afternoon: the same post-teardown "window is not defined" flaky failed the frontend job on PR #169, PR #170 and the Sprint 28 staging push (runs 29499198426, 29499804377, 29502353537) — all tests passed each time. All three re-run. That''s five hits total; this is now the top reliability issue in the CI pipeline and worth scheduling into the next sprint.'
- id: 01KXPG2RE4Q0JK1AARHQZHTQF3
  author: Steve Vine
  at: 2026-07-16T22:17:14.948170192Z
  text: |-
    Two more occurrences during the Sprint 29 release (2026-07-16), both new symptoms of the same jsdom/Vitest instability rather than the original LoginPage "window is not defined" teardown error:

    1. PR #176 rebased-head run 29536496713: RiskDetailPage.test.tsx:124 timed out at 5000ms (untouched file; passed on identical content pre-rebase and on staging). Rerun passed.
    2. Main push run 29536491686 (COM-184 squash): VendorsPage "shows the form builder" test found only a leftover Mantine portal node in the DOM — the page body was gone (teardown/render race). Passed on every earlier run of the same code; rerun passed.

    Pattern is broadening: three distinct symptoms (post-teardown window access, 5s timeouts, portal-only DOM) all consistent with resource-starved runners + jsdom teardown races. Suggest the fix task consider: per-test timeouts bumped for CI, vitest pool/isolation settings, and teardown hygiene (unmount before portal cleanup) rather than chasing individual tests.
---
Surfaced during COM-166's staging push (run 29430260853): the `frontend` job failed with a Vitest **unhandled error caught after test environment teardown** — `ReferenceError: window is not defined`, originating while `src/pages/LoginPage.test.tsx` was running. The identical commit passed PR CI (#157) minutes earlier, so it's a teardown race (an async task — likely a react-query mutation/fetch continuation — resolving after jsdom is gone), not a product bug.

- [ ] Reproduce (loop `vitest run src/pages/LoginPage.test.tsx`) and find the un-awaited async work.
- [ ] Fix by awaiting/cancelling the pending task before test end (e.g. `await waitFor` on the final state, or abort in `afterEach` before `cleanup()`).
- [ ] Check sibling tests for the same pattern.

References COM-166 (found during its staging merge; not caused by it — the change was docs-only).