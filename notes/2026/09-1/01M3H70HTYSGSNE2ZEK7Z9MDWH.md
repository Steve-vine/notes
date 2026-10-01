---
id: 01M3H70HTYSGSNE2ZEK7Z9MDWH
created: 2026-09-27T10:36:44.254358Z
updated: 2026-10-01T07:00:54.225599Z
type: task
title: Changing the setup — AD only to Hybrid, Hybrid to Entra ID only — keeps every person, role and record
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 785
sprint: sme8esk
blocked_by:
- 01M3H708MAZ3PFZE12TQNQE0DV
comments:
- id: 01M3HY7NFT99DECGFHM4NH8H6E
  author: Steve Vine
  at: 2026-09-27T17:22:34.618152Z
  text: |-
    Done — PR #795 (stacked on #794).

    Admin ▸ Integrations ▸ Directory setup: choosing a new setup and pressing Save now opens a preview. Nothing changes until you press "Switch to …". The preview shows:
    - how the people and groups Compass already has will line up across the directories, with counts
    - what will no longer be managed, with names: whatever only the directory being dropped holds
    - what starts and what stops (AD reads and writes, Entra and Exchange, the cloud-only screens, Microsoft sign-in)
    - warnings: a connection the new setup needs that isn't set up yet, and, when leaving Entra, how many people sign in to Compass with Microsoft

    The preview is a dry run of the switch itself, so its numbers are what the switch does. A switch never deletes anything. Records it no longer governs show as no longer managed, with their history, reviews and to-dos kept, and switching back brings them back on the next read. Every switch is in the activity log.

    In AD only, AD is now the whole directory: it names everyone, and anyone it no longer holds is marked gone.

    Tests cover AD only → Hybrid (one record per person, business roles kept, no duplicates), Hybrid → Entra only and back again, and Hybrid → AD only.

    Open question for Steve: in AD only, people who sign in to Compass with Microsoft have no way in, because an admin can't set a password on a Microsoft account. The preview warns about it. Should switching to AD only turn those accounts into local ones, so "Forgot password?" works? Not relevant to this estate, so I've left it as a warning.
assignee: steve
label:
- feature
priority: medium
task_status: done
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