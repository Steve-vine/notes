---
id: 01M3H70HTYSGSNE2ZEK7Z9MDWH
created: 2026-09-27T10:36:44.254358Z
updated: 2026-09-27T17:05:03.902929Z
type: task
title: Changing the setup — AD only to Hybrid, Hybrid to Entra ID only — keeps every person, role and record
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 785
sprint: sme8esk
blocked_by:
- 01M3H708MAZ3PFZE12TQNQE0DV
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Part of the on-premises AD sprint (ADR in COM-773). Steve's addition (2026-09-27): *"it should be clear what the current configuration is doing and also possible for an admin to change it if the environment changes. An AD-only setup could make the step towards hybrid and then eventually turn off AD within Compass."*

## What people see

- The directory setup (COM-776) can be changed at any time by an admin. **Before switching, Compass shows a preview** of what will happen: how many people and groups match between the directories, which don't, and what starts or stops working. Every switch is in the audit trail, and switching back is allowed.
- **AD only → Hybrid.** Once Entra is connected and Entra Connect is syncing, each person and group is **matched to its cloud copy**. It stays one record: roles, history, reviews and to-dos kept, nothing duplicated. The cloud-only screens appear. People and groups not (yet) in Entra stay AD-only and are listed in the preview.
- **Hybrid → Entra ID only.** For when AD is being retired, or objects have been moved to the cloud. Objects Entra now owns are changed in Entra, and the AD connection is switched off. Groups that only ever lived in AD are listed in the preview. After the switch they show as **no longer managed**, and their history is kept.
- **Entra ID only → Hybrid** (the step this estate takes): the AD records attach to existing people. It is the same matching, run the other way.
- A change to the setup never deletes a person, group, role or record.

## Notes (technical)

- **Matching.** Uses the anchors from COM-775/777 (objectGUID ↔ `onPremisesImmutableId`). The preview is a dry run of the same code as the switch.
- **Hybrid → Entra only.** Per-object source-of-authority conversion means Graph can write objects that were synced before. The existing "converted object" path (`converted_steps`) applies.
- **Disconnecting AD.** AD beat tasks stop, and the `ad_settings` row is kept but disabled.

**Done when:** in integration tests against the Samba DC plus Graph fakes, an AD-only install switched to Hybrid keeps every role holding and history on the matched people, with no duplicates. On staging (Entra only → Hybrid, the real path), the preview's counts match what the switch then does.