---
id: 01M847JCCSBD34P0CB1ETYGNYS
created: 2026-11-23T12:54:50.009581Z
updated: 2026-11-23T14:08:16.811342Z
type: task
title: Activity hides a Restricted register from people who can't open it — no name, prefix, entry ID or title in any activity line
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2104
sprint: ssj8zkq
comments:
- id: 01M849X6RHX3M0GMN9Z29X7SF6
  author: Steve Vine
  at: 2026-11-23T13:35:41.841707Z
  text: |-
    Built and merged to main: PR #2098 (e2248892e). No migration, no API change.

    What people see:
    - Someone who can't open a Restricted register sees its activity lines as "A Restricted register" or "A Restricted entry": who and when, with no name, prefix, entry ID, title or changed values.
    - Its owner, editors and administrators see every line in full.
    - The check is made on read, so restricting a register hides its past lines, and lifting the mark shows them again.
    - Asking Activity for a Restricted register's or entry's ID returns nothing, the same as an unknown ID.
    - A line about something else loses the name, for example "linked a Restricted register's file to SAP-14".

    Covered: the Activity page; the histories of plan entries, vulnerabilities, incidents, DDQs, Q&A entries, risk assessments, trust centre visitors, data subject requests, disclosures and requests to disclose; and the audit's trail and request and finding history.

    Still able to name a Restricted register, for Steve to decide:
    1. A plan entry completed by a review keeps the outcome "Done by the review of the register OBL · Name: comment" on the plan itself. Confirmed in the code (core/registers/reviews.py).
    2. The review's PDF is named after the register, and that name appears wherever the evidence is listed, including a control's assessment history. From reading the code, not checked on screen.
    3. Words someone typed, such as a register's name in a gap title or a reason. Nothing ties that text to the register.

    Decisions made while building:
    - Compass can't tell whether a deleted register was Restricted, so its lines read "A register no longer in Compass" to everyone but administrators.
    - A hidden line still shows who, when, the action, the company, and that it concerns a register or entry. Its internal ID stays in the response, so someone could tell two hidden lines are about the same thing.
    - Text elsewhere that happens to look like a hidden entry ID (such as "SAL-1") is hidden for people who can't open that register.

    Tested against real Postgres: register, entry and link lines; owner, editor and administrator; restricted later; the review's filed PDF; the audit trail. The ten record histories use real records with the activity line inserted directly; only the Activity page and plan entry history are tested through a real review. CI green.

    Not yet checked in a browser on staging: that comes with the sprint's pre-UAT pass.
- id: 01M84BRVXBPW9CKENM51P6W90E
  author: Steve Vine
  at: 2026-11-23T14:08:16.811064Z
  text: |-
    Correction to this task's opening line: Registers phase 1 HAS been released. v0.26.0 was published at 08:42 GMT on 23 Nov from 29d0849fc, and production's assistant tools now match that release, so production appears to be running it. I couldn't read production's version directly.

    So until a release carries this fix (e2248892e, not in v0.26.0), anyone in production who can view Activity can see the names and entry titles of a Restricted register they can't open. It only matters if a Restricted register exists in production. Worth checking Assurance ▸ Registers there.

    No release has been made for this: that's Steve's call.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Sprint "Registers - Phase 2". Found while building COM-2091 (23 Nov 2026) and confirmed in the code. Registers haven't been released yet, so this should be fixed before they are.

## The problem
Activity hides restricted incidents and restricted privacy requests from people who can't read them, but has no such rule for registers. Anyone who can view Activity can see lines such as "created register entry SAL-1 · Director pay band", even if they can't open that Restricted register. A register's Restricted mark is meant to limit who sees what's in it (ADR 0165).

## What people see
- Someone who can't open a Restricted register sees an activity line about it, or about one of its entries, as "A Restricted register" or "A Restricted entry": who did it and when, with no register name, prefix, entry ID, title or changed values.
- Someone who can open the register sees the line as they do today.
- This holds wherever activity is read: the Activity page, a filtered or exported view, and anything Polaris reads from it.
- A register made Restricted after the line was written is hidden too, because the check is made when the line is read.
- A line about something else that mentions a Restricted register (for example a link to one of its entries, or an evidence or audit line) names no more than the same wording.

## Implementation notes (technical)
- `api/v1/activity.py` already does this for incidents, requests and disclosures (`unreadable_incidents`, `RESTRICTED_TITLE`). Follow that pattern, using `core/registers/access.py` for who can open a register.
- Check every reader of `ActivityLog`, not only that route.
- Check every place a register or entry writes an activity line, including summaries that embed its name.

## Done when
- A person who can't open a Restricted register sees no name, prefix, entry ID, title or value of it in any activity line.
- A person who can open it, and an administrator, see the line in full.
- A register restricted after the line was written is hidden from then on.
- Tests cover register lines, entry lines, link lines and each other reader of the log.

Independent unless the response shape changes (then on the chain). No migration expected.