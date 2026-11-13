---
id: 01M7B054WN2BWDJSHX7RC79Y0A
created: 2026-11-13T17:44:15.509229Z
updated: 2026-11-13T19:57:47.566174Z
type: task
title: Re-run a past period of a collected check, or run it once over a custom date range, without changing the check
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1800
sprint: spsp226
blocked_by:
- 01M7B04RXWE49D4F3VYCY61BPZ
comments:
- id: 01M7B7SJBPESBH70A9FQZSZTCP
  author: Steve Vine
  at: 2026-11-13T19:57:44.694437Z
  text: |-
    Built — PR #1795 (feature/com-1800-rerun-range), stacked on COM-1799's #1794. On the chain: migration 0839 and API changes; ADR 0153 amended. I merge it after #1794.

    What you'll see:
    - **Re-run** collects past periods again with the check's reads as they are now. The new capture becomes that period's current one; the earlier one stays in the history marked "Replaced" and in the Evidence register's lineage. Only periods that have ended; up to 60 at once.
    - **Custom range** runs the check once over any dates (up to 366 days, not ending after today) and files it as a "One-off". It doesn't move the schedule or count as a period, and the pass/fail rule never judges it.
    - Both run on the worker and show "Collecting…" until filed, or why they failed. A failed run keeps nothing and doesn't mark the check Broken.
    - Both are refused for a snapshot check, with Collect now offered instead. Both need the right to record assessments, and each is recorded in the activity log.
    - Ticked captures download as one file, or a zip for several.
    - Polaris has matching tools to re-run periods and run a range.

    Checks: integration tests cover re-run lineage, a one-off leaving schedule and rule alone, the 366-day cap, snapshot refusal, a failed run, permission and downloads of one and several; unit 2241 passed; drift clean. CI green. Real FreshService not checked (fake service in tests).
assignee: steve
label:
- feature
priority: high
task_status: review
---
Steve, 2026-11-13. Builds on COM-1799 (a capture covers its own period).

## What people see

- **Re-run** a past period, such as a week where evidence was missing or late-arriving records were missed. Compass collects that period again with the check's reads as they are now. The new capture becomes that period's current one. The earlier capture stays in its history (the evidence lineage, ADR 0122) and is never lost.
- **Custom range**, a one-off: pick any from and to dates. Compass runs the check over exactly that range and adds the capture to the check's history, marked **One-off** with its range. It doesn't move the schedule, doesn't count as a scheduled period, and doesn't change the check's reads, schedule or rule.
- Both run on the worker. The entry shows "Collecting…" until it's filed, or why it failed. A failed run keeps nothing, as today, and doesn't mark the whole check Broken.
- A **snapshot** check (how something is set up) can't be read for the past. Re-run and Custom range are unavailable for it, saying why, and it offers **Collect now** instead.
- Only someone who can approve checks can re-run or run a range. Everything is recorded in the activity log.

## Decisions (made, say if wrong)

- A range is capped at 366 days, and at the read's own item and size limits. Anything bigger is refused with the reason, before it runs.
- A rule (pass/fail) is judged only on scheduled captures, never on a one-off range.

## Done when

- The API can re-run one or more periods and run one custom range for a records check. Both are refused for a snapshot check.
- A re-run files a new version of that period's capture with the old one in its history. A range files a one-off capture.
- The schedule and the check's settings are unchanged after either.
- Tests cover a re-run replacing in lineage, a one-off not affecting the schedule or rule, the cap, and the refusal for snapshots.

**On the chain** (API). Blocked by COM-1799; COM-1801 builds the screen.