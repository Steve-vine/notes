---
id: 01M194DW79NQT4EQCCMZXZMJ0X
created: 2026-08-30T10:46:16.041163Z
updated: 2026-08-30T10:47:04.206677Z
type: task
title: Extra fields on conditional access policies
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 529
sprint: sz42uhw
blocked_by:
- 01M194DR53W6QGX7KCYFGVWQGV
assignee: steve
company: null
label:
- feature
priority: high
task_status: backlog
---
Extend extra fields to conditional access policies, on the machinery built for groups.

A small population, and the one where the missing information hurts most: an auditor asks why a policy exists, what it is protecting against, who signed it off and when it was last thought about — and Entra records none of it. A CA policy's page is where that answer should live.

Same rules as groups: an Access Manager or above defines the fields, anyone with Access read fills them in, values are Compass's own and untouched by sync, changes land in the activity log.

Nothing new in the model — `DirectoryConditionalAccessPolicy` is mirrored like the rest, so this is the object type wired to the shared field machinery and surfaced on the policy's page.