---
id: 01KZVBFG0MEDKG18TQTDZGNJTR
created: 2026-08-12T16:04:25.236778Z
updated: 2026-08-12T16:05:46.377271Z
type: task
title: Concurrent same-status PATCH behaviour — test redesign + idempotency decision
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 119
sprint: s1hm0kb
assignee: steve
imported_from: linear
label:
- tech_debt
priority: low
task_status: backlog
---
## Status: parked

Returned to Backlog after the attempted redesign (during Implementation hand-off, 2026-05-23) surfaced a product question that's bigger than the test fix.

## What surfaced

The redesign called for both `attempt` coroutines in `test_two_concurrent_transitions_one_event_emitted` to target the same status — so one wins (rowcount=1) and the other loses (rowcount=0) deterministically. Claude Code identified that this introduces a scheduling-dependent path: if the loser's `_load()` runs **after** the winner commits, the service sees `current == new` and raises `StatusUnchangedError` *before* the conditional UPDATE — never reaching the loser-path branch.

That's the test surfacing a real product API-contract question:

> Two operators hitting "mark as triaged" on the same NEW finding will get different HTTP responses based on millisecond timing.

* If B loads **before** A commits → loser path → 200 with TRIAGED (silent success).
* If B loads **after** A commits → `StatusUnchangedError` → 422 `STATUS_UNCHANGED`.

Same intent, two outcomes. The same shape exists for `OwnerUnchangedError` from Brief 053.

## Why parked

* **No CI block** — DEV-262's `@pytest.mark.skip` is on main.
* **No production impact yet** — operators haven't hit the 422 in real workflows (pre-launch).
* **Real coverage of the loser-path semantic** already lives in `test_loser_path_is_idempotent_no_op` (deterministic, fast).
* The right fix is a product decision (idempotent 200 vs error 422), not a test-rewrite. Papering over it (try/except in the test) would hide a real contract gap.

## Resumption criteria

Pick this up when ONE of:

* Operators hit the 422 in real workflows (real evidence of contract pain).
* A deliberate API-contract review concludes PATCHes should be idempotent (e.g. v1 API hardening before launch).

## Likely scope when resumed

1. Brief covering `FindingStatusService` + `FindingOwnershipService` returning the row silently when `current == new` (no event, no UPDATE).
2. Remove the 422 `*_UNCHANGED` branches from the PATCH routes.
3. Update Brief 050 + Brief 053 tests for the new contract.
4. ADR documenting the idempotency decision.
5. Rewrite the concurrent-transition test with both `attempt` calls targeting the same status — now genuinely deterministic.
6. Remove the DEV-262 skip decorator.

## Out of scope (forever)

* Service-code changes purely to make the existing test pass without addressing the contract question. The test caught a real ambiguity; any fix must address that.

---

Imported from Linear [DEV-261](https://linear.app/stevevine/issue/DEV-261/concurrent-same-status-patch-behaviour-test-redesign-idempotency)