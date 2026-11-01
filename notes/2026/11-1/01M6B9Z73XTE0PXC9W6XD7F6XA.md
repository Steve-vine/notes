---
id: 01M6B9Z73XTE0PXC9W6XD7F6XA
created: 2026-11-01T10:20:05.11766Z
updated: 2026-11-01T12:34:30.092034Z
type: task
title: An Entra group → role mapping shows the group's name as typed when the mapping was made, never its current name ("Administrators" for compass-admin)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1504
sprint: s53765q
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Sprint 101, Roles and Permissions. Found by Steve on staging, 1 Nov 2026.

## What happens

On Users ▸ Entra group → Role mapping, the first mapping reads **Administrators - 00497fff-ea36-4ddd-89e5-36ba288f6e6b**. In Entra, and in Compass's own copy of the directory, that group is called **compass-admin**.

A mapping saves the group's name once, when it's created (COM-250). It takes the name from Compass's copy of the directory if the group is there already. Otherwise it takes whatever was typed on the form. This mapping was created on 18 Aug 2026, before that group had synced, so it kept the typed name. Nothing refreshes the name later: not a sync, and not a rename in Entra. The compass-vendormanagers mapping was created after its group synced, so it's right only by luck of timing.

## Fix

- Wherever a mapping's group is named, the name comes from Compass's copy of the directory whenever the group is in it, so a rename in Entra shows after the next sync. That covers the mapping list, a user's "roles from groups" and the mapping's edit form.
- The saved name is used only when the group isn't in the directory copy: not synced yet, or no longer synced. In that case it's marked "(not syncing)" so a stale name can't pass for a live one.
- Editing the name by hand isn't offered for a group that's syncing, since Entra owns that name.
- Existing mappings need no data fix: they show the right name as soon as this ships.

**Chain:** independent, unless keeping the saved name in step needs a migration. If it does, it joins the chain.

**Done when:**
- The compass-admin mapping reads "compass-admin" on staging.
- A group renamed in Entra shows its new name on the mapping list after the next sync.
- A mapping whose group isn't in the directory shows its saved name, marked as not syncing.
- Pre-UAT: read-only. As E2E Admin A, open Users ▸ Entra group → Role mapping and check both mappings show their Entra names. Nothing is created or changed, because the mappings drive real sign-ins.