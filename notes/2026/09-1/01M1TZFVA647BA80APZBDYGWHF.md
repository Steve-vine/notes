---
id: 01M1TZFVA647BA80APZBDYGWHF
created: 2026-09-06T09:06:17.542286Z
updated: 2026-09-06T14:20:58.753797Z
type: task
title: a gap has no page — you can write its description but never read it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 576
sprint: s2fcksg
comments:
- id: 01M1VAG7364S0W0X3TS0MEYTGZ
  author: Steve Vine
  at: 2026-09-06T12:18:43.941801Z
  text: |-
    Done — PR #588, merged to main.

    `/gaps/<id>` exists. The description reads first and reads large, with pre-wrap so the line breaks somebody typed survive — that was the point of the task, and it had been write-only since the field was added. A blank one now says what it is for rather than rendering an empty card.

    The page also carries: owner by name and assignable (COM-575's picker), status and target date editable in place, the control it was raised against as a link, the risks it is linked to with their residual band, and the audit history.

    Three loose ends closed with it:

    - The list's **Title** is the link to the gap, rather than the control.
    - The **Actions queue deep-links the gap itself** (ADR 0055 §5). `/gaps/<id>` still matches the `_INTERNAL_ONLY` prefix, so the portal rule is unchanged.
    - **`GET /gaps/{id}/risks`** — new, the other end of a join that already existed one way.

    One thing worth knowing, because it would have shipped broken: the new route first returned the ORM rows raw and failed response validation on all five derived fields (inherent/residual score and band, over-appetite). Those are computed, not columns. It now serialises through the risks router's own `_to_out`, as `risk_overview.py` already does, so this route cannot drift from `GET /risks`. The integration test caught it, not staging.

    Backend tests hit real Postgres: the reverse link reading both ways, unlinking removing it from both ends, reads open to a viewer, 404 for a gap that is not there, and the actions link asserted as `/gaps/<id>`.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found by Steve on staging, 2026-09-06: a gap cannot be opened; the only link on the row goes back to the control.

There is no gap page at all — one route, `/gaps`, and it is the list. The title is plain text. Everything a reader can learn about a gap is the five columns of that table, and following the only link takes them away from the gap to the control it came from.

## What that costs

**A gap's description is write-only.** Raising a gap offers a description box, pre-filled with a suggestion, and that text is then **never rendered anywhere in the app** — not on the list, not anywhere else, because there is nowhere else. Somebody writes down why the control falls short and what needs doing, saves it, and no screen will ever show it to them again. For a governance record whose whole purpose is remediation, that is the closest thing to losing the data without deleting it.

**The owner is anonymous.** The Owner column reads "You", "Unassigned", or — for anybody else — the word **"Assigned"**. It does not say who. A screen listing outstanding remediation cannot tell you whose it is. (COM-575 adds the ability to assign to a colleague, which makes this worse the day it lands: more gaps owned by somebody the screen refuses to name.)

**The Actions queue cannot deep-link a gap.** ADR 0025 / ADR 0055 promise that every row in the queue goes to its source; gap rows go to `/gaps`, the whole list, and leave you to find it. That is not an oversight in the queue — there is no address to send anybody to.

**A gap's links are one-way.** A risk can show the gaps attached to it; a gap cannot show the risk it belongs to.

## What changes

A gap gets a page — `/gaps/<id>` — showing what it is and letting it be worked:

- Its **title and description**, the description prominent rather than tucked away. This is the point of the task.
- The **control** it came from and the assessment behind it, as links.
- **Owner** by name, **status**, **target date** — editable in place for whoever may manage gaps.
- The **risks** it is linked to, so the relationship reads from both ends.
- Its history, if that comes cheaply from the audit trail.

Then the loose ends close on their own:

- The list's Title becomes the link to it.
- The Owner column names the person, on the list as well as the page.
- The Actions queue points gap rows at the gap rather than the list.

## Related

- COM-575 — assigning to a colleague; makes the anonymous owner column more visible.
- ADR 0055 §5 — a queue row deep-links to its source.
