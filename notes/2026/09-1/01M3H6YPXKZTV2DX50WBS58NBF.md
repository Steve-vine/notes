---
id: 01M3H6YPXKZTV2DX50WBS58NBF
created: 2026-09-27T10:35:43.923459Z
updated: 2026-10-01T07:00:51.180472Z
type: task
title: Membership of on-premises groups and lists is changed in AD by Compass — the to-do only when it can't
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 779
sprint: sme8esk
blocked_by:
- 01M3H6YBYE6S45M1W17WDMRA0W
comments:
- id: 01M3HPFD0X9TC7F6CJYPZGKW2C
  author: Steve Vine
  at: 2026-09-27T15:06:59.485045Z
  text: |-
    Done: PR #789, merged to main (22cac20).

    **Membership of on-premises groups and lists inside a managed OU is now changed in AD by Compass.** This covers role grants, movers, leavers, ad-hoc membership requests, a role edit's catch-up, and removals at review. It works for a synced group, a group only AD holds, and an on-premises distribution list alike.
    - The request shows **Applied**, and the group's page updates straight away.
    - In hybrid, Entra's copy follows at the next sync. That later change isn't reported as unrequested, because Compass takes the group's membership from AD while it reads AD.
    - Nothing about these groups is sent to Microsoft 365 or Exchange any more.

    **Your three-way rule:**
    - **Not set up** (AD not configured, or the group is outside the managed OUs): the to-do, exactly as today.
    - **Something broke** (e.g. the domain controller can't be reached): the person shows **Failed** with AD's reason and a **Retry**; no to-do. The first "can't reach" is remembered for the rest of the run, so a joiner with ten groups doesn't wait out ten timeouts.
    - **Not allowed:** refused when raised, as before.

    Someone who has no AD account (a cloud-only account) can't be put in an AD group. The change fails and says so.

    **Smoke test** (after the batch deploy):
    1. With an OU ticked, map an on-premises group from inside it to a role.
    2. Raise and approve a membership change (or a joiner) for someone.
    3. The group gains them in AD Users and Computers, the group page shows them at once, and there is no to-do.
    4. A group outside the ticked OUs still gives a to-do.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Part of the on-premises AD sprint (ADR in COM-773).

## What people see

- The following changes, on an **on-premises group or distribution list inside a managed OU**, are now **carried out by Compass in AD**:
  - role grants
  - movers
  - leavers' group removals
  - ad-hoc membership requests
  - a role edit's catch-up
  - removals at review
- The request shows **Applied**, exactly like a cloud group.
- **The rule for what Compass can't do** (COM-773):
  - **Not set up**: AD isn't configured, or the group is outside the managed OUs (COM-778). It becomes the ADR 0079 to-do.
  - **Something broke**: AD is set up but the write fails. The person shows **Failed** with the reason and a **Retry**.
  - **Not allowed**: refused when the request is raised, as today.
- The group's page updates straight away. In hybrid, the Entra copy follows at the next sync with nothing for anyone to do, and that later change is **not** raised as an unrequested change.
- The boundary is unchanged: Compass writes only to a group or list that is governable today (ADR 0061/0080), checked again at the write.

## Notes (technical)

- **Branch points** in `tasks/access_execute.py`: `_grant_or_step`, `_revoke_or_step`, `_exception_join_or_step`, `_exception_leave_or_step`, and `_recert_*_remove`. COM-778's "managed in AD" predicate routes before the write, and the AD write goes in front of `manual_steps.raise_*`. An LDAP error at the write fails the subject (the `GraphError` path) and never raises a step.
- **The write.** An LDAP modify add/delete on the group's `member` attribute (the person's DN). Treat "already a member" and "not a member" as success. Read current membership live from AD, not Graph.
- **On-premises lists.** Today, when Exchange reports a list as dir-synced, the change becomes a step. Such a list now goes to AD instead.
- **Ledger.** Write the `AccessChange` with the provider recorded, and update the mirror at the write (the COM-525 pattern).
- **Detection.** The Entra delta will see the same change 30+ minutes later. `_requested_recently` must match it via the combined record, not by Entra id and a short window. Add a test with a sync delay.
- **One write path.** This module stays the only writer, and the grep-provable claim is updated.

**Done when:** on staging, a role maps one on-premises group and one on-premises list. A joiner with that role is Applied on both in AD, shows on the group pages at once, and shows in Entra after the sync, with no unrequested change raised. A group outside the managed OUs still becomes a to-do.