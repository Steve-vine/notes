---
id: 01M7B054WN2BWDJSHX7RC79Y0A
created: 2026-11-13T17:44:15.509229Z
updated: 2026-11-13T17:44:15.509229Z
type: task
title: Re-run a past period of a collected check, or run it once over a custom date range, without changing the check
task_status: todo
priority: high
label: feature
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1800
---
Steve, 2026-11-13. Builds on COM-1799 (a capture covers its own period).

## What people see

- **Re-run** a past period, such as a week where evidence was missing or late-arriving records were missed. Compass collects that period again with the check's reads as they are now. The new capture becomes that period's current one. The earlier capture stays in its history (the evidence lineage, ADR 0122) and is never lost.
- **Custom range**, a one-off: pick any from and to dates. Compass runs the check over exactly that range and adds the capture to the check's history, marked **One-off** with its range. It doesn't move the schedule, doesn't count as a scheduled period, and doesn't change the check's reads, schedule or rule.
- Both run on the worker. The entry shows "Collecting…" until it's filed, or why it failed. A failed run keeps nothing, as today, and doesn't mark the whole check Broken.
- A **snapshot** check (how something is set up) can't be read for the past. Re-run and Custom range are unavailable for it, saying why, and it offers **Collect now** instead.
- Only someone who can approve checks (`posture_record_assessments`) can re-run or run a range. Everything is recorded in the activity log.

## Decisions (made, say if wrong)

- A range is capped at 366 days, and at the read's own item and size limits. Anything bigger is refused with the reason, before it runs.
- A rule (pass/fail) is judged only on scheduled captures, never on a one-off range.

## Done when

- The API can re-run one or more periods and run one custom range for a records check. Both are refused for a snapshot check.
- A re-run files a new version of that period's capture with the old one in its history. A range files a one-off capture.
- The schedule and the check's settings are unchanged after either.
- Tests cover a re-run replacing in lineage, a one-off not affecting the schedule or rule, the cap, and the refusal for snapshots.

**On the chain** (API).