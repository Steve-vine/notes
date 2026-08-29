---
id: 01M16VDFMQNA17YRFGNY0Z7EYW
created: 2026-08-29T13:30:17.111727Z
updated: 2026-08-29T17:02:02.513815Z
type: task
title: 'The schedule editor: set a report''s cadence without an API call'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 510
sprint: s42ntc9
comments:
- id: 01M1765FMRDR5GDRS81NTT96H9
  author: Steve Vine
  at: 2026-08-29T16:38:09.304036Z
  text: |-
    Done — PR #514, merged to main as d5c0fc6.

    The read-only schedule line on a report's page is now the way in, and a report with no schedule offers "Send this report on a schedule". Edit-in-place, one schedule per report.

    What the editor gets right, all of it things the API already refuses:
    - The time field says it is a wall clock — 07:00 means 07:00 to the people receiving it all year, and does not shift when the clocks do.
    - Recipients are a person picker over the user directory, never a typed address. Somebody already on the schedule whom the directory no longer lists is seeded into the picker, so opening the editor cannot silently unsubscribe them.
    - A schedule with nobody on it will not save, and the screen says why rather than leaving a dead button.
    - Weekly asks for a day and monthly asks for a date; neither defaults, and switching cadence clears the selector the new cadence does not have.
    - Pause and delete are separate and say which is which: a "Send on this schedule" switch keeps the recipients, a red "Remove schedule" does not.
    - The next run is shown, on the line and in the editor.

    A failing schedule is now visible from the report's page rather than only in History: if the last scheduled run failed, a red alert carries the date and the reason. A later success means it recovered and nothing is said — which covers the worst of the three failures, a report that ran and reached nobody, and looks exactly like a working schedule from the outside.

    No backend work: the endpoints and next_run_at were already there, and the two client hooks kept unused for this task are now called.

    Frontend suite green (858 tests). Ready for a look on staging.
assignee: steve
company: null
label:
- feature
priority: high
task_status: done
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