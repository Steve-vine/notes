---
id: 01M16VDFMQNA17YRFGNY0Z7EYW
created: 2026-08-29T13:30:17.111727Z
updated: 2026-08-29T13:30:17.111727Z
type: task
title: 'The schedule editor: set a report''s cadence without an API call'
assignee: steve
priority: high
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 510
company: null
---
Discovery finding, 2026-08-29, from the sprint 47 tidy-up. Scheduled reports (COM-495) work end to end and are tested — but **a schedule can only be created through the API**. Nothing in the sprint's ten tasks asked for an editor: COM-495 specified the cadence, recipients and delivery; COM-490 specified Run, Download and Duplicate on the report's page; COM-491 is the wizard for the *definition*, not the schedule. So the feature is shipped and unreachable.

**On the report's page.** It already shows a read-only line — *Every week at 07:00, to 3 people — next Mon 31 Aug 07:00* — when a schedule exists. This turns that line into something a person can open, and gives a report with no schedule a way to acquire one.

**One schedule per report**, enforced by the backend. So this is edit-in-place, never an "add another schedule" list — the API is a `PUT` for that reason.

What it sets: the cadence (daily, weekly at a chosen day, monthly at a chosen date), the time, the recipients, and the format.

Points to get right, most of which the API already refuses and the UI should simply not let somebody reach:

- **The stated time is a wall clock, and the screen must say so.** 07:00 means 07:00 to the reader across a BST/GMT change. Somebody who assumes UTC and sets 08:00 to mean 09:00 local will be wrong for half the year, and will not find out from the screen.
- **Recipients are named users, so it is a person picker** — never a free-text address. The row goes when the account does, instead of mailing a leaver for ever.
- **A schedule with nobody on it is refused**, because it would produce answers nobody receives, which looks identical to a working schedule until somebody asks where the report went.
- **A weekly cadence needs a day and a monthly one needs a date.** Both are refused rather than defaulting, so the picker must ask.
- **Pause is not delete.** The `enabled` flag exists so turning a schedule off and on again does not lose its recipients — offer both, and make which is which obvious.
- **Show the next run**, which the API computes and returns. It is the one thing that tells somebody their intent was understood.

**A failing schedule should be visible from here, not only in History.** A schedule that quietly stopped is the failure mode that sends people back to running things by hand — and the three ways it can fail (the report no longer runs, the run crashed, nobody could be emailed) are already recorded as failed runs. The last of those matters most: a schedule producing answers nobody receives looks exactly like a working one.

The client half is already written and currently unused — `useSetReportSchedule` and `useDeleteReportSchedule` in `access/reportHooks.ts`, kept deliberately with a comment pointing at this task.

Backend is done: `GET`/`PUT`/`DELETE /reports/definitions/{id}/schedule`, with `next_run_at` computed on read. No API work expected.