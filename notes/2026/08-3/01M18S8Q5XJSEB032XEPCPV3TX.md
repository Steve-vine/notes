---
id: 01M18S8Q5XJSEB032XEPCPV3TX
created: 2026-08-30T07:31:12.701292Z
updated: 2026-08-30T09:46:43.632818Z
type: task
title: A membership change surfaces its group — $select, not $expand
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 521
sprint: sz42uhw
comments:
- id: 01M1910V8ZN5KSNAZEYT8YXQMZ
  author: Steve Vine
  at: 2026-08-30T09:46:43.359144Z
  text: |-
    Shipped — PR #528, merged to main as 68e4dfc and already promoted to staging.

    What landed, as specified:
    - `_GROUP_DELTA_SELECT = f"{_GROUP_SELECT},members"` — a select of its own for the groups delta, so `_GROUP_SELECT` keeps serving the full pass's `/groups` collection read without dragging members back inline.
    - `&$expand=members($select=id)` dropped from `_GROUPS_DELTA_INIT` — unsupported on the group delta, silently ignored.
    - The cheap `$deltaToken=latest` mint restored for groups, matching users and devices; COM-508's enumerate-mint and its comment block reverted.
    - `MIRROR_SELECT_VERSION` → 3, which forces the one full pass that re-mints under the corrected query and reconciles the drift.
    - COM-508's `_report_delta_membership_drift` left untouched.

    Tests assert the mint URL carries `$select=…,members` and no `$expand` — the only part a fake tenant can prove. Real-tenant confirmation is the outstanding half: add a member, wait one pass, check the mirror total moves by one, then check the following full pass reports zero corrections.
assignee: steve
company:
- moneypenny
label:
- bug
priority: high
task_status: review
---
COM-508 diagnosed the right defect and turned the wrong knob, so the defect is still live: a member added to a group in Entra does not reach the mirror until the 24-hour backstop.

Observed on staging 2026-08-30: a user added to `compass-vendormanagers` at 07:08 UTC was still absent after the 07:15 pass. The mirror's membership total sat at exactly 70,795 across 40 consecutive delta passes over 11 hours — every pass green, every pass blind to membership.

## Why COM-508 did not fix it

It added `$expand=members($select=id)` to the groups delta mint. Graph's delta-query contract, for the **user** and **group** resources specifically:

> `$expand` isn't supported.

So Graph ignores it. The re-mint at deploy time worked exactly as designed and produced a link no better than the one it replaced. The enumerate-mint COM-508 introduced — paying a full groups-with-members read to make the token "provably carry" the `$expand` — was buying a guarantee about a parameter that does nothing.

The knob is `$select`:

> If a `$select` query parameter is used, the parameter indicates that the client prefers to only track changes on the properties or relationships specified in the `$select` statement. If a change occurs to a property that isn't selected, the resource for which that property changed doesn't appear in the delta response after a subsequent request.
>
> `$select` also supports **manager** and **members** navigation properties for users and groups respectively. Selecting those properties allows tracking of changes to user's manager and group memberships.

`_GROUP_SELECT` has never carried `members`. Because a `$select` is present and omits it, Compass has been explicitly instructing Entra not to track membership. That dates to COM-316, not to COM-508.

## What changes

Nothing on screen. A membership written in Entra shows up within one pass instead of at the nightly crawl, in both directions — a removal that leaves the mirror over-stating access is the worse half, and the one a "did the new member appear?" check misses.

## Implementation

`tasks/directory_sync.py`:

* Give the groups delta its own select — `_GROUP_DELTA_SELECT = f"{_GROUP_SELECT},members"`. It cannot be folded into `_GROUP_SELECT`, which the full pass's `/groups` collection read at :1656 also uses; that read gets members from the `$batch` edge crawl and must not start dragging them back inline.
* Drop `&$expand=members($select=id)` from `_GROUPS_DELTA_INIT` — unsupported, silently ignored.
* Restore the cheap `$deltaToken=latest` mint for groups, matching users and devices. The overview doc is explicit that state tokens encode `$select`, so the shortcut was always sound for a select; it was only unsound for the `$expand`, which was never supported. This reverts COM-508's enumerate-mint and its comment block.
* `MIRROR_SELECT_VERSION` → 3. The bump is also the repair: it forces one full pass on the next tick, which re-mints under the corrected query and reconciles the drift, rather than waiting for the nightly crawl.

Keep COM-508's `_report_delta_membership_drift` untouched — it is the only thing that would have caught this, it fired correctly at the 20:17 full pass on 2026-08-29, and it is the check that proves this fix landed: after a full pass on the new links, a subsequent full pass should correct nothing.

## Verifying

No fake-tenant test can fail when Graph's contract differs from the one Compass was written against — that is exactly how COM-508 shipped green. Assert what is assertable (the mint URL carries `$select=...,members` and no `$expand`), then confirm against the real tenant: add a member, wait one pass, check the mirror total moves by one, and check the next full pass reports zero corrections.
