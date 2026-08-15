---
id: 01M026F74P2SDNH1JGNMDT1P23
created: 2026-08-15T07:51:34.294651Z
updated: 2026-08-15T07:51:34.294651Z
type: task
title: The incident conversation shows answers before questions — no tiebreak on a shared timestamp
assignee: steve
priority: high
task_status: backlog
label: bug
project: 01KX671DATY39VW6GWK3M2T3DN
number: 727
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