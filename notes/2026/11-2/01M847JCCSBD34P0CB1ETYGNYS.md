---
id: 01M847JCCSBD34P0CB1ETYGNYS
created: 2026-11-23T12:54:50.009581Z
updated: 2026-11-23T19:36:29.514326Z
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
- id: 01M84EPTMC1R5P1KKFT3SJYK5P
  author: Steve Vine
  at: 2026-11-23T14:59:35.691943Z
  text: |-
    Pre-UAT on staging e2248892e: the main check COULDN'T be done, and ONE LINE FAILED.

    Accounts: E2E Admin A, E2E Viewer, E2E Analyst, E2E Assessor. E2E Test Company.

    Why the main check couldn't be done: on staging only the Admin role has "View the activity log", and an administrator can open every register. So no test account can read Activity and also be barred from a Restricted register. E2E Analyst gets "You need an Admin permission" on the Activity page, E2E Viewer's request for Activity is refused, and E2E Assessor's account doesn't hold the permission. Analyst and Assessor get "Audit not found" on the test audit, so an audit's trail can't be read by them either; Viewer's role has no audit permission. Making a role for this would be an Admin change, which this pass doesn't do.

    - A person who can't open the register sees no name, prefix, ID, title or value in any activity line: COULDN'T CHECK.
    - A person who can open it, and an administrator, see the line in full: PASSED on the Activity page, FAILED on an audit's trail.
      - Activity page, as Admin A: lines read in full, e.g. "archived register URS · E2E UAT 122 Restricted".
      - Audit AUD-5's Activity tab and request UAT-4's History, as Admin A: "Added a Restricted register, as at 23 Nov 2026 to request UAT-4". The name is hidden from the register's own owner, who is also an administrator, though the same request lists it by name just above. See 03-admin-request-history.png. Low severity: it hides too much, not too little.
    - A register restricted after the line was written is hidden from then on: COULDN'T CHECK, for the same reason.
    - Tests cover each reader of the log: COULDN'T CHECK. Not visible in a browser.

    Related, seen as E2E Viewer on COM-2088: an entry's History reads "Linked to a Restricted entry", with no name.

    What Steve should try: give a test person a role with only "View the activity log", then read Activity for a Restricted register's lines, and again after restricting a register that wasn't. This matters most for production, where v0.26.0 doesn't yet carry this fix.

    Screenshots: ~/compass-uat/sprint-122/COM-2104/
assignee: steve
label:
- bug
priority: high
task_status: done
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