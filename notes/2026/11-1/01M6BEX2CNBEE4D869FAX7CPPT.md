---
id: 01M6BEX2CNBEE4D869FAX7CPPT
created: 2026-11-01T11:46:17.621459Z
updated: 2026-11-01T11:46:31.648382Z
type: task
title: The Users screen shows portal roles by their internal ID (VENDOR_USER, RECERTIFIER) instead of their names
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1508
sprint: s53765q
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Sprint 101, Roles and Permissions. Found by Steve on staging, 1 Nov 2026.

## What happens

After Vendor Contact was given to a user, the Users screen shows it as **VENDOR_USER**. The screen turns each role's internal ID into its name by looking it up in the list of roles. But it asks for the list **without the five portal roles**, so for Vendor Contact, Vendor Approver, Recertifier, Asset owner and Attester it finds no name and shows the ID. The badge's capitals make it read like a code.

## Fix

- The Users screen looks role names up in the full list, portal roles included. Every badge shows the role's name ("Vendor Contact (portal)"), and a renamed role shows its new name.
- Check every other screen that names a role, for example a user's "roles from groups", the group mapping list and the activity log. Each should use the same full list, so none shows an ID where a name exists.
- An ID is still shown only for a role that no longer exists, as today, so the grant can still be read.

**Chain:** independent (a screen fix, no migration or API shape change).

**Done when:**
- A user holding any of the five portal roles shows that role's name on the Users screen, not its ID.
- No other screen that names roles shows an ID for a role that exists.
- Pre-UAT in E2E Test Company: as E2E Admin A, open the Users screen and check a test account holding a portal role (for example E2E Vendor Admin, if it holds one) shows the role's name. Nothing is changed.