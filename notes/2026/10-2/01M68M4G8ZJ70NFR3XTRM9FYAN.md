---
id: 01M68M4G8ZJ70NFR3XTRM9FYAN
created: 2026-10-31T09:20:00.799234Z
updated: 2026-10-31T12:59:24.765101Z
type: task
title: Admin ▸ Actions — set each action type's default owner (a person or a role, with company overrides), when undated work falls due, its notification window, and how far ahead "Upcoming" looks
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1469
sprint: scpaa6p
blocked_by:
- 01M68M44WZ1YF1AZ9HTXB5P20S
comments:
- id: 01M68TVV7BA9JG1F873SGB8N48
  author: Steve Vine
  at: 2026-10-31T11:17:37.131176Z
  text: |-
    Done: PR #1488 merged (e44795e3).

    - **New tab, Admin ▸ Actions.** It needs Manage configuration. It has:
      - **Upcoming:** "Show actions due within the next 90 days".
      - **A table per module,** listing every type of action with its default owner, "N days after it arrives" (for work with no date of its own), "N days before it's due" (when its owner starts being emailed) and any company with its own owner.
      - **Edit,** which opens a dialog to change all of that and to add or remove a company's own owner.
    - **A default owner** is the module's team, a role or a person. A company's own owner is a person or a role.
    - **Starting point:** every type starts at its module's team and its declared timings, so nothing changes until an administrator sets something.
    - **The activity log** records every change.
    - **Release day** (31 Oct 2026, when the migration ran) is recorded as the earliest date undated work counts from.

    To test on staging, in E2E Test Company:
    1. Create a role "E2E Incident Managers" and make it the default owner of Incident · Triage.
    2. Give E2E Test Company its own owner for that type.
    3. Change a window.
    4. Check the changes appear in the activity log.
- id: 01M690P7PX5W7HAA6HSK3Q4V5P
  author: Steve Vine
  at: 2026-10-31T12:59:24.764944Z
  text: |-
    Pre-UAT (staging, 31 Oct, as E2E Admin A, through the API because the browser tool wasn't connected this session): Passed.
    - Created the role "E2E Incident Managers" (slug e2e_incident_managers, incident handling) and gave it to E2E Analyst.
    - Set it as **E2E Test Company's own** default owner of Incident · Triage. The setting shows "E2E Test Company: E2E Incident Managers".
    - I didn't change the default for every company, so no real staging work moved.
    - Changed Gap's window to 13 days and put it back to 14.
    - The activity log shows all three kinds of change (action_type_company_owners, action_type_settings, users).
    - Horizon reads 90; set to 30 and back to 90.

    Couldn't check: the tab's look on screen (no browser this session).
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 100, Actions (ADR 0137, COM-1468).

## What people see

A new **Actions** tab under Admin. It holds:

- **Upcoming horizon:** "Show actions due within the next **90** days". This is what the Actions screen's *Upcoming only* switch and the *Upcoming*/*Later* statuses use.
- **One row per action type** (Gap · Remediate, Incident · Triage, Risk · Create a treatment plan…), grouped by module, showing:
  - **Default owner:** a person or a Compass role (e.g. a role "Incident Managers" made under Admin ▸ Roles). It applies to every company.
  - **Company overrides:** a different default owner for a named company.
  - **Due:** "N days after it arrives". This only appears for types that have no date of their own (triage, approvals, a risk with no treatment plan…).
  - **Notification window:** "email from N days before it's due". It starts at today's values.
- A type with no default owner is flagged. That should never happen, because each one starts at the built-in role that sees it today.

## Who can do what

Administrators change it. Anyone who can open Admin can read it. Every change is in the activity log.

## Notes (technical)

- Migration: action-type settings (type key, default owner user/role slug, due-after days, window days) plus per-company overrides and the global horizon. Seed defaults from each source's current module audience (`core/actions/base.py` module → permission map) and today's lead windows.
- The type keys come from the source declarations, so a new source with no row is caught by a unit test, as TASK_LABELS is.
- API under `/api/v1/admin/actions` (read with admin view, write with admin). Regenerate schema.d.ts.
- Roles: owner by **slug** (ADR 0067: the slug is the grant).

**Chain:** on the chain (migration + API).

**Done when:** on staging, in E2E Test Company, an administrator creates a role "E2E Incident Managers" and makes it the default owner of Incident · Triage. They give E2E Test Company its own override, change a window, and the change shows in the activity log.