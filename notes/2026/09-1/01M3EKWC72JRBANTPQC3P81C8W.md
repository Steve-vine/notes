---
id: 01M3EKWC72JRBANTPQC3P81C8W
created: 2026-09-26T10:23:55.618704Z
updated: 2026-09-26T13:44:23.213856Z
type: task
title: Lists are recertified and watched like groups, and undoing a change on an on-premises list or group is a to-do
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 765
sprint: ss8v7d0
blocked_by:
- 01M3EKW1410EHV5F7PWDD2QGYP
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Stacks on COM-764 (a role can grant a list).

Once a role can grant a list, the rest of Access Control's governance has to cover lists as well: recertification, unrequested-change watching, and reversal. Most of it should follow from COM-764 widening the one "governable" rule. This task proves each surface does, and fixes the ones that don't.

## What people see

- **Recertification.** A campaign can include list memberships. The reviewer sees them beside group memberships for each person, with the type pill, and *Remove* works the same way. Removing from a cloud list is done by Compass through Exchange. Removing from an on-premises list or group becomes a manual line (COM-762) raised from the campaign, and the reviewer's decision stands as made.
- **Unrequested changes.** Someone added to a managed list outside Compass shows up for review exactly as a group change does. External contacts are ignored.
- **Reversal.** *Reverse* on a cloud list is done by Compass. *Reverse* on an **on-premises** list or group, which today would fail at the write, becomes a manual line. It shows **Manual — in AD** until the refresh confirms it.

## Notes

- Check each surface actually reads the widened rule and not a local "security only" test: recert scope, `api/v1/unrequested_changes.py` (its reversibility wording mentions group kinds), and coverage proposals.
- The per-subject trail records reversal and recert removals on lists with the same change kinds as groups.

**Done when:** a recert campaign on staging lists a person's cloud and on-premises list memberships, and removing one of each produces an Exchange removal and a to-do respectively. An out-of-band add to a managed on-premises list, reversed, produces a to-do that closes once AD has synced.