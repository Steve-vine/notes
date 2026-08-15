---
id: 01M026F74P2SDNH1JGNMDT1P23
created: 2026-08-15T07:51:34.294651Z
updated: 2026-08-15T13:55:32.04826Z
type: task
title: The incident conversation shows answers before questions — no tiebreak on a shared timestamp
project: 01KX671DATY39VW6GWK3M2T3DN
number: 727
sprint: sevhjex
comments:
- id: 01M02V9GRFC40F50M8PKR5S7M1
  author: Steve Vine
  at: 2026-08-15T13:55:27.63118Z
  text: |-
    Done — PR #678, merged to main 2026-08-15.

    **It was on four surfaces, not one.** Checking how assist had fixed it — as the task asked — turned up that assist's own `build_history` still had the bug. ISE-604 gave the assist *transcript* the tiebreak and stopped there; the history replayed to the **model** never got it.

    | Surface | Was |
    |---|---|
    | `list_conversation_messages` | the reported bug |
    | `_issue_history` (issue chat → model) | same bug |
    | `build_history` (assist chat → model) | same bug, on the surface that had already fixed it once |
    | assist transcript + delete walk | correct; now reads the shared helper |

    The two history builders matter more than the screen. Both walk newest-first under a `LIMIT`, so a broken tie can reverse a pair **and**, when the boundary lands inside one, hand the model an answer with no question attached.

    **I did not build the sequence column you recommended, and the reason is worth recording.** Its migration's backfill cannot recover the order of rows that are already tied — the information is not in the table. And it would leave assist on a role rank and issues on a sequence: two mechanisms for one question, which is the disease rather than the cure. Your other instruction — "check how the assist surface fixed it and reuse that" — points the other way, and ISE-686/687 breaks the tie. `ISSUE_CONVERSATION_ROLES` is exactly `(user, assistant)` and a turn writes one of each; a turn that ever writes a third row is a schema change, and the ordering gets revisited with it. So: `conversation_order.turn_rank`, ISE-604's answer lifted out, used by all four.

    Your `ORDER BY created_at, role` trap is written down in the module rather than just avoided, since it is the thing the next person will reach for.

    **A test lesson worth carrying forward.** Tests write a pair with an identical `created_at`, as you specified — but the first version still passed against the broken code. With no tiebreak, the pair comes back in whatever order the heap happens to hold it, so **the physical insertion order decides whether a single test catches the bug at all**. Both new tests now write both orders; the assist one caught the bug only in the `user`-first case. That is exactly how this survived on a surface that had already fixed it.

    Verified by reverting each fix in turn — the display test and both history tests fail without it.

    One follow-on in the same PR: the endpoint's docstring IS its OpenAPI description, so documenting the ordering made the committed snapshot stale and reddened CI. Regenerated.
assignee: steve
label:
- bug
priority: high
task_status: review
tech: null
---
On IN-1358 the answer rendered **above** the question that produced it. Reported 2026-08-15.

**Cause.** A turn writes its user and assistant rows in one transaction, and `created_at` defaults to `now()` — which in Postgres is *transaction start* time, identical for every row in the transaction. Verified on staging, both pairs share a timestamp to the microsecond:

```
assistant  06:49:50.692821   Pulling the server's own logs…
user       06:49:50.692821   Can you confirm from the server itself…
assistant  07:37:45.790468   (failed)
user       07:37:45.790468   The alert status is set to recovered…
```

`list_conversation_messages` (`issues.py:1776`) orders by `created_at` alone:

```python
.order_by(IssueConversationMessage.created_at)
```

With no tiebreak the order is arbitrary — Postgres may return either row first, and here it returned the assistant's.

**This is a known lesson that never reached this surface.** Sprint 55 batch 3 recorded it as *"assist Q+A share a `created_at`, so any ordering must break the tie"* and fixed it on the **assist** surface. The issue conversation is the sibling caller and kept the bug. Same shape as ISE-686/687, where a backend change was applied to one of three callers.

**The obvious fix is wrong.** `ORDER BY created_at, role` puts `'assistant'` before `'user'` alphabetically, so it would show the answer first *every* time rather than intermittently — turning a flaky bug into a consistent one, while looking like a fix. It needs either an explicit ordering (user → 0, assistant → 1) or a monotonic per-conversation sequence.

Recommend the **sequence column**: it survives a turn that ever produces more than two rows (a tool-call trace, a partial answer followed by a completion), which a role-based CASE does not. `id` cannot be used as the tiebreak — it is `uuid4`, so it carries no order.

**Scope**
- Deterministic ordering for the incident conversation, and a test that asserts it with two rows sharing an identical `created_at` — a test with distinct timestamps proves nothing here and would pass against the current code.
- Check how the assist surface fixed it and reuse that, rather than inventing a second answer to the same question.
- Sweep for the same pattern anywhere else rows are written together and ordered by `created_at` alone — the timeline merges audit rows, and `apply_status_change` writes several in one transaction too.