---
id: 01M5B0HT943VYEA3NYRN7GD98F
created: 2026-10-19T21:19:46.980747Z
updated: 2026-10-20T18:05:46.136857Z
type: task
title: Request owners are reminded through Actions — acknowledgement due, waiting on the person, due in 7 days and in 1 day, overdue, and unowned requests — with an immediate email when a deadline is inside 24 hours
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1142
sprint: ss8348q
blocked_by:
- 01M5B0HEPQBSMDJV095QR013YJ
comments:
- id: 01M5BKGDJQ6TH27TM2RD40T4MC
  author: Steve Vine
  at: 2026-10-20T02:51:04.150888Z
  text: |-
    Done — merged (PR #1135).

    - A request's owner now sees in **Actions**:
      - **Acknowledge DSR-12 · Jane Doe** until an acknowledgement (or complaint acknowledgement) letter is marked sent, due on the acknowledgement date;
      - **DSR-12 · Jane Doe is waiting on the person — 15 days**, after 14 days paused or waiting for identity;
      - **DSR-12 · Jane Doe is due in N days** from 7 days out, then **…is overdue** (not while paused — the clock is stopped);
      - **Send the extension letter for DSR-12** until it's marked sent, due on the original deadline.
    - **RTD-4 · Thames Valley Police is due to respond in 2 days** for an open request to disclose with Respond by within 3 days.
    - No owner, or the owner has left: every handler gets the to-dos (not people who can only view).
    - A restricted request's to-dos go only to its owner and named people, and show just the number.
    - Closing a request clears its to-dos.
    - Email: the hourly digest carries them, with reminders 7 days and 1 day before and a weekly chase once overdue. A deadline within 24 hours is also emailed at once (once per person, again if the deadline moves), giving only the reference, company and deadline.
    - The Actions page has a "Data subject requests" filter.

    My calls: the 24-hour email runs inside the existing hourly job rather than its own timer (keeps the background scheduler's memory flat; it can arrive up to an hour after the 24-hour mark); it goes to the owner, or every handler when unowned (Incidents emails all handlers); deadlines already past don't get the instant email (the overdue chase covers them, so deploy day doesn't email every overdue request); someone who can see restricted requests but isn't named on one doesn't get its to-dos.
assignee: steve
label:
- feature
priority: medium
task_status: done
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