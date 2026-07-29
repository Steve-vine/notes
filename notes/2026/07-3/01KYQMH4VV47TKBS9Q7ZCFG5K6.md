---
id: 01KYQMH4VV47TKBS9Q7ZCFG5K6
created: 2026-07-29T19:09:56.987806Z
updated: 2026-07-29T19:10:13.046541Z
type: task
title: AWS Health events as alert signals
project: 01KX671DATY39VW6GWK3M2T3DN
number: 361
sprint: sjyt01k
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Second alert source inside `detect()`: AWS Health API events (open, account-affecting) → alert signals.

- `source_key` = event ARN; entity attribution from affected-entity ARNs where the event carries them.
- **Caveat:** the Health API requires a Business/Enterprise support plan — must degrade gracefully (capability probe / clear health message, alarms keep flowing) when the account lacks it.

**Done when:** Health events surface as alerts on accounts that have the API, and accounts without it show a clear degraded-capability state instead of sync errors.