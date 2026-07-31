---
id: 01KYVNXV67JWEJ5P3SP2893CTS
created: 2026-07-31T08:51:19.367428Z
updated: 2026-07-31T08:51:19.367428Z
type: task
title: EntraID discovery — entity types migration + directory objects
label: feature
task_status: backlog
assignee: steve
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 388
---
Migration 0075 (CHECK-swap, 0074 pattern) adds entity types `user`, `identity-group`, `application`, `policy` — NOT `group`, which is taken by ADR 0037 tag-derived groups (EntityDetailPage hard-branches on it). `discover_entities`: member+guest users with minimal `$select` (id, UPN, displayName, accountEnabled, userType, createdDateTime); security groups (`isAssignableToRole` in attrs) → identity-group; service principals → application (registrations without an SP are evidence-only); CA policies (`state` in attrs) → policy. Keys `entra:{tenant}:{object_id}`, bounded. No membership edges and no cross_keys in v1 (group_members evidence covers investigation; UPN↔email joins later). Frontend ENTITY_TYPES mirrors deferred to the surface task. Tests: test_entraid_discovery.py incl. nextLink continuation.