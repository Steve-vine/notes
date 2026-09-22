---
id: 01M3435D9YYVNFTQVBFV658RWP
created: 2026-09-22T08:19:21.534548Z
updated: 2026-09-22T16:12:14.338092Z
type: task
title: Access Control Recertification - Directory Role
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 736
sprint: s3nfes0
comments:
- id: 01M34DSTBWRYSS1BT6HW4FT2D0
  author: Steve Vine
  at: 2026-09-22T11:25:16.028421Z
  text: |-
    Done in PR #747 (merged to main 2026-09-22). A schedule's entity type now offers Directory role, picked from the mirror. The review lists every holder — direct, or via a role-assignable group (nested included) — with Active and Eligible kept apart, and a service principal holding the role as its own row. No owner to prefill (Entra gives a role none). Compass never writes a role assignment: a flagged holder, once approved, is an action for the access admins ("Directory role removal") and "Confirm removed in Entra" on the review closes the row with who and when. Migration 0203 (enum values + recert_schedules.directory_role_id).

    To smoke-test: Access Control → Recertification → Add schedule → Entity type "Directory role" → pick Global Administrator → name an owner → Trigger now → review in the portal → flag → approve → the action appears in Actions → confirm on the review.
assignee: steve
label: null
priority: medium
task_status: review
---
Currently the Access Control Recertification doesn't support Directory Role (E.g. Global Admin).  This option needs adding.