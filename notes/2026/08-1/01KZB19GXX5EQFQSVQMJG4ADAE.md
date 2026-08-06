---
id: 01KZB19GXX5EQFQSVQMJG4ADAE
created: 2026-08-06T07:58:32.893748Z
updated: 2026-08-06T07:59:23.705397Z
type: task
title: Migrate M365 licence threshold to threshold_specs
project: 01KX671DATY39VW6GWK3M2T3DN
number: 580
sprint: syjypmr
assignee: steve
label:
- tech_debt
priority: medium
task_status: backlog
---
Move the licence-exhaustion trip point (`m365.py:481-556`) onto the declared mechanism: `_LICENSE_THRESHOLD_PERCENT = 90` and its raw-JSON `license_threshold_percent` override become a declared `ThresholdSpec` (percent unit, sensible bounds), giving it typed validation and UI visibility for the first time.

Behaviour must be unchanged at the defaults: trip at ≥ threshold → medium, pool fully consumed → high, threshold echoed into `details["threshold_percent"]`. Any System that already carries a raw `license_threshold_percent` in `System.config` must keep working (same key, now validated).

Acceptance: the threshold shows up in the generic config UI for an M365 System; a staged over-threshold fixture still raises the pool-near-exhaustion observation at both rungs.