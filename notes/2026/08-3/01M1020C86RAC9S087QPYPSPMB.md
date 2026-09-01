---
id: 01M1020C86RAC9S087QPYPSPMB
created: 2026-08-26T22:10:46.66282Z
updated: 2026-09-01T13:55:53.502173Z
type: task
title: Detection watches every group — in two lanes, so the queue still means something
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 452
sprint: snq23hz
comments:
- id: 01M12WXDGB2RQY60VNZVMHJPSY
  author: Steve Vine
  at: 2026-08-28T00:39:30.059677Z
  text: |-
    Done — merged to main as 123748e (PR #468). CI green (one `npm audit` "Exit handler never called" on deps-scan; rerun clean — infrastructure).

    **Every membership change in the tenant is recorded now.** The managed-only guard is gone; what replaces it is a **lane, not a filter**. `needs_validation` keeps its behaviour exactly (managed groups, anything privileged, accounts created or disabled); `for_information` is unmanaged-group membership — recorded, searchable, filterable, groupable, and never counted, nagged about or mailed.

    **A privileged group is never in the quiet lane.** Role-assignable groups are deliberately absent from the matrix (ADR 0061 §5), so managed-ness *alone* would have put the most consequential change of all where nobody looks. An unmanaged item is tenant-wide (`company_id` NULL) — no company's matrix owns it, the same answer creations already give.

    **Keeping them apart is enforced, not trusted.** `core/actions/access.py` filters on the lane, so the action list, badge and every mail derived from it see the queue only. `GET /unrequested-changes` **defaults to `needs_validation`**: the informational lane is far the larger, and a caller asking for "the queue" must never silently receive it.

    **On the volume risk you flagged**, two answers. Pre-existing memberships are not changes — `added_pairs` is `desired - existing`, and the first pass is guarded by `pre_populated` anyway. The one that *would* have bitten: a group newly **mirrored** rather than newly **created** brings its whole existing membership with it, and every row would read as a change. That is the same case `group_created` already guards with `createdDateTime`; widening to every group is what makes it matter, so the guard now applies to membership too. One backfilled group would otherwise have been thousands of items nobody made. Tested.

    **Nothing above raises drift** — verified rather than assumed. Executed exceptions and privileged grants have `access_changes` rows, so `_requested_recently` recognises them; there is a test asserting an executed exception raises nothing.

    Frontend: a "Recorded changes" section below the queue — search, filter by group, view the group, and **no Decide button**, because none is owed.

    One thing worth carrying forward: **`op.add_column` does not create an enum type the way `create_table` does.** The first version of migration 0132 assumed it did; a fresh-DB CI run would have passed either way, and only the integration suite (which actually migrates) caught it. The type is now created explicitly — the counterpart of the `create_type=False` rule for reusing one.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Stacks on COM-451. Part 6 of COM-446, and the second decision it reverses.

Out-of-band detection watches membership on **managed groups only** — `_detect_unrequested` skips any pair whose group no active business role maps. Everything else is invisible: change membership on an unmapped group in Entra and Compass mirrors the fact and says nothing.

## What changes for the reader

**Every membership change in the tenant is recorded** — but only the ones that need a decision ask for one.

## Scope

**Detection widens to every mirrored group.** Drop the managed-only guard on membership items.

**Two lanes, because of what that does to the volume.** ADR 0045 narrowed this deliberately, on the grounds that diffing every group would drown the validation queue — and that risk is real and has not gone away. In a tenant of this size unmanaged churn will heavily outnumber governed change. The answer is to separate what needs an answer from what needs to be visible, not to narrow it again:

- **Needs validation** — managed groups, anything privileged, accounts created or disabled. Adopt or flag for reversal, in the queue engineers already work. Unchanged behaviour.
- **For information** — unmanaged group membership. Recorded, searchable, filterable and groupable by group; never nagging, never counted in the queue badge.

**Nothing above raises drift.** COM-449's exceptions and COM-451's privileged grants are executed changes with ledger entries, so `_requested_recently` should already recognise them. Verify it rather than assume it — an exception path that lands in the validation queue as unrequested would be worse than not having built it.

## Watch for

Item volume on the first sync after deploy. Every pre-existing membership is not a *change*, so it should raise nothing — but the guard that makes that true is worth a deliberate look before this goes anywhere near the tenant.

## Tests

Integration tests: an unmanaged membership change lands in the information lane; a managed one still lands in the validation lane; an executed exception raises nothing; the queue badge counts only the validation lane; a re-run creates nothing new.