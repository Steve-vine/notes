---
id: 01M3H6YBYE6S45M1W17WDMRA0W
created: 2026-09-27T10:35:32.686291Z
updated: 2026-10-01T07:00:50.590166Z
type: task
title: An admin chooses the OUs Compass may manage — picked from the domain's own OU list
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 778
sprint: sme8esk
blocked_by:
- 01M3H6Y4FBYRVYEAG70C9ASF63
comments:
- id: 01M3HNWEGJT97QMMFN593BCMTJ
  author: Steve Vine
  at: 2026-09-27T14:56:38.418616Z
  text: |-
    Done: PR #788, merged to main (b506570).

    **Managed OUs** on the AD card: the domain's OUs as a tree. Tick the ones Compass may change. Ticking an OU covers everything beneath it, and its children show *Included*. Saving is recorded in the audit trail.

    **What Compass's account may actually do there is checked with AD itself:**
    - change a group's members
    - disable or change an account
    - create accounts

    The check runs every 5 minutes, and straight after you tick an OU. A shortfall is shown in plain words, e.g. *"Compass can't change accounts in Staff — give its account rights there, or untick it."*

    **Every user and group page** that AD holds gets a **Changes in AD** line:
    - *Changed in AD by Compass*
    - *Outside the OUs Compass manages — changes are to-dos*
    - *Compass's account can't change it in AD — changes are to-dos*

    This is the single rule that membership changes, leavers and joiners (COM-779 to COM-781) follow. Nothing is ticked after upgrade, so until you tick an OU, every on-premises change stays a to-do exactly as today.

    **Smoke test** (after the batch deploy): tick two OUs, then open a person inside one and a person outside both. They should say *Changed in AD by Compass* and *Outside…* respectively. If Compass's account lacks rights in a ticked OU, the card should show a red line naming it.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Part of the on-premises AD sprint (ADR in COM-773).

## What people see

- **Admin ▸ Integrations ▸ Active Directory** gains **Managed OUs**: the domain's OUs as a tree, read from AD. An admin ticks the ones Compass may change. Ticking an OU includes everything beneath it.
- Compass **changes objects only inside the ticked OUs**. Anything outside is still read and shown, but a change to it becomes a to-do, exactly as today.
- **The card checks the rights.** If Compass's AD account can't actually write in a ticked OU, the card says so in plain words: *"Compass can't change groups in Finance — give its account rights there, or untick it."*
- **Each group and user page says whether Compass manages it in AD**: *"Changed in AD by Compass"*, or *"Outside the OUs Compass manages — changes are to-dos"*.
- Changing the list is recorded in the audit trail.
- The same list feeds the OU picker for new starters (COM-781).

## Notes (technical)

- **Rights check.** Use `allowedAttributesEffective` / `allowedChildClassesEffective` on the OU, and on a sample group and user in it. Store the result per OU and refresh it with `ad_health`.
- **Storage.** Store DN and objectGUID, and resolve by GUID so a renamed or moved OU keeps its tick.
- **A single rule.** A predicate "managed in AD" per object (inside a ticked OU, AD connected, rights OK) is what COM-779, COM-780 and COM-781 route on — one rule, many callers, as the governable rule is.

**Done when:** on staging, an admin ticks two OUs. Objects inside them show as managed, and one outside shows as a to-do. An OU where the account has no rights is flagged on the card.