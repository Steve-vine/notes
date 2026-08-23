---
id: 01M0QY2QVGJ1R053EXSH58W7EH
created: 2026-08-23T18:28:14.320901Z
updated: 2026-08-23T18:28:14.320901Z
type: task
title: Actor lookback is 2h but detection can be a day late — widen the window, and stop saying "lag"
task_status: active
label: bug
assignee: steve
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 396
---
Second fix-forward for COM-390, found by Steve on the staging Validation tab: items stuck on *"Actor not yet available — the directory audit log lags behind the change"* days after the change.

**It is not lag.** All four unattributed items have a perfectly good audit entry. `_ACTOR_LOOKBACK` is **2 hours**, on the assumption that "the sync notices within one 15-minute tick, so the change is always earlier [by minutes]". That assumption is wrong:

| item | observed_at | audit entry | gap |
|---|---|---|---|
| Add group `30b37f8b` | 19 Aug 01:52 | 18 Aug 09:09 | 16h 42m |
| Add group `84785192` | 19 Aug 01:52 | 18 Aug 14:40 | 11h 12m |
| Add user `67a2b636` | 20 Aug 17:11 | 20 Aug 14:48 | 2h 23m |
| Remove member `b57cd6e3` | 21 Aug 17:18 | 21 Aug 14:47 | 2h 31m |

Both `group_created` items were observed at **exactly the same second** — the nightly full crawl. A newly created group is not surfaced by the delta pass (only membership changes re-surface a group), so detection of a creation can be a **whole day** behind the change. Even a user creation beat the 2h window.

- [ ] `_ACTOR_LOOKBACK` 2h → **48h**, matching `_LEDGER_LOOKBACK` — the window out-of-band detection itself already trusts for deciding a change is recent. Attribution should look back at least as far as detection reaches.
- [ ] Keep the 5-minute **forward** slack: `observed_at` is when the sync saw the state, so a change stamped after it cannot be the cause. Only clock skew justifies any forward allowance.
- [ ] **Give up at 24h, not 7 days.** The search window is anchored to `observed_at` and never moves, so once audit ingestion has caught up (minutes to hours) a search that fails will always fail. Retrying for a week is pointless work *and* it is what leaves an item sitting in the ambiguous "not yet" state for days.
- [ ] Re-word the pending state so it stops over-promising: it should read as "we have not found it yet", not as a claim about audit-log latency.

Query cost is unaffected — results are filtered to one object id (COM-395), so 48h of one object's history is a handful of rows.

Refs: COM-390 (the window), COM-395 (the filtered query), COM-391 (the copy), COM-316 (why a created group only surfaces on the full crawl).