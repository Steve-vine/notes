---
id: 01KYQMH8HF9JMCBBTGXYFN2ECG
created: 2026-07-29T19:10:00.751234Z
updated: 2026-08-13T19:00:02.566663Z
type: task
title: AWS evidence-on-demand
project: 01KX671DATY39VW6GWK3M2T3DN
number: 362
sprint: sjyt01k
blocked_by:
- 01KYQMGWJYCQQDXCA7MPZ5245E
comments:
- id: 01KYQVESHRMQH6K5K8XF7M03V5
  author: Steve Vine
  at: 2026-07-29T21:10:59.896382Z
  text: |-
    Built and shipped to review. PR #335 (stacked on #334), merged to staging.

    What landed: five read-only evidence queries via the standard contract — describe_resource (by ARN: EC2/RDS/EKS/ELB/S3), list_resources (type+region inventory), cloudwatch_metric_statistics (avg/max, period auto-coarsened to ~100 points), logs_filter_events, cloudtrail_lookup_events. Payloads bounded and JSON-safe; unknown queries refused; AWS failures degrade to ok=False notes in the trace. No per-surface wiring needed — diagnose, assist, issue-chat, the Claude/MCP surface and playbooks all pick the queries up through the existing evidence tools (audit + citation + timeline surfacing come with that path).

    Smoke on staging: in an incident chat, list_evidence_sources should now include the AWS integration and a pull like cloudwatch_metric_statistics on a known instance should return datapoints and show on the timeline.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
`evidence_catalogue()` / `fetch_evidence()` following DataDog's dispatch-table pattern (`datadog.py:880/943`).

Queries: `describe_resource` (by ARN), `list_resources` (type/region), `cloudwatch_metric_statistics`, `logs_filter_events` (CloudWatch Logs), `cloudtrail_lookup_events`. Bounded payloads (`bound_payload`), not-in-catalogue ⇒ refuse.

Declaring `evidence` lights up diagnose, assist, issue-chat, the Claude/MCP surface and playbooks with no per-surface wiring.

**Done when:** an investigation (issue-chat or MCP) can pull AWS evidence, the pull is audited and cited, and appears on the incident timeline.