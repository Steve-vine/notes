---
id: 01M5B0HT943VYEA3NYRN7GD98F
created: 2026-10-19T21:19:46.980747Z
updated: 2026-10-19T21:19:46.980747Z
type: task
title: Request owners are reminded through Actions — acknowledgement due, waiting on the person, due in 7 days and in 1 day, overdue, and unowned requests — with an immediate email when a deadline is inside 24 hours
label: feature
task_status: todo
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1142
---
Sprint 79, Data Privacy (ADR in COM-1129). Uses ADR 0055: Actions is every module's work queue, and the source of its mail.

## What people see

In **Actions**, for the request's **owner**:

| To-do | When |
|---|---|
| Acknowledge DSR-12 | the rule has an acknowledgement deadline (CCPA 10 business days, UK complaint 30 days) and no acknowledgement letter is marked sent |
| DSR-12 is waiting on the person | paused, or waiting for identity, for 14 days (a nudge to chase or close) |
| DSR-12 is due in 7 days / 1 day | — |
| DSR-12 is overdue | — |
| Send the extension letter for DSR-12 | an extension was recorded and no letter is marked sent |
| RTD-4 is due to respond | a request to disclose with a Respond-by date inside 3 days |

**Unowned** (owner left, or no owner): the to-do goes to everyone who can handle requests for that company.

**Email**: the hourly digest carries these as it does for other modules. A deadline **inside 24 hours** is also sent at once (`tell_now`, as for incidents).

## Rules

- **Restricted requests** appear only to their named people, and the to-do text doesn't show the person's name (just the number).
- Closing the request clears its to-dos.

## Notes (technical)

- `core/actions/dsr.py`, with ActionSources registered in `ACTION_SOURCES`; `reminders` for 7 and 1 day; `tell_now` for the 24-hour case.
- Beat crontabs are wall-clock. Check staging Beat memory after deploy (it was at 181Mi of 256Mi after the incident tick; COM-767).

**Done when:** an owner sees due-soon and overdue to-dos for their requests and gets the digest; a deadline inside 24 hours emails at once; restricted requests show only the number.