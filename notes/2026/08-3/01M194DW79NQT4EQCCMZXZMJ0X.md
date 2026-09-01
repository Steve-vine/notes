---
id: 01M194DW79NQT4EQCCMZXZMJ0X
created: 2026-08-30T10:46:16.041163Z
updated: 2026-09-01T13:55:51.966088Z
type: task
title: Extra fields on conditional access policies
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 529
sprint: sz42uhw
blocked_by:
- 01M194DR53W6QGX7KCYFGVWQGV
comments:
- id: 01M19A5QYTWRCM3DXC21JYWE7W
  author: Steve Vine
  at: 2026-08-30T12:26:40.986312Z
  text: |-
    Shipped — PR #536, merged to main as e42c45a.

    **One thing the task assumed did not exist.** It says the answer should live on "a CA policy's page" — there wasn't one. Conditional access was a browse table and nothing else. So a policy row now opens a thin detail modal, the idiom the group, user and device modals already set. Deliberately thin: everything above the fields is restated from the row that opened it, so the answer somebody is writing has its question beside it — no second read, and nothing in the modal the table does not already know.

    The fields themselves were wiring exactly as intended: `ExtraFieldsPanel` with `objectType="conditional_access_policy"`. Same guards, same values Compass owns outright and no sync touches, same activity log. No backend change and no migration — the object type was already in the enum from COM-528.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Extend extra fields to conditional access policies, on the machinery built for groups.

A small population, and the one where the missing information hurts most: an auditor asks why a policy exists, what it is protecting against, who signed it off and when it was last thought about — and Entra records none of it. A CA policy's page is where that answer should live.

Same rules as groups: an Access Manager or above defines the fields, anyone with Access read fills them in, values are Compass's own and untouched by sync, changes land in the activity log.

Nothing new in the model — `DirectoryConditionalAccessPolicy` is mirrored like the rest, so this is the object type wired to the shared field machinery and surfaced on the policy's page.