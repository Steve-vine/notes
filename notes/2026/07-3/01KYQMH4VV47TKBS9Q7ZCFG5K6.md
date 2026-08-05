---
id: 01KYQMH4VV47TKBS9Q7ZCFG5K6
created: 2026-07-29T19:09:56.987806Z
updated: 2026-08-05T13:25:52.876584Z
type: task
title: AWS Health events as alert signals
project: 01KX671DATY39VW6GWK3M2T3DN
number: 361
sprint: sjyt01k
blocked_by:
- 01KYQMH1MYD6JNFWHXCSGA502H
comments:
- id: 01KYQV7WHXANRBRZWWEQ1TKK0W
  author: Steve Vine
  at: 2026-07-29T21:07:13.597263Z
  text: |-
    Built and shipped to review. PR #334 (stacked on #333), merged to staging.

    What landed: open AWS Health events as Alert signals — one global sweep in detect(). source_key = event ARN; category → ladder (issue→high auto-opens, scheduledChange→low, accountNotification→info); entity attribution from affected entities (ARN or instance id via the discovery key scheme, UNKNOWN stays unattributed); latest description batched in with a bounded excerpt.

    The support-plan caveat is handled as specified: SubscriptionRequiredException logs one quiet info line and the Health slice is simply absent — CloudWatch alarms keep flowing and the sync stays green (covered by a dedicated test).

    Smoke on staging: on the current account (likely no Business plan) expect no Health signals and no sync errors; alarms unaffected.
assignee: steve
label: null
priority: medium
task_status: done
---
Second alert source inside `detect()`: AWS Health API events (open, account-affecting) → alert signals.

- `source_key` = event ARN; entity attribution from affected-entity ARNs where the event carries them.
- **Caveat:** the Health API requires a Business/Enterprise support plan — must degrade gracefully (capability probe / clear health message, alarms keep flowing) when the account lacks it.

**Done when:** Health events surface as alerts on accounts that have the API, and accounts without it show a clear degraded-capability state instead of sync errors.