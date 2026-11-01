---
id: 01M6BEXBW7ZGSEVEGPSNX9TGGA
created: 2026-11-01T11:46:27.335267Z
updated: 2026-11-01T12:36:47.672769Z
type: task
title: An admin can rename a portal role (name and description only); Vendor Contact becomes Vendor Requester
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1509
sprint: s53765q
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Sprint 101, Roles and Permissions. Raised by Steve on 1 Nov 2026 (option b).

## Why

Steve wants to rename Vendor Contact. Today the five portal roles (Vendor Contact, Vendor Approver, Recertifier, Asset owner, Attester) can't be edited on the Roles screen at all. That's deliberate: nobody should be able to add internal permissions to a role meant only for the portal (ADR 0067 §3). But the same lock blocks changing a name, which is harmless. The roles rework may rename others too.

## Behaviour

- On the Roles screen, the five portal roles are listed in their own section, marked "Portal role".
- An admin can change a portal role's **name** and **description**. Its permissions are shown read-only, and it still can't be deleted, have permissions added, or be combined into another role. The API refuses anything beyond name and description.
- Where another screen hands the role out (Vendor Approver from approval areas, and so on), that's still said on the role, unchanged.
- A rename shows everywhere the role is named: the Users screen, group mappings, the user portal, Polaris, and the explanations on greyed options. Each rename is recorded in the activity log.
- **Vendor Contact is renamed Vendor Requester (portal)**, keeping the "(portal)" the other four carry (assumption, stated for Steve; drop it on the screen if not wanted). Help text, tooltips and messages that say "Vendor Contact" say "Vendor Requester" instead. This rename is a data change shipped with the task, so it applies on staging and production.
- Nobody's access changes. Only the name does.

**Chain:** on the chain (an API change, plus the rename as a migration).

**Done when:**
- An admin can rename a portal role and edit its description, and can't change anything else about it, on the screen or through the API.
- The rename shows on every screen that names the role, and in the activity log.
- Vendor Contact reads "Vendor Requester (portal)" everywhere, and no on-screen text still says "Vendor Contact".
- Pre-UAT: read-only for the real portal roles, which are shared by everyone on staging. As E2E Admin A, open the Roles screen, check the portal roles are listed and editable only in name and description, and that Vendor Requester (portal) shows. Cancel without saving any edit.