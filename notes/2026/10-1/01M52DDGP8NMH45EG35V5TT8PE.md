---
id: 01M52DDGP8NMH45EG35V5TT8PE
created: 2026-10-16T13:11:27.688035Z
updated: 2026-10-16T18:15:32.783928Z
type: task
title: The assistant can use the Access Reports library — run a report and hand back the rows with a download link, and write, schedule and share report definitions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1021
sprint: scj9zdp
blocked_by:
- 01M52D9HBAHAHJ7C3D97Y3FSCB
comments:
- id: 01M52YT9YT41VNVSWYZGYTGFGB
  author: Steve Vine
  at: 2026-10-16T18:15:32.570182Z
  text: |-
    Done — merged to main (PR #1007); goes to staging with the rest of the sprint.

    The assistant can now read the Reports library and what each report asks, run a report (up to 200 rows inline, the total, and the same download link as the screen's Download button — CSV or PDF), try a draft before saving, read run history and past runs, and see the catalogue of what can be asked. With "Manage report definitions" it can write, edit, duplicate, import and delete reports (delete flagged destructive), and set or remove a schedule (setting it emails the recipients; removing is flagged destructive).

    My calls:
    - A report can be written using the wizard's own words ("Users", "Sign-in name", "is more than") or the catalogue's keys. Anything that doesn't fit is refused at save in the screen's words.
    - Running through the assistant keeps nothing in the history, the same as pressing Run on screen; opening the download link does.
    - Export (as text) is open to anyone who can see Access Control, as on screen; import needs the Admin grant.
    - Schedule recipients are named colleagues or "me"; the day is a weekday name; setting a schedule replaces the whole schedule.
    - A past run is picked by its time as the history shows it (UTC), or "latest". A run kept as a PDF comes back as its link only.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 72, MCP - Access Control (ADR in COM-1012). Built on COM-1013.

The Reports tab inside Access Control is a library of saved reports about the directory and its governance, for example "everyone with a privileged role who hasn't signed in for 90 days". It is a different thing from Overview ▸ Reports, which the assistant already generates.

## What people can ask of it

- **Read (for a named company):**
  - the library, and what each report asks;
  - **run a report.** The assistant hands back its rows with a download link for the file, as Overview ▸ Reports does;
  - **try a draft** before saving it: the wizard's subject, question, columns, filters and sort, previewed against live data;
  - a report's run history, any past run's rows, and its schedule;
  - what can be asked: the catalogue of subjects, columns and filters.
- **Write (whatever the person's role allows on screen; today that is the Admin grant *Manage report definitions*):**
  - write a new report, edit one, duplicate it, or delete it;
  - export a report as text to share, or import one from text;
  - set or remove its schedule, which emails the report to its recipients.
- **Example:** "Write a report of shared mailboxes whose owner has left, preview it, then save it and send it to me every Monday."

## Notes (technical)

- Wraps `report_definitions.py`:
  - reads (`access.view`): catalogue, definitions, run, download, preview, runs and schedule;
  - writes (`admin.manage_report_definitions`): POST, PATCH, DELETE, duplicate, import, and schedule PUT/DELETE.
- Return the rows inline up to a cap (say 200), then the total and a `link()` to `/definitions/{id}/download` or `/runs/{id}/download`, as `tools/reports.py` does.
- **The catalogue is what lets the assistant write a valid definition.** Describe it in the create tool, or have the create tool point the assistant to read it first. A definition that doesn't fit the catalogue is refused at save with the route's message.
- Delete and remove-schedule are `destructive`. Set-schedule's description says it emails the recipients.
- New module `tools/access_reports.py`. Prefix `access_`, to keep it apart from `overview_*` reports.
- Tests: writes are hidden without the Admin grant; a run returns rows and a link; an invalid definition is refused readably; a definition saved through the assistant is recorded via assistant.

**Done when:** on staging, the assistant writes and saves a new report from a plain-English question, runs it, and the download link opens the file.