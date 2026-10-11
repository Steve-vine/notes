---
id: 01M4N6W420BC2GHDKN37DATG80
created: 2026-10-11T10:06:58.624941Z
updated: 2026-10-11T10:38:54.337045Z
type: task
title: An AWS account whose organisation blocks some regions says so once, names them, and offers to stop reading them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 911
sprint: svsqcj9
comments:
- id: 01M4N8PJ3DN0ETDM6TTZCQA84J
  author: Steve Vine
  at: 2026-10-11T10:38:53.545695Z
  text: |-
    Merged to main (PR #909, 2026-10-11). Not on staging yet: staging is promoted when Steve says.

    What to look at, under Inventory ▸ Settings ▸ AWS accounts, after the account has been read again (Read now, or the next six-hourly pass):
    - The ten orange warnings on the account are gone.
    - In their place is one line: "8 regions refuse every request and were not read: …", naming them, saying this is usually an organisation rule that blocks regions you do not use, and that nothing is wrong with the user.
    - Beside it, "Stop reading them". It sets the account to read only the regions that answered, and the line goes at once.

    Behaviour worth knowing:
    - Until the account is read again after the deploy, the old warnings are still shown: they are what the last read recorded.
    - After "Stop reading them" the account reads a fixed list of regions. If a new region comes into use later, add it under Edit.
    - A kind that is refused in some regions where other kinds are read still gets its own warning, and it now names the regions.
    - If every region refuses everything, that is still reported as the policy, as before.
    - Nothing found earlier in a refused region is removed or marked gone.

    Not confirmed: that the cause on this account is an organisation rule. Compass sees only that every request is refused in those regions and none is in the others; the wording says "usually" for that reason.

    Technical: migration 0243 (aws_connections.sync_blocked_regions). A region counts as blocked when every regional kind that tried it was denied and at least one other region answered. Decided in core/discovery/sync.py once every kind has been read.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Sprint 67, Inventory expansion. Found on staging 2026-10-11, the first read of a real AWS account (COM-883, COM-886, COM-903).

## What happened

The account was read and 46 resources found. But every kind except storage buckets showed an orange warning: "The user may not read servers — update the user's policy from the current template (8 of 20 regions)". Ten kinds, ten copies.

The advice is wrong. The same user read the same kinds in the other 12 regions, and the shipped policy has no region condition, so the policy cannot be why 8 regions refuse. Those regions are refused by something above the user: an organisation rule (service control policy) that blocks regions the organisation does not use. Updating the user's policy changes nothing, and the warning never says which regions.

## What people should see

- **One line on the account, not one per kind**: "8 regions refuse every request and were not read: ap-northeast-1, … This is usually an organisation rule that blocks regions you do not use."
- **A button, "Stop reading them"**, which sets the account's regions to the ones that answered. The line then goes away at the next read.
- **Each kind is judged on the regions that do answer.** A kind read cleanly everywhere else is shown as read, with no warning.
- **A kind refused where other kinds are read** still says the user or role lacks the permission, as now, and now names the regions.
- **If every region refuses everything**, nothing has changed: that is the policy, and the existing message is right.

## Notes (technical)

- A region is *blocked* when every regional reader that tried it was denied there and at least one other region answered something. Decided per read in `core/discovery/sync.py`, after all kinds have been read.
- Store the blocked regions on the connection (new nullable JSONB column, new migration) and return them on the connection out. Nothing in a blocked region is swept or marked gone: a refused read is not an empty one (ADR 0099 §9).
- "Stop reading them" is the existing update route with `regions` set; no new route.
- Tests: integration for blocked regions (one line, kinds clean), a single kind refused in one region (still that kind's warning, region named), everything refused everywhere (unchanged). Vitest for the line and the button.

**Done when:** on staging, the account read on 2026-10-11 shows one line naming its eight blocked regions, the kinds show no warning, and Stop reading them clears it.