---
id: 01M4DWM7ZEP6Q99PZ4KSCQG3RG
created: 2026-10-08T13:53:13.710992Z
updated: 2026-10-08T15:31:05.360819Z
type: task
title: 'Validation tab: every entry names the person — none shows an ID where Compass knows the name'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 870
sprint: sme8esk
comments:
- id: 01M4E27AVCXDKCHN0RYNR1ZR4G
  author: Steve Vine
  at: 2026-10-08T15:31:02.122967Z
  text: |-
    Done — PR #869, merged to main 2026-10-08. Not yet on staging (deploys with the rest of the sprint).

    Cause, confirmed and reproduced in a test: a routine sync is a delta, and a delta hands detection only the objects that changed in that pass. A membership change surfaces the group, not the person — the person hasn't changed — so their name was never to hand and the entry was written with their id. The nightly full crawl has everybody's name, which is why only some entries were affected. (The earlier guess — an account created and added close together — was wrong.)

    What changed:
    - New entries take the name from the mirror when the pass didn't fetch it.
    - Every entry, old ones included, is named from the mirror when it is read. Nothing stored was rewritten, so there is no repair to run: the Charlie Jones entry will read correctly as soon as this is deployed.
    - A rename shows. Somebody Compass has no record of reads "An account Compass has no record of (46d3cf35…)".
    - Searching recorded changes matches the name an entry now shows. The to-do queue uses the same names.
    - Side fix: the group filter on the tab showed the whole sentence for a "removed from" entry; it now shows the group's name.

    To check on staging after deploy (done-when items not yet verified there): the Charlie Jones entry; and a scan of the tab for any other bare IDs. Devices and applications are resolved where an entry names one, but no entry of that kind was available to test against.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found by Steve testing access control on staging, 2026-10-08 (`4131ac79`): "On the Validation tab there are still some entries that show IDs rather than names."

## What happened

An entry on Access Control ▸ Validation reads:

> 46d3cf35-3967-40c2-913d-d9ac6b52d95f added to Kora SSO - UK Production

It should read **Charlie Jones added to Kora SSO - UK Production**.

"Still" — some entries were fixed before; some remain.

## What is known (checked on staging, 2026-10-08)

- **Compass knows who this is.** `46d3cf35-…` is a person in the mirror: Charlie Jones, an Entra account (their record id and Entra id are the same value), not gone from the directory. So this is not "somebody Compass has no record of" — the name is there and isn't being used.
- **The entry's text is stored, not looked up.** The screen takes the whole sentence from the entry (`item.object_name`) — `access/ValidationPage.tsx:236` even recovers the group's name by splitting it on " added to ". Whatever name was available when the entry was written is what shows for ever.

## Likely cause — NOT confirmed

The entry was written at a moment when Compass had the membership but not yet the person's name, fell back to the ID, and nothing refreshes it afterwards. The obvious way for that to happen: an account is created and put in a group close together, and the sync meets the membership before (or in the same pass as) the person's own record.

This was not traced in the code — the search for where the backend composes the entry's name was blocked in the session that logged this. **Start by finding where `object_name` is written** (the unrequested-change detection in `tasks/directory_sync.py` — there is a comment near line 3611 about attributing "Ada was added to Finance" — and `core/unrequested_watch.py`), and check on staging when this entry was created against when Charlie Jones's record was.

## Fix

Two halves; the second matters even if the first is perfect.

1. **Don't freeze a name into the entry.** Keep the person's and the group's ids on the entry (the group's is there already — `item.group_id`) and resolve names when the list is read, falling back to the stored text only for someone Compass genuinely has no record of. The frontend then stops splitting a sentence to find the group. A principal can be a person, a group, a device, a service principal or a mail contact — resolve each kind.
2. **Existing entries.** Either resolving at read time fixes them for free (preferred), or a one-off repair re-names stored entries whose subject is now known. Not a migration that rewrites text if (1) makes it unnecessary.

If a principal truly can't be named, say what it is — "An account Compass has no record of (46d3cf35…)" — rather than a bare ID that looks like a bug.

## Done when

- [ ] The Charlie Jones entry on staging reads with the name.
- [ ] No entry on the Validation tab on staging shows a bare ID for a principal the mirror knows — checked across people, groups, devices and service principals, not just this one.
- [ ] A person created and added to a group in the same sync pass produces an entry with their name (test).
- [ ] A person renamed after the entry was written shows their current name.
- [ ] A principal Compass has no record of reads as such, with the ID, not as a bare ID.
- [ ] The cause is written up here once confirmed.