---
id: 01M7BKCDGS5D6ZY0GZPJYP5SRE
created: 2026-11-13T23:20:16.665649Z
updated: 2026-11-14T00:01:00.325223Z
type: task
title: 'Small leftovers seen in round-6 pre-UAT: Collect now on a broken check says what happened, a deleted integration is named, Polaris uses the pen-test report''s screen state'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1809
sprint: spsp226
comments:
- id: 01M7BNPZVE5T7J2RN7Q4REGD7K
  author: Steve Vine
  at: 2026-11-14T00:01:00.27076Z
  text: |-
    Done — PR #1801 (auto-merge on). No migration and no API shape change.
    - Collect now on a check whose integration was deleted is refused, with the reason under the buttons: "The Collection integration this check reads was deleted, so nothing can be collected. Ask Polaris to re-create the check, or switch it off." On a check that's Broken for another reason (e.g. sign-in), it's accepted and says "Trying it again…", with what happens next. A "Collecting" line followed by a failed row would need a new kind of history entry, which I judged too big for this task.
    - Checks ▸ Overview reads "1 check reads a Collection integration that was deleted", with "Ask Polaris to re-create them, or switch them off". This applies to staging's existing ACC.13 row as well.
    - Evidence tab as a Viewer: the three "not found" errors came from asking for the latest Polaris job on the check, which a Viewer can't see. That request now answers "none", so the console is clean.
    - Polaris's pen-test report list, single report and "which report?" prompt use the screen's words: Being reviewed, Confirmed, Withdrawn.
    Not done: the batch Collect now on Checks still queues checks whose integration was deleted (they just stay Broken).
    Tests added. Unit suite, integration, lint, tsc and drift checks pass.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Seen in the pre-UAT pass of sprint 116 round 6 on staging (2f72416b), 2026-11-13. These were not caused by round 6 and are older than it.

## What people see

- **Collect now on a Broken check:** pressing it now says what happened. Either it shows "Collecting" and then a failed row with the reason, or it's refused with the reason (e.g. "The Collection integration this check reads was deleted"). Today it's accepted silently and nothing changes. This was seen on E2E Test Company's ACC.13 check.
- **Checks ▸ Overview:** a check whose integration was deleted reads "1 check reads a Collection integration that was deleted". Today it reads "1 check reading A Collection integration can't run".
- **The Evidence tab as a Viewer:** opening it no longer logs "not found" errors in the browser console. It currently does on ACC.13 in E2E Test Company; Admin sees none.
- **Polaris and pen-test reports:** Polaris's list and single-report view use the same state words as the screen. Today the list calls a withdrawn import "being reviewed", and the single view calls a report under review "draft".

## Done when

- Each of the above reads as described, with a test for each.

**Independent** (no migration expected).