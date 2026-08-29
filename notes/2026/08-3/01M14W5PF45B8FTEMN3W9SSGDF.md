---
id: 01M14W5PF45B8FTEMN3W9SSGDF
created: 2026-08-28T19:05:01.668733Z
updated: 2026-08-29T11:30:07.695445Z
type: task
title: The standard governance reports, shipped as definitions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 493
sprint: s42ntc9
blocked_by:
- 01M14W593XNB6MF34DCTT2F9QM
- 01M14W4VM3TKYMJ608D19AM97K
assignee: steve
company: null
label:
- feature
priority: high
task_status: review
---
ADR 0062 §4. The shipped library — written as definitions, seeded through the existing importer, indistinguishable in the library from a report Steve writes himself.

The first set:

| Report | Subject | Condition |
|---|---|---|
| Inactive users | Users | enabled, last sign-in over 90 days ago or never (needs COM-492) |
| Users holding privileged roles | Role assignments | role is privileged; active and eligible both shown, and never merged |
| Non-compliant devices | Devices | compliant = No |
| Groups without members | Groups | member count = 0 |
| Groups without an owner | Groups | owner count = 0 |
| Guest accounts | Users | type = Guest |
| Unattributed memberships | Governed memberships | provenance = unattributed |

**If one of these cannot be expressed, the catalogue is not finished and the fix is in COM-487** — not a hand-written endpoint. That is the whole point of seeding them (ADR 0062 §4): the built-ins are the proof the wizard is expressive enough, and a special case here would quietly demote every report anyone else writes.

Seeds are re-imported on every deploy (see the seed importer's existing behaviour), so a correction to a standard report is a correction to its seed. An author's *duplicate* of one is their own row and is never overwritten.