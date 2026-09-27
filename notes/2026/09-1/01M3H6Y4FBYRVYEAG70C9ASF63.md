---
id: 01M3H6Y4FBYRVYEAG70C9ASF63
created: 2026-09-27T10:35:25.035262Z
updated: 2026-09-27T11:05:03.705582Z
type: task
title: Compass reads Active Directory — users, groups, lists, nesting and OUs; in hybrid each person appears once
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 777
sprint: sme8esk
blocked_by:
- 01M3H6XAKXQME21MFM35THFPDH
- 01M3H6XM5V2NG2ZRJF56WRYAJ9
assignee: steve
label:
- feature
priority: high
task_status: backlog
---
Part of the on-premises AD sprint (ADR in COM-773). Compass can see AD but changes nothing in it yet.

## What people see

- Compass reads AD on the same rhythm as Entra: what has changed every few minutes, and everything again nightly. It reads **users, security groups, distribution lists, group nesting**, and the **OU** each object sits in.
- **In hybrid, an AD account and its Entra copy are one person** (and likewise one group). Groups that never leave AD (not synced) now appear in Compass for the first time, carrying the **On-premises** pill.
- Access Control lists and pages show AD objects like any other. A user's and a group's page says where it lives in AD (its OU).
- The AD card shows counts and when AD was last read.

**Out of scope:** AD computer objects (the Devices tab stays Entra's), GPOs and contacts.

## Notes (technical)

- **Incremental read.** Use `uSNChanged` against one DC: track `highestCommittedUSN` and the DC's `invocationId`, and do a full read if either jumps or the DC changes. DirSync is the alternative, but it needs Replicating Directory Changes, which is more than we should ask for. Use paged searches (1000).
- **Deletions.** Mark `vanished_at` from the full pass diff, or via Show Deleted — decide which.
- **Membership.** Read the `member` attribute with range retrieval (`member;range=`) for large groups. Primary group membership (`primaryGroupID`, e.g. Domain Users) is not in `member`, so decide whether to show it (probably not governable). Nesting goes into the existing nested-member computation.
- **Classification.** `groupType` bits (security vs distribution, scope) plus `mail` give security / distribution / mail-enabled security.
- **Matching.** objectGUID or ms-DS-ConsistencyGuid ↔ `onPremisesImmutableId` (the anchors from COM-775). A match joins the Entra record; no match creates an AD-only record.
- **Scope.** The whole domain is read, while writes stay limited to managed OUs (COM-778).
- **Sequencing.** Provenance, `manual_steps.observe` and detection must run over the combined view. Decide whether the AD read is a pass inside `sync_directory` or its own task, and how they are ordered. It runs on the `default` queue.
- Integration tests use the Samba DC from COM-776.

**Done when:** on staging, on-premises-only groups appear with the pill. A synced user is one record, not two. Counts match what AD reports. Nothing already in Compass is duplicated or loses its history.