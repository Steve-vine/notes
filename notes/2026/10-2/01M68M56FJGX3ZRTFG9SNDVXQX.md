---
id: 01M68M56FJGX3ZRTFG9SNDVXQX
created: 2026-10-31T09:20:23.538536Z
updated: 2026-10-31T11:19:47.604545Z
type: task
title: Every action has an owner — generated and unowned work goes to its type's default owner, and an action owned by a role is "mine" for everyone in that role
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1471
sprint: scpaa6p
blocked_by:
- 01M68M4G8ZJ70NFR3XTRM9FYAN
- 01M68M4TR5X3N0A30R9F8XGY5V
comments:
- id: 01M68TZS12XVHYZ53ZZT6B4M62
  author: Steve Vine
  at: 2026-10-31T11:19:45.953502Z
  text: |-
    Done: PR #1489 merged (62737ac0).

    - **No action has a blank owner now.** It's the thing's own owner while they're active. Otherwise it's the type's default owner from Admin ▸ Actions: the company's own if set, else the one for every company, else the module's team ("Incidents team", "Posture team").
    - **An action owned by a role** shows the role's name and is under My actions for everyone holding it. That includes someone in no module: they see only what the role is given.
    - **An owner who has left** no longer owns anything. Their work goes to the default owner.
    - **Email goes to an action's owners only.** Before, everyone who could see a row was mailed. Others still see it on the list with My actions off.
    - **A module's team is whoever manages its work,** not everyone who can read it. Posture's team is whoever manages gaps, risks or assessments. Vendors' is whoever manages the register. A flagged directory-role holder's removal goes to the Access Admins, never back to the recertifier who flagged it.
    - **Unchanged:** nobody approves or validates their own request, and restricted incidents and requests only reach the people allowed to read them.

    To test on staging, in E2E Test Company:
    1. Make "E2E Incident Managers" the default owner of Incident · Triage.
    2. Report an incident through the portal.
    3. Check it shows owner "E2E Incident Managers" and appears under My actions for an account in that role, but not for one outside it.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 100, Actions (ADR 0137 rule 3).

## What people see

- No row on Actions has a blank owner. Each action is owned by:
  - **the thing's owner**, when it has one who's still active;
  - otherwise **the type's default owner** from Admin ▸ Actions (COM-1469): the company's override if there is one, else the default for every company.
- This covers generated work (a report to triage, an unrequested directory change, a trust centre request), records nobody owns, and records whose owner has left.
- When the default owner is a **role**, the Owner column shows the role's name ("Incident Managers"). Everyone who holds that role sees it under **My actions** and is emailed about it.
- Today's exclusions stay. Whoever raised an expedited change is never asked to validate it, and nobody approves their own request, even when they're in the owning role.
- Changing a default owner moves the open actions it covers straight away.

## Notes (technical)

- Resolve the owner in one place after the sources collect (`core/actions/`), not inside each source. The reader scope (rule one, assigned to me; rule two, my modules) becomes: owner is me, or owner is a role I hold. Keep the per-reader exclusions as they are.
- Digest recipients: the role's members, de-duplicated against the ledger per person.
- Restricted incidents and DSRs: a role-owned action still only reaches members who may read the record (COM-1076, ADR 0118 §12).

**Chain:** on the chain. Blocked by COM-1469 and COM-1470.

**Done when:** on staging, in E2E Test Company, an incident reported through the portal shows owner "E2E Incident Managers". It appears under My actions for an E2E account in that role and not for one outside it.