---
id: 01KYQQBC67WKFWZ94TT5KAHTM1
created: 2026-07-29T19:59:13.607257Z
updated: 2026-08-05T12:53:05.663654Z
type: task
title: Azure surface — subscription card on System detail
project: 01KX671DATY39VW6GWK3M2T3DN
number: 369
sprint: s0d5f5q
blocked_by:
- 01KYQQA7N6RWFYHQ148JMVWA8H
comments:
- id: 01KYR0BB5KNEZYF74X6D9YCB33
  author: Steve Vine
  at: 2026-07-29T22:36:29.747863Z
  text: |-
    Built and in review — PR #342 (feature/ise-369-azure-system-card, stacked on #341), merged to staging.

    The sprint's pane-of-glass slice: GET /systems/{id}/azure-summary (viewer role) returns subscription id (read off the subscription-scoped aliases), per-type discovered resource counts, and the active alert count — computed entirely from ISE's own record, no Azure round-trip per page view. AzureSubscriptionCard renders on System detail for azure systems: identity badge, count badges, red/green alert badge. Deliberately simpler than the AWS card — no region editor, because ARM is global (ADR 0059 §5) and there is nothing to configure. One task-body delta: no tenant shown — the tenant id lives only inside the encrypted credential and surfacing it would mean a credential reveal per page view; the subscription identity carries the card.

    OpenAPI + schema.d.ts regenerated (the sprint's only API-shape change). Rollup test against real Postgres covers all six entity types + firing-alert count. Full frontend suite green (77 files / 435 tests; one ClusterLink load-flake on first run, known issue). Entities land in the estate list/graph with existing type icons — load-balancer/bucket icons shipped with the AWS sprint, workload/host/cluster/database predate it.
assignee: steve
priority: medium
task_status: done
---
Mirror of ISE-363 (the sprint's pane-of-glass deliverable). Azure subscription card on System detail, matching the AWS account card: subscription name + id, tenant, per-resource-type discovery counts, last-sync freshness, open alert counts. Discovered entities visible and navigable in the estate list/graph with correct type icons for the new/reused types.