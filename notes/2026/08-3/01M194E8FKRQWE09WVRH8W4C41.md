---
id: 01M194E8FKRQWE09WVRH8W4C41
created: 2026-08-30T10:46:28.59507Z
updated: 2026-08-30T11:22:50.823319Z
type: task
title: Extra fields on users
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 531
sprint: sz42uhw
blocked_by:
- 01M194DR53W6QGX7KCYFGVWQGV
assignee: steve
company: null
label:
- feature
priority: medium
task_status: todo
---
Extend extra fields to users, on the machinery built for groups.

The largest population, and the one to be most careful with. A user's extra fields are visible to everyone with Access read, so the admin screen should say plainly that these are governance notes, not an HR record — nothing about health, performance, pay or conduct belongs here.

Same rules as groups: an Access Manager or above defines the fields, anyone with Access read fills them in, values are Compass's own and untouched by sync, changes land in the activity log.

One thing to check while building: a leaver's fields stay on the mirrored user after they vanish from the tenant, which is right for the audit trail but means the values persist about a real person after they have left. Confirm that reads correctly on the user's page — the row is already marked vanished, so the field values should read as history rather than as current fact.