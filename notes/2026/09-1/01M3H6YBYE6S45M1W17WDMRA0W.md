---
id: 01M3H6YBYE6S45M1W17WDMRA0W
created: 2026-09-27T10:35:32.686291Z
updated: 2026-09-27T10:37:09.63892Z
type: task
title: An admin chooses the OUs Compass may manage — picked from the domain's own OU list
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 778
sprint: sme8esk
blocked_by:
- 01M3H6Y4FBYRVYEAG70C9ASF63
assignee: steve
label:
- feature
priority: high
task_status: todo
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