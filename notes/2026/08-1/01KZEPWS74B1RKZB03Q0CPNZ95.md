---
id: 01KZEPWS74B1RKZB03Q0CPNZ95
created: 2026-08-07T18:13:47.36426Z
updated: 2026-08-13T19:00:27.322487Z
type: task
title: 'Report scheduling: dispatcher, reaper, retention'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 617
sprint: sw5yz4n
blocked_by:
- 01KZEPWMCT0YGPY8MG1Q9NZP6Z
comments:
- id: 01KZP1521CKPXYG0F8CXM7VHPV
  author: Steve Vine
  at: 2026-08-10T14:27:45.324154Z
  text: |-
    Built and pushed as PR #579 (branch feature/ise-617-report-scheduling, stacked on ISE-616 / PR #578). No migration, no api-types change.

    **Two real bugs the tests found, both of which would have shipped and both quiet:**

    1. **A Python `None` on a JSONB column is stored as the JSON value `null`, not SQL NULL.** So `schedule IS NOT NULL` was TRUE for EVERY on-demand report — the dispatcher selected them all and `ReportSchedule.model_validate(None)` blew up inside the tick. In production it would have read as "every on-demand report tries to fire every minute". Fixed with `JSONB(none_as_null=True)` on the column: Python-side, so no migration, and ISE-615 has not reached staging yet so there are no rows to repair.
    2. **`name` is a reserved `LogRecord` attribute.** Passing it in `extra` raises "Attempt to overwrite 'name' in LogRecord" — turning a *handled* schedule fault into an unhandled logging one. Renamed to `report_name`. Worth remembering generally: the Platform Log's `extra` payload cannot use `name`, `message`, `args`, `levelname`, `module`, `pathname`, `lineno`, `exc_info`.

    Decisions:
    - **Catch up, do not replay.** A worker down all weekend comes back to a report whose time passed three times, runs it ONCE and advances to its next real firing. Four catch-up PDFs is noise, and the third one is not about Thursday anyway.
    - **A schedule that no longer computes disables its report, loudly** — it would otherwise stay due for ever and re-dispatch on every tick, the 2026-08-07 self-sustaining-backlog shape in miniature. The run it was already due for is still written; only the future is stopped.
    - **The straggler sweep has a grace period** and excludes ids dispatched in the same call — "any pending" would re-enqueue a run merely waiting its turn, doubling the work under exactly the load that caused the delay.
    - **Retention deletes the OBJECT before the ROW.** The obvious order leaks: the key lives only on the row, so a failed object delete after a successful row delete leaves a file nothing in ISE can ever name again. Two rules ORed (newest N per report, nothing over M days), ranked per report with a window function so a daily report cannot bury a monthly one. In-flight runs are never pruned.

    20 real-Postgres tests, including SKIP LOCKED proved with a second session holding the lock, and one that asserts the dispatcher's recomputed `next_run_at` equals the pure function's, so the worker and the API cannot drift into two arithmetics. The `_FakeStore` double is used ONLY for the order-of-operations tests — a working bucket cannot demonstrate what happens when a delete fails.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
Scheduled reports fire on their own. `dispatch_report_runs` beat tick (60s, `_expiring()`-wrapped; module added to worker `include` + registration test): due enabled reports FOR UPDATE SKIP LOCKED → pending ReportRun with spec_snapshot, worker-side `next_run_at` recompute in the dispatch txn, enqueue; same tick re-enqueues pending stragglers >5min (NotificationDelivery pattern). `reap_stale_report_runs` beside the existing reaper (default 1800s). `prune_report_runs` daily: keep newest 20 per report / 90 days, delete the S3 object first and skip the row if that fails (no orphans). New settings knobs.

Done = a report scheduled for 07:00 appears at 07:00 and next_run_at advances; a killed worker's run gets failed by the reaper. No migration. Depends on the runs task.