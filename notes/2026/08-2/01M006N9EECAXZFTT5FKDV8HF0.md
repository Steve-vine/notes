---
id: 01M006N9EECAXZFTT5FKDV8HF0
created: 2026-08-14T13:16:24.3986Z
updated: 2026-08-15T06:53:41.725362Z
type: task
title: Validation cannot say "gone", cannot wait, and can be fooled by a truncated list
project: 01KX671DATY39VW6GWK3M2T3DN
number: 712
sprint: sevhjex
comments:
- id: 01M008B2NWV3BG1GT7CWEET9MK
  author: Steve Vine
  at: 2026-08-14T13:45:46.940022Z
  text: |-
    ADDED 2026-08-14 — a fourth defect, and it is the root cause of the second one.

    VALIDATION QUERIES ARE NEVER PARAMETERISED. `playbook_runner.py:188` calls:

        result = connector.fetch_evidence(_evidence_ctx(db, system), query, {})

    — an empty params dict, always. And `target_scope` appears NOWHERE in the runner: it is declared on the envelope, validated at publish time, and never used to bind anything into a validation query.

    So the `node_present(name)` query proposed above cannot receive the node's name, and this task as originally written is unbuildable. Every existing predicate only works because the queries it uses are cluster-wide and take no arguments — which is precisely why `node_capacity` (no node parameter, capped at 100) was the nearest candidate and why it lies on a large cluster. The truncation problem and the parameterisation gap are the same root cause seen from two ends.

    Scope addition: resolve `target_scope` against the incident (`affected_entity` → the entity's name/native key; `entity_namespace` → its namespace) and pass it as the evidence query's params. Publish-time validation should refuse a predicate whose query requires a parameter the declared `target_scope` cannot supply — the same posture as refusing an operation outside the allowlist.

    Worth checking while in here whether any *existing* published envelope has a predicate that silently returns the wrong thing because it was written expecting a parameter that never arrived.
- id: 01M00E85CY282F29Y4C3TRQAFP
  author: Steve Vine
  at: 2026-08-14T15:29:02.878614Z
  text: |-
    DONE 2026-08-14 — PR #661, merged to main. No migration (the envelope is JSONB).

    All four defects, including the one added in the second comment, which turned out to be the root cause of the second:

    **Negation.** `not_contains` and `not_exists`. Both added rather than choosing one — the boolean-field route would have worked for `node_present` and left `!=`-against-a-list as the only recourse everywhere else.

    **Parameter binding.** `target_scope` now resolves against the incident and binds the query's params, **filtered to what that query declares** — most declare `additionalProperties: False`, so passing bindings wholesale would turn a working check into a rejected one. Publish refuses a predicate whose query needs a parameter the scope cannot supply.

    Answering the "check whether any existing envelope silently returns the wrong thing": nothing to fix. Every predicate on `main` uses `pending_pods`/`node_capacity`, both of which take **no required parameters** — which is exactly *why* they were the only ones anyone could use, and why the truncation problem and the binding gap are one root cause seen from two ends. I could not reach the staging DB to confirm the live rows (`g5.citops.net` did not resolve from the dev host); worth a glance next time the tunnel is up, though publish-time validation now refuses the shape either way.

    **`node_present(name)`.** A 404 is the ANSWER (`present: false`), not a failure — that is the whole point of the query. Every other status propagates and fails the check closed, so a 403 never reads as "the node was recycled". `node_capacity`'s catalogue description now tells the model outright not to use it for this.

    **The wait.** A `wait` block with its own anchor and its own deadline (a Celery `countdown`, entirely separate from `wall_clock_seconds`). A waited run parks as `awaiting_validation` and a scheduled task re-enters `finish_run` — the **same** verdict path, not a second one that has to be kept in step. The scheduled half is guarded on the run still being the one that was parked, so a human who resolves the incident meanwhile is not overwritten by a verdict computed for a world that has since changed. That guard is also what ISE-714's abort will use.

    Fail-closed is untouched. An unresolved check records **which kind** — `query_failed`, `unreachable`, `no_system` — and the escalation carries it; the verdict does not bend.
assignee: steve
label:
- feature
priority: high
task_status: done
tech: null
---
Three defects in the validation half of the envelope, all surfaced by trying to express the Karpenter playbook (ISE-709), whose criterion is *"the same node is no longer visible in the cluster within 30 minutes of it becoming not ready"*.

**1. The predicate language has no negation.** `PREDICATE_OPERATORS = ("==","!=","<","<=",">",">=","contains","exists")` — there is no `not_contains` and no `not_exists`. "The node is no longer in the list" is inexpressible. Add the negative operators, or make the check a boolean field (below), or both.

**2. There is no query that can answer it, and the nearest one lies.** The closest is `node_capacity`, which takes **no node parameter** and caps at `_EV_MAX_NODES = 100` (`kubernetes.py:639`). On a cluster with more than 100 nodes a node truncated out of the response is indistinguishable from a node that is gone — a false pass that closes a real incident autonomously. Add a purpose-built `node_present(name)` evidence query returning a boolean, which fixes both the negation and the truncation in one move.

**3. Waiting is impossible, and the anchor is wrong.** `run_bounds.wall_clock_seconds` maxes at 1800 — exactly the 30-minute window — but it is the *total run budget*, so waiting would consume the entire allowance and leave nothing to validate with. And the window is relative to the **signal**, not the run: an incident opened 25 minutes after the node went NotReady has 5 minutes left, not 30. Add a `wait` block separate from `run_bounds`:

```
wait: { anchor: signal_first_seen | run_start | action_complete, seconds: int }
```

A run that waits then validates outlives its request, so it needs a durable scheduled check with its own deadline — and ISE-630 is the precedent to respect: a 60s runner timeout killed a 600s reboot because one name served two questions. The wait deadline and the execution timeout must be separate values.

**Keep the fail-closed rule.** `_validate` treats anything unresolvable — query failed, source unreachable, exception — as a FAILED check, deliberately, and that is right for autonomy: never read "I could not check" as "it is fine". Worth distinguishing *failed* from *unreachable* in the escalation message only, so the human is sent to the right place; the verdict stays the same.

Depends on ISE-710. Pairs with ISE-711.