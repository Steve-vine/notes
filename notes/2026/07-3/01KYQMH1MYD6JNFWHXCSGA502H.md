---
id: 01KYQMH1MYD6JNFWHXCSGA502H
created: 2026-07-29T19:09:53.694717Z
updated: 2026-07-29T19:10:17.462038Z
type: task
title: CloudWatch alarms as alert signals
project: 01KX671DATY39VW6GWK3M2T3DN
number: 360
sprint: sjyt01k
blocked_by:
- 01KYQMGWJYCQQDXCA7MPZ5245E
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
`detect()` over CloudWatch DescribeAlarms → `FindingData(signal_type="alert")`.

- `source_key` = alarm ARN (stable identity); rides `sync.reconcile_findings` so triggered/recurring/recovered lifecycle comes for free.
- `entity_key` derived from alarm dimensions (InstanceId / DBInstanceIdentifier / LoadBalancer / BucketName → the discovery key scheme); `link_findings_to_entities` back-fills late-discovered entities.
- `kind` = AWS service slug so ADR 0026 per-kind severity overrides apply per integration instance.
- Dedupe/reinforcement is by design the existing path: same-entity attribution + human-gated "same affected entity" merge candidates (ADR 0035/0054) — no new cross-source architecture.

**Done when:** AWS alarms appear on the Alerts screens like any other source, auto-open incidents per threshold, and an AWS alarm + DataDog monitor on the same instance produce a "same affected entity" merge candidate.