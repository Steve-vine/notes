---
id: 01M14W6DSK4K8A91HBM1V6BRHW
created: 2026-08-28T19:05:25.555086Z
updated: 2026-08-29T11:59:37.640046Z
type: task
title: 'Scheduled reports: a cadence, recipients, and mail that arrives'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 495
sprint: s42ntc9
blocked_by:
- 01M14W60YF3HHYYS7A8BZZKKFP
comments:
- id: 01M16P7FN8M7GA8BRZ1HQPV9HS
  author: Steve Vine
  at: 2026-08-29T11:59:37.637083Z
  text: |-
    Done and merged to main — PR #502, migration 0147_report_schedules.

    A report carries one schedule (unique constraint, so it is a PUT rather than a POST — two would produce two histories under one name). Cadence, wall-clock time, named recipients, format. Delivery is `mail.send_or_warn` with the report attached; no bespoke sender, and the test patches at that shared function precisely to assert it.

    All four "points to get right" are covered, and two needed more than they looked:

    **Wall-clock.** There was no timezone concept in the app at all, so this introduces `Settings.schedule_timezone` (default Europe/London) and stores `at_time` naive. There are parametrised tests either side of the change: at 07:00 local the schedule fires at 06:01 UTC in July and 07:01 UTC in December. Stored as UTC it would have fired an hour early every day for half the year.

    **Idempotency.** Done through the run ledger as the task specified, not a last-fired column: `report_runs.schedule_step` under a *partial* unique index on (definition_id, schedule_step). A worker restarting inside the step finds it claimed; two workers racing lose one to the index. Partial so ad-hoc runs, which have no step, stay unconstrained. Beat runs every 15 minutes so a schedule can state 07:30 and be no more than a quarter hour late; a pass with nothing due is one query.

    **Empty still sends**, and says "nothing to report as at <date>" in the body.

    **Failure is a row** in three ways, and the third is the one I would not have thought of from the task alone: the report ran, was kept, and *no recipient could be emailed*. That run is marked failed even though the answer was produced — a schedule producing answers nobody receives otherwise looks identical to a working one until somebody asks where the report went.

    Two smaller decisions: a claimed step is not retried within the step (the alternative is a broken schedule mailing its failure every fifteen minutes), and monthly clamps to the length of a short month so a report set for the 31st still arrives in February. A weekly or monthly cadence with no day is refused rather than defaulting to Monday and the 1st, and a schedule with no recipients is refused too — both would otherwise fire on something nobody chose.

    `next_run_at` is computed on read rather than stored: a stored one needs recomputing on every edit and every clock change, and would be wrong exactly on the morning after the clocks went back.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: review
---
ADR 0062 §5. A report can carry a schedule: daily, weekly or monthly at a stated time, a list of recipients, and a format.

Delivery is mail like all other mail (ADR 0055) — the report declares what it produced and the existing transport sends it. Do not write a bespoke sender.

A scheduled run is a run (COM-494): it lands in the history with its snapshot, so *the report was sent, and this is what it said* is one record, not two.

Points to get right:

- **Beat crontabs are wall-clock.** A schedule stated as 07:00 must mean 07:00 to the reader, across a BST/GMT change.
- **Idempotent, by the cadence step.** A worker restart inside the hour must not send twice; the run ledger is what decides whether a step has already happened.
- **An empty result still sends, and says it is empty.** *Nothing to report* is the answer a governance reader most needs to receive on time; silence is indistinguishable from a broken job.
- **A failed run is visible in the library**, not only in the logs. A schedule that quietly stopped is the failure mode that makes people go back to running things by hand.

Recipients are named users; the run executes with the scoping of the report's company, never with the recipient's rights.