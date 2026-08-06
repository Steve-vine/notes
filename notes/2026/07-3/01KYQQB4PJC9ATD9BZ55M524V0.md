---
id: 01KYQQB4PJC9ATD9BZ55M524V0
created: 2026-07-29T19:59:05.938558Z
updated: 2026-08-06T08:34:21.282461Z
type: task
title: Azure evidence-on-demand
project: 01KX671DATY39VW6GWK3M2T3DN
number: 368
sprint: s0d5f5q
blocked_by:
- 01KYQQA7N6RWFYHQ148JMVWA8H
comments:
- id: 01KYQZWWAC8F0TT4PNF7CP44H3
  author: Steve Vine
  at: 2026-07-29T22:28:35.788531Z
  text: |-
    Built and in review — PR #341 (feature/ise-368-azure-evidence, stacked on #340), merged to staging.

    Five self-describing read-only queries per the ADR 0031 contract: describe_resource (ANY resource type — api-version comes from the discovery pins where known, else resolved live from the provider's own metadata, stable preferred over preview, so an investigator can describe a Redis cache we don't discover); list_resources (the six inventories, databases fans across all three DB providers, bounded 200); monitor_metrics (Average+Maximum per interval, minute grain ≤2h then coarsened); activity_log (the CloudTrail analogue — caller/operation/status, optionally scoped to a resource id, deliberately single-page); log_analytics_query (KQL against a workspace GUID — the Log Analytics API lives on its own host with its own token scope, so ArmClient grew a post() + per-scope token cache; optional, degrades where no workspace exists).

    Azure-side failures degrade to ok=False with the error as the summary — never a raise, never a dead run. 10 new tests; ruff/mypy clean.
assignee: steve
label: null
priority: medium
task_status: done
---
Mirror of ISE-362. Connector evidence tools per the ADR 0031 capability contract, exposed to investigation surfaces: resource describe (full ARM resource JSON), Azure Monitor metrics for an entity, Activity Log (the CloudTrail analogue — who changed what, when), and Log Analytics/KQL queries where a workspace is configured (optional, degrade gracefully without one).