---
id: 01M5NBJRAV0X4G4Q75WMDNS4VF
created: 2026-10-23T21:44:56.411981Z
updated: 2026-10-24T12:19:22.365688Z
type: task
title: A new DDQ's first History line says "created ddq DDQ-None" — the reference isn't known yet when the line is written
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1275
sprint: shig2cj
comments:
- id: 01M5PXKVPHWGQ8E59NAPYSDD4X
  author: Steve Vine
  at: 2026-10-24T12:19:21.425315Z
  text: |-
    Done — merged in #1285.

    What changed: a new DDQ's first line in History and in Admin ▸ Activity now names it: "created DDQ-7 · Northwind Legal". It used to say "created ddq DDQ-None". The DDQ now gets its number the moment it's logged, before that line is written, the same way incidents and risk assessments already did.

    My calls:
    1. I checked the other DDQ and Q&A library records. None of them takes its name from a number in the same way, so nothing else needed fixing.
    2. The one bad line already on staging stays, because the activity log can't be edited.

    To check on staging: log a test DDQ and look at the first line of its History.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Sprint 85, DDQ-2. Seen on staging while looking into Steve's DDQ-1 (2026-10-23): the activity log's first line for the DDQ reads "created ddq DDQ-None · Client 1". Every later line correctly says "DDQ-1".

The DDQ's number comes from its sequence when the row is inserted, but the History line is worded before that.

**Chain:** independent (no migration, no API change)

## What people see

- The DDQ's History and Admin ▸ Activity say "created DDQ-1 · Client 1" from the first line.

## Notes (technical)

- Take the number from `ddq_number_seq` before flush (as risk assessments do for RA-n), or have the label fall back to the row after flush.
- Check the same for library entries and any other DDQ table whose label uses a sequence-made reference.
- Existing rows: the one bad line on staging can stay. The activity log is append-only, and the fix only needs to stop it happening again.

**Done when:** logging a DDQ writes "created … DDQ-n" in History, with a test.