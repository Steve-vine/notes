---
id: 01M3EKWC72JRBANTPQC3P81C8W
created: 2026-09-26T10:23:55.618704Z
updated: 2026-09-26T14:36:49.779002Z
type: task
title: Lists are recertified and watched like groups, and undoing a change on an on-premises list or group is a to-do
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 765
sprint: ss8v7d0
blocked_by:
- 01M3EKW1410EHV5F7PWDD2QGYP
comments:
- id: 01M3F2BCZYZ5AWWX0NK1XQTTSX
  author: Steve Vine
  at: 2026-09-26T14:36:47.997874Z
  text: |-
    Done — PR #776, merged to main (f8787d6).

    - **Recertification:** a flagged membership of a group or list synced from AD used to be a refused Graph write. It is now a to-do: *Remove Grace from 1 on-premises group in AD — flagged at review*, on Actions, linking to the review. The review row reads "to be removed in on-premises AD" and shows the step with its *I've done this* / *Can't do this…* buttons. It closes itself when Compass sees the membership gone. *Can't do this* fails the row, giving the reason. A flagged membership of a **cloud list** is removed through Exchange. Both kinds of review are covered (campaigns and scheduled reviews).
    - **Watching** needed no change. Detection already watches every group Compass mirrors, lists included, and a change to a managed list needs a decision just like a group does. External contacts are never flagged.
    - **Reverse** needed no new path. It links a corrective request, and since COM-762/764 that request removes a cloud list through Exchange and turns an on-premises group or list into a to-do. A test proves it end to end.
    - A to-do's buttons now work the same wherever it came from (request or review). The request page and both review screens share one panel.

    Not done: the review row doesn't show a *list* badge next to a list's name. The row only records group names, so adding the badge needs another field.

    Smoke test: run a recertification over a role that maps an **On-premises** group and flag someone. After completion, the row reads "to be removed in on-premises AD" and there's a to-do on Actions. Remove the person in AD; after the next sync the row reads Removed.

    Not deployed yet: staging goes out once COM-766 merges.
assignee: steve
label:
- feature
priority: medium
task_status: review
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