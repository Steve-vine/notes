---
id: 01M59PWNEMYYNK5RMQ925MYEDG
created: 2026-10-19T09:11:42.29268Z
updated: 2026-10-19T19:47:55.005679Z
type: task
title: Reporting an incident from the User Portal asks for a title, the same as recording one in Compass
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1114
sprint: serbigk
comments:
- id: 01M5AV9H7YF9P3N9ZHRFNCC1WT
  author: Steve Vine
  at: 2026-10-19T19:47:52.702051Z
  text: |-
    Done — PR #1117 merged to main (103a5f4e), 2026-10-19 20:48 BST. Goes to staging once all nine sprint-76 follow-ups are in Review.

    - Title is now the first field on Report an incident in the User Portal: required, up to 300 characters (the same as recording one in Compass), e.g. "Strange email asking for my password".
    - Sending without a title is refused with "Give it a title.", alongside the other missing-field messages.
    - The incident gets exactly that title — handlers see it in their email, on Actions and in the register. Compass no longer makes a title from the first line of "What happened".
    - My reports and the reporter's own view of a report show their title as they sent it, even after a handler renames the incident at triage.
    - Reports made before this change show what they showed before.
    - The assistant's report-an-incident tool asks for a title too.

    My calls:
    - Incident Details doesn't show the reporter's original title. Handlers see the reporter's title until they change it themselves; say if you want "Reported as titled: …" shown after a rename.
    - The handlers' email still labels it "In their words:" (the wording you accepted in COM-1077); only its source changed.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 76 follow-up. Requested by Steve smoke-testing staging, 2026-10-19. Builds on portal reporting (COM-1077).

## Today

**Report an incident** in the User Portal asks what happened, when, what kind of thing it seems to be, the company, what it affects and files, but no title. Compass makes one from the first line of "What happened", cut at 60 characters. Recording an incident inside Compass asks for a title directly.

## What people see

- **Title** is the first field on Report an incident: required, a short line ("Laptop left on a train", "Strange email asking for my password"), with the same length limit as in Compass (300 characters).
- The handlers' email, Actions, the register and the incident show the reporter's title.
- **My reports** and the reporter's own view of a report show it.
- As now, the handler can change the title at triage. The reporter's view keeps their own words: their original title as sent, like "What happened".

## Rules

- A report without a title is refused with "Give it a title", alongside the other missing-field messages.
- Reports already made keep their generated title.
- The assistant's report-an-incident tool (`incidents_report`) takes a title too.

## Notes (technical)

- `api/v1/portal_incidents.py` `report_an_incident`: add a `title` form field; `core/incident_report.py` `report_incident` uses it instead of `title_from(what_happened)`. `title_from` can go once nothing calls it.
- If the reporter's original title is kept separate from a handler's edit, store it with the report text (the same place `what_happened` reads from in `reports_out`).
- `pages/PortalReportIncidentPage.tsx`: field and validation; update `PortalIncidentReports.test.tsx` and `tests/test_incident_portal_report.py`. Regenerate `schema.d.ts` (the route docstring and form change it).

**Done when:** a report from the User Portal can't be sent without a title, and the title given is what the handlers see in their email, Actions and the register.