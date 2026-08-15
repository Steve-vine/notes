---
id: 01M02K8MZMXYH3QJ445FBESBH2
created: 2026-08-15T11:35:10.580051Z
updated: 2026-08-15T17:16:57.466083Z
type: task
title: The estate calls a resolved incident open — it only excludes closed
project: 01KX671DATY39VW6GWK3M2T3DN
number: 734
sprint: sevhjex
comments:
- id: 01M02SG5FG2PWPJBVEN57ZGX35
  author: Steve Vine
  at: 2026-08-15T13:24:08.304572Z
  text: |-
    Done — PR #676, merged to main 2026-08-15.

    **The fix.** `models.TERMINAL_ISSUE_STATUSES = ("resolved", "dismissed", "closed")` is now the one platform terminal set. The estate graph overlay (`signal_state_for_entities`) and the dashboard component tiles (`component_states`) both test against it instead of `Issue.status != "closed"`.

    **What was left alone, deliberately, and now says so in a comment at each site:**
    - **promotion** (two call sites) keeps `!= "closed"`. It is not asking about liveness — it is asking what a firing signal reattaches to (ISE-120). Narrowing it would make every recurrence open a duplicate incident instead of reactivating.
    - **`findings._live_incident_ids`** keeps `!= "closed"`. It powers the signal detail's "View incident" button (ISE-156) — a navigation link that must keep working after the incident is resolved, which is precisely when an operator wants to follow it.
    - **`learning._TERMINAL_STATUSES`** stays `("resolved", "closed")`. As the task warned, it drops `dismissed` on purpose; widening it would have started distilling lessons from incidents an operator explicitly threw away. Commented so the next sweep does not "unify" it.
    - **`recall._RESOLVED_STATUSES`** was a byte-identical duplicate of the new constant, so it now reads the shared one — the "fourth list" the task asked not to write.

    **Tests** (all three verified to fail against the old filter by flipping it back):
    - `resolved`, `dismissed` and `closed` each stop lighting a node **while the signal stays present** — the real reported case, and what makes the incident rather than the signal the thing under test.
    - `reactivated` still lights it. That status is a resolved incident whose signal genuinely came back (ISE-114), and it would have been easy to widen the set by one status too many.
    - A tile stays red on its present signal but no longer offers to open work that finished days ago.

    **Note for smoke testing.** On `mpwxdc01` this only half-clears the view on its own: ISE-733 is what leaves the *signal* reading as live. Both need to be on staging before the host looks right.
assignee: steve
label:
- bug
priority: high
task_status: done
tech: null
---
The estate view showed an **open incident** on host `mpwxdc01`. The incident (IN-1333) was `resolved`.

**Cause.** `signal_state_for_entities` (`entities.py:1587`):

```python
select(Issue).where(Issue.correlation_key.in_(keys), Issue.status != "closed")
```

`resolved` and `dismissed` are both terminal and neither is `closed`, so both count toward an entity's live incident state. Only an explicitly archived incident drops out — and `closed` is a step an operator has to take deliberately after resolving, which most never do. So in practice nearly every incident ISE has ever finished still counts as open on the estate.

**Why "not closed" is the wrong test here.** It is defensible on a queue, where a resolved incident is still recent work worth seeing. On the estate it answers a different question — *is something wrong with this thing right now* — and a resolved incident is the definition of no. Compare `apply_status_change`, where `resolved`, `dismissed` and `closed` are treated alike as the terminal set that cascades to signals, and `VALID_TRANSITIONS`, where `resolved` can only go to `closed`.

**Scope**
- Exclude the terminal statuses — `resolved`, `dismissed`, `closed` — from the estate's live-incident state, rather than `closed` alone.
- Reuse the terminal set that already exists rather than writing a fourth list. `_TERMINAL_STATUSES = ("resolved", "closed")` in `learning.py` is a *different* set again (it excludes `dismissed` deliberately, because a dismissal has nothing to learn from) — so check which definition each caller actually wants before unifying, or the fix will quietly change learning behaviour.
- Sweep the other consumers of incident status for the same `!= "closed"` shortcut; wherever the question is "is this live", the test should be against the terminal set.
- A dismissed incident is worth a thought of its own: sticky by design, so it should certainly not colour an entity.

**Compounds with ISE-733.** That one leaves the *signal* looking live; this one leaves the *incident* looking open. On `mpwxdc01` both fired at once, which is why the entity showed an active alert **and** an open incident for work that finished days earlier. Either alone is misleading; together they make the estate view untrustworthy for exactly the question it exists to answer.

Found 2026-08-15.