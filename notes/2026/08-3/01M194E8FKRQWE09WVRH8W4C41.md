---
id: 01M194E8FKRQWE09WVRH8W4C41
created: 2026-08-30T10:46:28.59507Z
updated: 2026-08-30T12:53:17.1093Z
type: task
title: Extra fields on users
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 531
sprint: sz42uhw
blocked_by:
- 01M194DR53W6QGX7KCYFGVWQGV
comments:
- id: 01M19BPEAGJ2D5V3YC803ESKR4
  author: Steve Vine
  at: 2026-08-30T12:53:16.75269Z
  text: |-
    Shipped — PR #538, merged to main as d6d1a0d.

    The care you asked for is on the admin screen, and only where it is needed: selecting **Users** as the object type raises a line saying a person's extra fields are visible to everyone who can read the directory — governance notes, not an HR record, and nothing about health, performance, pay or conduct belongs here. Said before somebody defines a field rather than after.

    **The thing you asked me to check.** A leaver's fields do stay on the mirrored user after they vanish from the tenant, which is right for the audit trail and does mean the values persist about a real person who has left. They read as history: the panel says so on any vanished object — the group case already gave us that — and there is now a test for it on an account specifically.

    Otherwise wiring: `ExtraFieldsPanel` with `objectType="user"` on the account modal, no backend change, no migration.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: review
---
Extend extra fields to users, on the machinery built for groups.

The largest population, and the one to be most careful with. A user's extra fields are visible to everyone with Access read, so the admin screen should say plainly that these are governance notes, not an HR record — nothing about health, performance, pay or conduct belongs here.

Same rules as groups: an Access Manager or above defines the fields, anyone with Access read fills them in, values are Compass's own and untouched by sync, changes land in the activity log.

One thing to check while building: a leaver's fields stay on the mirrored user after they vanish from the tenant, which is right for the audit trail but means the values persist about a real person after they have left. Confirm that reads correctly on the user's page — the row is already marked vanished, so the field values should read as history rather than as current fact.