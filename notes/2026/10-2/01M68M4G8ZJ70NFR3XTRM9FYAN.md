---
id: 01M68M4G8ZJ70NFR3XTRM9FYAN
created: 2026-10-31T09:20:00.799234Z
updated: 2026-10-31T09:22:32.89512Z
type: task
title: Admin ▸ Actions — set each action type's default owner (a person or a role, with company overrides), when undated work falls due, its notification window, and how far ahead "Upcoming" looks
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1469
sprint: scpaa6p
assignee: steve
label:
- feature
priority: high
task_status: todo
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