---
id: 01KZVT57RBDH8HYE5RB2H4RH2Y
created: 2026-08-12T20:20:57.739513Z
updated: 2026-08-12T20:40:40.978511Z
type: task
title: 'Fail-safe the changes filter: a failed `changes` job must not skip the gate'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 202
comments:
- id: 01KZVV9B8J13Q2YB79R9N8YWPJ
  author: Steve Vine
  at: 2026-08-12T20:40:40.978422Z
  text: |-
    Done — PR #196, merged, backstop green, deployed. First task through the new trunk loop end to end.

    Applied the fail-safe condition to all six filtered jobs (`backend-static`, `backend-test`, `migrations`, `frontend`, `deps-scan`, `sast`), with the reasoning documented on the `changes` job so the next person doesn't quietly undo it.

    **Re-probe result — the fix works, with one caveat.** Throwaway PR #197 (backend touched, `changes` forced to exit 1):

    ```
    changes         fail       8s
    backend-static  pass      44s
    backend-test    pass    4m22s
    frontend        pass    2m30s
    migrations      pass       8s
    deps-scan       pass    1m50s
    sast            pass    1m16s
    secret-scan     pass      15s
    ```

    All six **ran and passed** instead of skipping — before the fix they all skipped and the PR reported MERGEABLE with nothing tested. The dangerous half is closed: a broken filter can no longer let untested code through.

    **Caveat, stated plainly:** the PR still reported `mergeable: MERGEABLE / UNSTABLE`, because `changes` is not a required context so its failure doesn't itself block. That is now a much smaller problem — everything was actually tested — but a failing `changes` is a signal something is broken and ought to stop the merge. Closing it needs `changes` added to the required contexts, which the sandbox classifier blocked me from doing; payload is staged with `changes` already prepended and Steve has the command. **Until that runs, this task is fixed but not fully belt-and-braces.**

    Release: merged to `main`, backstop passed, pointer moved with a plain `git push origin main:staging` — **a real fast-forward, no `--force`**, which is the first confirmation the pointer model works as designed rather than as a one-off reset. Deploy 2m30s, site 200, `main` and `staging` level.
assignee: steve
label:
- bug
priority: high
task_status: active
---
Gate-bypass defect introduced by COM-199. **Proven, not theoretical.**

If the `changes` job fails, every job with `needs: changes` is **skipped**, and GitHub counts a skipped required check as passing. Probe PR #195 (since deleted): touched `app/backend/`, forced `changes` to exit 1 → `backend-static`, `backend-test`, `frontend`, `migrations`, `deps-scan`, `sast` all skipped, `secret-scan` passed, and GitHub reported **`mergeable: MERGEABLE`**. A backend change could have merged with zero tests run.

This is the mirror of the hazard ADR 0041 records: a job that *never runs* blocks forever, while a *skipped* job satisfies protection. That asymmetry is what makes path filtering work — and what makes a failed filter job dangerous. COM-199 built the filter without closing the second side.

**Fix — make the workflow fail-safe rather than relying on protection config.** For every job with `needs: changes`:

```yaml
if: ${{ !cancelled() && github.event_name == 'pull_request'
        && (needs.changes.result != 'success' || needs.changes.outputs.<flag> == 'true') }}
```

A broken filter then runs **everything** instead of nothing.

- [ ] Apply to `backend-static`, `backend-test`, `migrations` (backend), `frontend` (frontend), `deps-scan`, `sast` (code).
- [ ] Keep the explicit `github.event_name == 'pull_request'` term — without it, `needs.changes.result == 'skipped'` on a push to `main` satisfies `!= 'success'` and the test jobs would run on the trunk, breaking the backstop-only run.
- [ ] Use `${{ }}` form: a bare `!` starts a YAML tag.
- [ ] `secret-scan` unchanged — it has no `needs` and is never filtered.
- [ ] Re-run the probe to confirm a failed `changes` now blocks the merge.

**Defence in depth, separate from this PR:** also add `changes` to the required contexts (`docs/ci.md` already documents it as one). One `gh api` call — the sandbox classifier blocked Claude from making it, so Steve runs it. Payload is staged with `changes` already prepended.