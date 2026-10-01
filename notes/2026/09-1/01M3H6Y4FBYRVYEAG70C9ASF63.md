---
id: 01M3H6Y4FBYRVYEAG70C9ASF63
created: 2026-09-27T10:35:25.035262Z
updated: 2026-10-01T07:00:49.801698Z
type: task
title: Compass reads Active Directory — users, groups, lists, nesting and OUs; in hybrid each person appears once
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 777
sprint: sme8esk
blocked_by:
- 01M3H6XAKXQME21MFM35THFPDH
- 01M3H6XM5V2NG2ZRJF56WRYAJ9
comments:
- id: 01M3HN6416VZT0M8VJZAVEF5SP
  author: Steve Vine
  at: 2026-09-27T14:44:26.790427Z
  text: |-
    Done: PR #787, merged to main (1b00482).

    **Compass now reads AD** while the directory setup is *AD only* or *Hybrid* and the AD card is filled in. Every 5 minutes it reads only what changed; every night (and whenever the domain controller changes or is restored) it reads everything.

    **What you'll see:**
    - **Hybrid:** people and groups Compass already knows from Entra stay one record, and gain their AD location. Groups that exist only in AD appear for the first time, with the **On-premises** pill.
    - **User and group details** show **Location in AD** (the OU). The **Object ID** row now shows Entra's ID (not Compass's own key) and is hidden for objects Entra doesn't hold.
    - **The AD card** gains **What Compass has read**: when, from which domain controller, how many users, groups and OUs, any error, and **Read now**.
    - **Group membership** of groups read from AD now comes from AD, not from Entra's copy half an hour later.
    - **Changes seen immediately:** a person's to-do done by hand in AD is confirmed as soon as AD shows it. A change nobody requested is raised on Validation within minutes. The very first read is a baseline, so it raises nothing.
    - **Deletions:** an object deleted in AD is marked gone by the nightly read, but only if AD alone holds it. For synced objects, Entra decides, as before.

    **Staging:** the Twingate sidecar for your `compass-twingate` Secret is added to the worker in `values-staging.yaml`, so it goes out with this batch's deploy.

    **Change from plan:** the CI tests use an in-memory LDAP directory rather than a Samba domain controller in a container. It needs no privileged containers or registry changes, and still exercises real LDAP behaviour: binary GUIDs and SIDs, update sequence numbers, and members by DN.

    **Smoke test** (after the batch deploy):
    1. Admin ▸ Integrations: set *Hybrid*, fill in the AD card, and **Test connection** (this proves the Twingate route and DNS).
    2. **Read now**. The card should show counts close to what AD holds.
    3. Access Control ▸ Groups: AD-only groups appear with the On-premises pill.
    4. A synced person's details show one record with **Location in AD**.
assignee: steve
label:
- feature
priority: high
task_status: done
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