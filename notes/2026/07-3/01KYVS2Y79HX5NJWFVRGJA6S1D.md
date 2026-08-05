---
id: 01KYVS2Y79HX5NJWFVRGJA6S1D
created: 2026-07-31T09:46:32.041119Z
updated: 2026-08-05T14:25:08.498099Z
type: task
title: M365 discovery — Service Health services → third-party entities
project: 01KX671DATY39VW6GWK3M2T3DN
number: 400
order: 1.0
sprint: s10ybrs
blocked_by:
- 01KYVS2P1BAA56XWVPVKPARTDE
comments:
- id: 01KYW3SB73RE8BXZAX6THVEVFS
  author: Steve Vine
  at: 2026-07-31T12:53:32.00374Z
  text: |-
    Built and in review — PR #372 (feature/ise-400-m365-discovery, stacked on #371).

    - discover_entities: GET /admin/serviceAnnouncement/healthOverviews → third-party entities (no migration); keys m365:{tenant}:{service_id} via _bounded_key, service id lower-cased; attributes = service id + current status
    - No edges/cross_keys/tags; failing sweep degrades to empty
    - Retirement: proven against real Postgres that a delisted service falls to the existing ADR 0039 last-seen clock (retire_unseen_entities retires exactly the absent one)
    - Tests: test_m365_discovery.py, 5 passing; ruff + mypy clean
assignee: steve
label: null
priority: medium
task_status: done
---
Discovery slice: GET /v1.0/admin/serviceAnnouncement/healthOverviews → the tenant's ~25-30 M365 services (Exchange Online, SharePoint Online, Teams, OneDrive, Intune, …) as existing **`third-party`** entities — **NO migration** (ISE-355 Status Page precedent; EntityDetailPage already renders the type). Native keys `m365:{tenant_id}:{service_id}` via `_bounded_key`; display name from the service's displayName; attributes: service id + current status. sync_spec slice on the standard cadence. Services no longer listed at source fall to the existing last-seen retirement (estate lifecycle, ADR 0039/0040 machinery — nothing new to build). Tests: healthOverviews → entity mapping, key bounding, absent-service retirement path.