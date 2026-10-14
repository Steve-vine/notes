---
id: 01M4XTV1YFRRSP8A0E9C11CKE4
created: 2026-10-14T18:29:50.67108Z
updated: 2026-10-14T22:13:21.950189Z
type: task
title: A shared-mailbox review completed by two reviewers in the portal never removes the direct access it flagged
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 957
sprint: s192kdq
comments:
- id: 01M4Y7MATFXZNQAS2XM2P1ZVQJ
  author: Steve Vine
  at: 2026-10-14T22:13:21.871435Z
  text: |-
    Done — PR #952, merged to main. Not on staging yet.

    What changed: when a shared-mailbox review needing two reviewers is completed in the portal, flagged access a person holds directly is now removed through Exchange, the same as when a second person presses Approve removals. Access held through a group still waits for someone to confirm it removed by hand.

    Stranded rows: none on staging (checked 2026-10-14). Production can't be read from here. Once this reaches production, any direct shared-mailbox row already stuck at *approved* would need its removal sent once more. I can do that on request.

    Test: a two-reviewer mailbox review that flags a direct grant now revokes it. The same test fails on the old code.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found while building COM-956 (2026-10-14). A gap from COM-741.

## What happens

A shared-mailbox review can finish in one of two ways:

- **One reviewer submits:** the flagged rows wait for a second person, who presses **Approve removals**. Compass then removes each flagged direct grant through Exchange. This works.
- **Two reviewers submit** (a review needing two attestations): the review completes in the portal and the flagged rows go straight to *approved*. **Nothing is sent to Exchange.** The row sits at *approved* for ever and the person keeps the access. The row also has no **Confirm removed** button, because a direct grant is meant to be Compass's to remove.

So the access the reviewers said should go stays, and the screen reads as if the removal is in hand.

## Fix

The portal's submit path should send flagged direct mailbox rows to the same removal Approve removals uses. Membership rows and (since COM-956) list-sender rows already go that way.

## Notes (technical)

- `api/v1/portal.py`, the submit handler: `ready_ids` keeps only `source in (group, list_sender)`. Add `mailbox_row_is_direct(item)`, as `api/v1/access_recert.py`'s approve-removals does.
- Rows already stranded on staging or prod: find `recert_instance_items` with `source = 'shared_mailbox'`, `removal_state = 'approved'`, no group path, and an account, then re-dispatch them once after the fix. The removal is idempotent, so a grant already gone counts as done.
- Test: a two-attestor shared-mailbox review flags a direct grant, both submit, and the grant is revoked through the fake Exchange. Extend `test_mailbox_watch_recert.py`.

**Done when:** on staging, a shared-mailbox review completed by two reviewers removes the direct access they flagged, and any row already stuck at *approved* has been dealt with.