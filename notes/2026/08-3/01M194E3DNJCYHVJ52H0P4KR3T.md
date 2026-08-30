---
id: 01M194E3DNJCYHVJ52H0P4KR3T
created: 2026-08-30T10:46:23.413226Z
updated: 2026-08-30T12:15:14.626653Z
type: task
title: Extra fields on directory roles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 530
sprint: sz42uhw
blocked_by:
- 01M194DR53W6QGX7KCYFGVWQGV
assignee: steve
company: null
label:
- feature
priority: medium
task_status: active
---
Extend extra fields to directory roles, on the machinery built for groups.

The smallest population in the directory and the most privileged. The useful notes here are about the organisation's own posture towards a role rather than the role itself: who is expected to hold it, what our rule is for granting it, whether we have decided it should be PIM-only.

Same rules as groups: an Access Manager or above defines the fields, anyone with Access read fills them in, values are Compass's own and untouched by sync, changes land in the activity log.

Note for whoever picks this up: fields belong on the **role** (`DirectoryRole`), not on a role assignment. Why a *person* holds a role is a membership-provenance question and already has an answer (ADR 0063) — do not build a second one here.