---
id: 01KYQMH8HF9JMCBBTGXYFN2ECG
created: 2026-07-29T19:10:00.751234Z
updated: 2026-07-29T19:33:58.826692Z
type: task
title: AWS evidence-on-demand
project: 01KX671DATY39VW6GWK3M2T3DN
number: 362
sprint: sjyt01k
blocked_by:
- 01KYQMGWJYCQQDXCA7MPZ5245E
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
`evidence_catalogue()` / `fetch_evidence()` following DataDog's dispatch-table pattern (`datadog.py:880/943`).

Queries: `describe_resource` (by ARN), `list_resources` (type/region), `cloudwatch_metric_statistics`, `logs_filter_events` (CloudWatch Logs), `cloudtrail_lookup_events`. Bounded payloads (`bound_payload`), not-in-catalogue ⇒ refuse.

Declaring `evidence` lights up diagnose, assist, issue-chat, the Claude/MCP surface and playbooks with no per-surface wiring.

**Done when:** an investigation (issue-chat or MCP) can pull AWS evidence, the pull is audited and cited, and appears on the incident timeline.