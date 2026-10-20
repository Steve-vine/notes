---
id: 01M572VH3WYXJW53SFS2RTV4GV
created: 2026-10-18T08:43:04.700431Z
updated: 2026-10-20T12:18:19.138677Z
type: task
title: Incidents put work in people's Actions — reports to triage, incidents without an owner, notification deadlines coming up or missed, reviews due or overdue — and the actions email carries them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1078
sprint: serbigk
blocked_by:
- 01M572RYT1A4MT960P6793X8M8
- 01M572T0RGS2CD4KH7CN6K7NDD
- 01M572V75177HKVAMB7YDB0ERH
comments:
- id: 01M581MSWMCF5NEP8MRF716X23
  author: Steve Vine
  at: 2026-10-18T17:41:10.164818Z
  text: |-
    Done: merged in PR #1077.

    - Every handler sees **New reports to triage** in Actions, oldest first, with how long ago each came in ("INC-12 · Phishing email, reported 3 h ago"). They also see **open incidents with no owner**.
    - The owner sees:
      - **Notifications to decide**, with the time left or how late they are ("21 h left", "overdue by 8 h"). These show amber "Due soon" inside 24 hours and red once overdue, to the hour. If an incident has no owner, these go to every handler so they don't go to nobody.
      - **Post-incident review** from 3 days before a required one is due, red once overdue.
      - **No update for 7 days** when an open incident has gone quiet for a week.
    - Handlers get one roll-up row per company, e.g. "Incidents: 2 notifications and 1 post-incident review overdue".
    - Each action opens the incident at the right card: Triage, Notifications, Review or Timeline. The Actions page has a new **Incidents** filter.
    - A notification deadline less than 24 hours away, or already passed, **emails the owner and every handler at once, and only once**. The email gives the reference, company, title, notification and deadline, with nothing else from inside the incident.
    - Restricted incidents produce actions and emails only for the people who can see them. Everything clears as soon as the work is done.

    Choice made: Compass has no per-company handler list, so "the company's handlers" means everyone who can handle incidents.
assignee: steve
label:
- feature
priority: high
task_status: done
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