---
id: 01M7BKCDGS5D6ZY0GZPJYP5SRE
created: 2026-11-13T23:20:16.665649Z
updated: 2026-11-13T23:20:53.472061Z
type: task
title: 'Small leftovers seen in round-6 pre-UAT: Collect now on a broken check says what happened, a deleted integration is named, Polaris uses the pen-test report''s screen state'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1809
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: active
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