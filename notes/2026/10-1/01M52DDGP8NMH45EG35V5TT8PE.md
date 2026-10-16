---
id: 01M52DDGP8NMH45EG35V5TT8PE
created: 2026-10-16T13:11:27.688035Z
updated: 2026-10-16T13:11:32.775737Z
type: task
title: The assistant can use the Access Reports library — run a report and hand back the rows with a download link, and write, schedule and share report definitions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1021
sprint: scj9zdp
assignee: steve
label:
- feature
priority: medium
task_status: todo
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