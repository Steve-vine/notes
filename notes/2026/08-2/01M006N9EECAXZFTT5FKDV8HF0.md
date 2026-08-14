---
id: 01M006N9EECAXZFTT5FKDV8HF0
created: 2026-08-14T13:16:24.3986Z
updated: 2026-08-14T13:27:10.893071Z
type: task
title: Validation cannot say "gone", cannot wait, and can be fooled by a truncated list
project: 01KX671DATY39VW6GWK3M2T3DN
number: 712
sprint: sevhjex
assignee: steve
label:
- feature
priority: high
task_status: todo
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