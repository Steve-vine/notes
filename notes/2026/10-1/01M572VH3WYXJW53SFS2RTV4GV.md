---
id: 01M572VH3WYXJW53SFS2RTV4GV
created: 2026-10-18T08:43:04.700431Z
updated: 2026-10-18T08:43:04.700431Z
type: task
title: Incidents put work in people's Actions — reports to triage, incidents without an owner, notification deadlines coming up or missed, reviews due or overdue — and the actions email carries them
label: feature
task_status: todo
assignee: steve
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1078
---
Sprint 76, Incidents - Register (ADR in COM-1063). Builds on notifications (COM-1071), the review (COM-1074) and portal reporting (COM-1077).

## What people see

In **Actions** (and the hourly actions email):

| Who | Sees |
|---|---|
| Every handler for the company | **New reports to triage**, oldest first, showing how long ago each was reported |
| Every handler for the company | **Open incidents with no owner** |
| The incident's owner | **Notifications to decide**: amber inside 24 hours of the deadline, red once overdue |
| The incident's owner | **Post-incident review due**: from 3 days before the due date, red once overdue |
| The incident's owner | **Open incidents with no update for 7 days**: a gentle prompt to add a timeline entry or move it on |
| Handlers (roll-up) | Overdue notifications and reviews across the company |

- Each action links straight to the incident's card.
- Corrective actions arrive through Gaps and Risks as they do today.

**A notification deadline inside 24 hours also sends an immediate email** to the owner and handlers, once. A 72-hour clock can't wait for the next digest after a weekend.

## Rules

- Restricted incidents only produce actions for people who can see them (COM-1076).
- Actions disappear when the thing is done; nothing is stored (ADR 0055).

## Notes (technical)

- New source in `core/actions/incidents.py`. The 24-hour email is a beat job in `tasks/` that records it was sent, so it is idempotent.

**Done when:** each action appears for the right people at the right time and clears when done; the 24-hour warning emails once.