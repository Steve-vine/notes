---
id: 01M3H6ZM54J5P8M4GKE43TFGNS
created: 2026-09-27T10:36:13.860186Z
updated: 2026-09-27T17:05:22.517048Z
type: task
title: Changes made directly in AD are spotted straight away, and on-premises-only groups can be reviewed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 782
sprint: sme8esk
blocked_by:
- 01M3H6Y4FBYRVYEAG70C9ASF63
- 01M3H6YPXKZTV2DX50WBS58NBF
comments:
- id: 01M3HX81F9QAPNZHESRTC3GF1D
  author: Steve Vine
  at: 2026-09-27T17:05:18.313651Z
  text: |-
    Done — PR #792.

    - Changes made in AD show up on the next AD read, a few minutes at most, and are reported once.
    - An account only AD holds that someone disables or deletes by hand is raised as an unprocessed leaver, the same as one disabled in Entra. Accounts Entra also holds are still reported by the Entra side, so nothing is reported twice.
    - Where an unrequested change is to an AD-only object, "who made it" reads "Made in AD — who made it isn't recorded", not "Actor unavailable". AD doesn't keep that; Entra's audit log does.
    - A group that only exists in AD can be put in an access review like any other, and removals from it are made in AD.

    Tests: a hand-disabled AD-only account becomes an unprocessed leaver with the AD line, a review of an AD-only group captures its members, and a UI test covers the actor line.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Part of the on-premises AD sprint (ADR in COM-773).

## What people see

- **Unrequested changes.** Someone adding a person to an on-premises group in AD Users and Computers shows up on Validation **within minutes**, read from AD, not after Entra's sync. Groups that never reach Entra are watched too. In hybrid, the same change is reported **once**, not once from AD and again from Entra.
- **The watch switches** (COM-771) cover AD objects in the same way.
- **Unprocessed leavers.** An account disabled in AD by hand, with no leaver raised, is recognised like one disabled in Entra.
- **Reviews** (recertification) can include **on-premises-only groups and lists**. Removals at review are made in AD by Compass (COM-779), or become a to-do outside the managed OUs.
- **Who made a change.** AD doesn't record this where Compass can read it, so an AD change says *"made in AD — who isn't recorded"*, where an Entra one names the person from the audit log.

## Notes (technical)

- Detection today runs over **raw Graph payloads** (`raw_users` / `raw_groups` in `_detect_unrequested`, `_detect_unprocessed_leavers`). Generalise it to changes on the combined record, fed by either read.
- **Deduplication.** Keyed on (record, change, direction), with the ledger match (`_requested_recently`) done on the combined record.
- **Recert.** `tasks/recert.py` snapshots `DirectoryGroupMember` joined to `DirectoryUser`. Check that on-premises-only groups are offered by schedules and that the snapshot includes them.
- **Actor.** Reading the DCs' Security event log (4728/4729) is out of scope; note it as a possible follow-up.

**Done when:** on staging, a membership added by hand in AD appears on Validation within one AD read and does not appear a second time after the Entra sync. A review of an on-premises-only group opens, and its removal is made in AD.