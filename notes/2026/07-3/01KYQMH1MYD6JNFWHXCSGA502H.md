---
id: 01KYQMH1MYD6JNFWHXCSGA502H
created: 2026-07-29T19:09:53.694717Z
updated: 2026-08-07T09:40:53.535868Z
type: task
title: CloudWatch alarms as alert signals
project: 01KX671DATY39VW6GWK3M2T3DN
number: 360
sprint: sjyt01k
blocked_by:
- 01KYQMGWJYCQQDXCA7MPZ5245E
comments:
- id: 01KYQV1STPNV1RQV0Q86YGMF5Q
  author: Steve Vine
  at: 2026-07-29T21:03:54.198478Z
  text: |-
    Built and shipped to review. PR #333 (stacked on #332), merged to staging.

    What landed: detect() pulls CloudWatch alarms in ALARM state (metric + composite) per configured region → Alert signals. source_key = alarm ARN; kind = namespace slug (ec2/rds/applicationelb/…) so per-service severity overrides apply; severity fixed at high (CloudWatch has no native ladder — the override layer is the tuning knob); entity_key derived from alarm dimensions via the discovery key scheme, left unresolved (never guessed) when dimensions name nothing we discover. Rides reconcile_findings for triggered/recurring/recovered.

    The done-when merge case is covered by a real-Postgres test: an AWS alarm and a DataDog monitor firing on the same EC2 instance produce two incidents whose merge candidates include "same affected entity" — the existing ADR 0035 machinery, no new correlation code.

    Smoke on staging: with an alarm firing in the account, Alerts should show it like any other source and auto-open an incident at the default threshold.
assignee: steve
label: null
priority: medium
task_status: done
---
`detect()` over CloudWatch DescribeAlarms → `FindingData(signal_type="alert")`.

- `source_key` = alarm ARN (stable identity); rides `sync.reconcile_findings` so triggered/recurring/recovered lifecycle comes for free.
- `entity_key` derived from alarm dimensions (InstanceId / DBInstanceIdentifier / LoadBalancer / BucketName → the discovery key scheme); `link_findings_to_entities` back-fills late-discovered entities.
- `kind` = AWS service slug so ADR 0026 per-kind severity overrides apply per integration instance.
- Dedupe/reinforcement is by design the existing path: same-entity attribution + human-gated "same affected entity" merge candidates (ADR 0035/0054) — no new cross-source architecture.

**Done when:** AWS alarms appear on the Alerts screens like any other source, auto-open incidents per threshold, and an AWS alarm + DataDog monitor on the same instance produce a "same affected entity" merge candidate.