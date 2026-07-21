---
id: 01KXH1YMKZ1NA8ZHNM1CGKK010
created: 2026-07-14T19:34:07.743117096Z
updated: 2026-07-21T09:54:07.963066Z
type: task
title: Assist budget controls — don't let chat starve the path ISE-57 protected
project: 01KX671DATY39VW6GWK3M2T3DN
number: 68
sprint: syz8rn1
blocked_by:
- 01KXH1X85G8DQYM4DJ5GD5E0W2
assignee: steve
priority: high
task_status: done
---
**Decide this before shipping, not after the first bill.**

Assist is correctly **not** in `SCHEDULED_AI_TASK_TYPES`, which by the ISE-57 rule means it gets the **full daily ceiling** — the reasoning being "a human is waiting on it and has already accepted its cost by asking".

That reasoning is right for a single `diagnose` click. It is **wrong for an open-ended chat box.** `ai_run_max_tokens` is 200k *per run*, and a chat has no natural end: a curious operator on a 12-turn conversation across a large estate can burn the entire daily ceiling.

**And then the next thing ISE refuses is the `propose-remediation` an operator clicked and is waiting for.** That is *precisely* the failure ISE-57 exists to prevent — the spend ceiling refusing the human it exists to serve — reintroduced with a new perpetrator. Assist would be the thing that starves the path ISE-57 was written to protect.

## Controls

- **`ai_chat_max_tokens`** — a per-run cap for assist, well below the 200k general cap (~60k). A chat turn does not need a 200k budget.
- **A per-thread cumulative spend cap** — bounds a single runaway conversation, which is the realistic failure, rather than a single runaway turn.
- **An assist sub-budget** — a share of the daily ceiling that assist may not exceed, so that operator-triggered `diagnose` / `propose-remediation` always retain headroom. This mirrors the scheduled-work reserve, in the other direction: the *interactive* band is now shared by two kinds of work with very different appetites.
- Surface assist spend in the existing spend UI (`AISpendCard` / `GET /api/v1/ai-config/spend` already aggregate by task type, so this should be close to free).

Blocked by: ISE-65.