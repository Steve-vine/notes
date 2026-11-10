---
id: 01M73QA5Z6XPW6WZQ29GD1ZZ6D
created: 2026-11-10T21:55:02.246648Z
updated: 2026-11-10T23:46:23.382991Z
type: task
title: A feed run that would change far more than usual is held for review — a misread field can never close every vulnerability or mark every resource gone at once
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1701
sprint: sep79bz
blocked_by:
- 01M73Q911761481VZ9JRJ6MHJ1
- 01M73Q9CWJM5FTKEC82YET8PH4
- 01M73Q9S96V19DX5JNC9G9GYXP
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of ADR 0145 (COM-1695). A mistake in an evidence check files a bad page. A mistake in a feed changes registers. If the service renames the field that says "solved", every open vulnerability could close in one run. Feeds get ADR 0142 §5's hold, plus a hold on what the run would *do*.

**Chain:** on the chain — migration + API

## What the person sees

- Before a run changes anything, Compass works out what it would do. The run is **held for review**, with nothing applied, when:
  - **the shape changed:** fields appear or disappear, or a mapped slot comes back empty on most items when it used to be filled (as ADR 0142 §5);
  - **it would close or mark gone a large share** of what's open from this feed: more than a quarter, and at least 10 records (my call; a per-company setting beside ADR 0142's);
  - **it would add far more than usual:** more than half as many again as are open from this feed, and at least 50 records (my call);
  - **the read came back empty** where it wasn't before.
- A held run shows on the feed with what it *would* have done (e.g. "would close 212 of 230 open vulnerabilities") and a sample. Someone with the area's right gets one action:
  - **Apply** runs it as read and accepts the new shape;
  - **Discard** drops it, and the next run is judged against the old shape.
- While a run is held, later runs are held behind it (one action, not one per run). If the feed has been held for 7 days, its owner and the area's managers get a reminder (my call).
- A feed's first run after approval is never held for size. The approver has just seen its preview.

## Done when

- Each hold reason is tested with a fake service against real Postgres: nothing applied, one action, Apply applies exactly what was held, Discard applies nothing.
- The thresholds are per company, with the defaults above, on the same settings card as ADR 0142's hold.
- The feed's history shows held, applied and discarded runs, and who decided.
- Activity records Apply and Discard as the person's own acts.

## Notes

- Compute the area's changes in a dry run first (each area's `apply` grows a `plan` step), compare, then apply in the same transaction.
- Reuse `core/collection/hold.py` and `shape.py`. Actions follow ADR 0137: one per held feed.