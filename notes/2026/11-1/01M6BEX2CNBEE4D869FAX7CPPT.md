---
id: 01M6BEX2CNBEE4D869FAX7CPPT
created: 2026-11-01T11:46:17.621459Z
updated: 2026-11-01T14:22:35.228166Z
type: task
title: The Users screen shows portal roles by their internal ID (VENDOR_USER, RECERTIFIER) instead of their names
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1508
sprint: s53765q
comments:
- id: 01M6BHN01NZR17FQJ6KNH2CRD9
  author: Steve Vine
  at: 2026-11-01T12:34:18.805786Z
  text: 'Done: PR #1518 merged. The Users screen now looks role names up with portal roles included, so someone holding Vendor Contact shows "Vendor Contact (portal)", not VENDOR_USER. I checked the other screens that name roles: the group mapping panel already included portal roles, and Access ▸ Roles and the activity log get names from the server. Only the Users screen was affected. New test added. Pre-UAT after the staging deploy.'
- id: 01M6BQV86WQF52NB5HB9AFKYFQ
  author: Steve Vine
  at: 2026-11-01T14:22:35.227999Z
  text: 'Pre-UAT: Couldn''t check on screen (the browser tool wasn''t connected). The fix is in how the screen looks the name up. Through the API, the roles list with portal roles now gives every portal role''s name, e.g. vendor_user → "Vendor Requester (portal)". Steve to look at: the Users screen badge for someone holding a portal role shows its name, not VENDOR_USER.'
assignee: steve
label:
- bug
priority: medium
task_status: review
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