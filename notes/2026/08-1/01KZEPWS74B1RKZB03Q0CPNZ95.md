---
id: 01KZEPWS74B1RKZB03Q0CPNZ95
created: 2026-08-07T18:13:47.36426Z
updated: 2026-08-09T20:03:09.889971Z
type: task
title: 'Report scheduling: dispatcher, reaper, retention'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 617
sprint: sw5yz4n
blocked_by:
- 01KZEPWMCT0YGPY8MG1Q9NZP6Z
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Scheduled reports fire on their own. `dispatch_report_runs` beat tick (60s, `_expiring()`-wrapped; module added to worker `include` + registration test): due enabled reports FOR UPDATE SKIP LOCKED → pending ReportRun with spec_snapshot, worker-side `next_run_at` recompute in the dispatch txn, enqueue; same tick re-enqueues pending stragglers >5min (NotificationDelivery pattern). `reap_stale_report_runs` beside the existing reaper (default 1800s). `prune_report_runs` daily: keep newest 20 per report / 90 days, delete the S3 object first and skip the row if that fails (no orphans). New settings knobs.

Done = a report scheduled for 07:00 appears at 07:00 and next_run_at advances; a killed worker's run gets failed by the reaper. No migration. Depends on the runs task.