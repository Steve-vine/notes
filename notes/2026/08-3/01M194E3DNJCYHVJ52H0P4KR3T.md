---
id: 01M194E3DNJCYHVJ52H0P4KR3T
created: 2026-08-30T10:46:23.413226Z
updated: 2026-08-30T12:26:58.039209Z
type: task
title: Extra fields on directory roles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 530
sprint: sz42uhw
blocked_by:
- 01M194DR53W6QGX7KCYFGVWQGV
comments:
- id: 01M19A68AARP7HN4YZDE20REG7
  author: Steve Vine
  at: 2026-08-30T12:26:57.737923Z
  text: |-
    Shipped — PR #537, merged to main as be6fd17.

    `ExtraFieldsPanel` with `objectType="directory_role"` on the role detail page — on the **role**, never on an assignment, as you said: why a particular person holds one is a membership-provenance question with an answer already (ADR 0063), and a second record of the same fact is two records that can disagree.

    Same guards, same values Compass owns outright, same activity log. No backend change and no migration — the object type was already in the enum from COM-528, which is what made this the wiring it was meant to be.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: review
---
Extend extra fields to directory roles, on the machinery built for groups.

The smallest population in the directory and the most privileged. The useful notes here are about the organisation's own posture towards a role rather than the role itself: who is expected to hold it, what our rule is for granting it, whether we have decided it should be PIM-only.

Same rules as groups: an Access Manager or above defines the fields, anyone with Access read fills them in, values are Compass's own and untouched by sync, changes land in the activity log.

Note for whoever picks this up: fields belong on the **role** (`DirectoryRole`), not on a role assignment. Why a *person* holds a role is a membership-provenance question and already has an answer (ADR 0063) — do not build a second one here.