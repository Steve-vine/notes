---
id: 01KYF6WQC0K09EKDNCGPFMBK1E
created: 2026-07-26T12:37:40.864102Z
updated: 2026-08-05T12:33:54.181807Z
type: task
title: Stop re-running the full test suite on staging push
project: 01KX671DATY39VW6GWK3M2T3DN
number: 318
sprint: sr2f21y
comments:
- id: 01KYFF27X9CQN0F1F78DFAE0CW
  author: Steve Vine
  at: 2026-07-26T15:00:30.249109Z
  text: |-
    Done — PR #278 (feature/ise-318-staging-no-fullsuite), green. ADR 0052 written; ADR 0011 marked amended.

    On push→staging we no longer re-run the full suite. A new combined-check job (staging-push only) runs just the two checks that can go red on the *combined* state even when every branch was individually green — the drift the belt-and-braces staging run historically caught:
    1. regenerate openapi.json + schema.d.ts, fail on drift (the stacked-OpenAPI drift that reddened staging before);
    2. assert a single alembic head (stacked-migration divergence).
    It gates build-images → deploy-staging; the staging smoke test still exercises the running combined app. backend/frontend/api-types are skipped on the staging push. PR→main and push→main are unchanged (full suite).

    Chose a reduced combined check (not "none") per the acceptance's steer. ADR 0052 records the accepted residual risk: a purely *behavioural* interaction between two individually-correct branches (no API/migration surface) is now caught only by the push→main belt-and-braces run, not on staging — acceptable because staging is disposable and main remains the final gate before prod.

    Verified on this PR: combined-check correctly skipped (it's a PR, not a staging push); backend/frontend/api-types ran normally and passed. Locally confirmed the combined-check steps: openapi/schema regen produce no drift, alembic heads == 1. combined-check gets its first live run when this sprint merges to staging.

    Used ADR 0052 (not 0051 — that's reserved by ISE-321 for the GitHub repo register).
assignee: steve
label: null
priority: medium
task_status: done
---
`push→staging` re-runs the entire backend+frontend suite the PR gate already ran on ~identical code, doubling runner load per release (and it competes with the two PR-gate runs). Let staging run **build-images + deploy + smoke only**, gating the build on the PR gate having passed. Weigh against the belt-and-braces intent (ADR 0011): the combined-state test has caught real drift (e.g. stacked-migration / api-types drift), so consider keeping a **reduced** combined check rather than none.

Acceptance: a staging release runs ~1 fewer full suite; combined-state safety retained or the risk explicitly accepted in the ADR.