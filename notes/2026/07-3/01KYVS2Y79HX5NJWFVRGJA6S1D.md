---
id: 01KYVS2Y79HX5NJWFVRGJA6S1D
created: 2026-07-31T09:46:32.041119Z
updated: 2026-07-31T09:46:32.041119Z
type: task
title: M365 discovery — Service Health services → third-party entities
priority: medium
task_status: backlog
assignee: steve
label: feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 400
---
Discovery slice: GET /v1.0/admin/serviceAnnouncement/healthOverviews → the tenant's ~25-30 M365 services (Exchange Online, SharePoint Online, Teams, OneDrive, Intune, …) as existing **`third-party`** entities — **NO migration** (ISE-355 Status Page precedent; EntityDetailPage already renders the type). Native keys `m365:{tenant_id}:{service_id}` via `_bounded_key`; display name from the service's displayName; attributes: service id + current status. sync_spec slice on the standard cadence. Services no longer listed at source fall to the existing last-seen retirement (estate lifecycle, ADR 0039/0040 machinery — nothing new to build). Tests: healthOverviews → entity mapping, key bounding, absent-service retirement path.