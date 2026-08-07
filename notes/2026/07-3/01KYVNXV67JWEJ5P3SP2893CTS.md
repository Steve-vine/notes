---
id: 01KYVNXV67JWEJ5P3SP2893CTS
created: 2026-07-31T08:51:19.367428Z
updated: 2026-08-07T10:06:51.00367Z
type: task
title: EntraID discovery — entity types migration + directory objects
project: 01KX671DATY39VW6GWK3M2T3DN
number: 388
order: 1.25
sprint: setdxf2
blocked_by:
- 01KYVNXP4JNJZX38JKK1VZM9EF
comments:
- id: 01KYVSQ6TWVKAXA5ZBXTKWY1TF
  author: Steve Vine
  at: 2026-07-31T09:57:36.220585Z
  text: |-
    Built and pushed — PR #365 (feature/ise-388-entraid-discovery, stacked on #364).

    Delivered: migration 0075 (user / identity-group / application / policy via CHECK-swap; identity-group kept distinct from the tag-derived group type) + discover_entities sweeping users (member+guest, minimal $select), security groups (isAssignableToRole captured for the ADR 0064 story), service principals as application entities (keyed by SP object id), and CA policies (state captured). Tenant-scoped keys entra:{tenant}:{object_id}, lower-cased and bounded. No edges/cross_keys/tags in v1, per plan.

    Tests: 13 new incl. the real-Postgres 0075 constraint + reconcile join, per-slice degradation, and an assertion that the sync asks Graph for the minimal projection only. Migration suite, ruff, mypy strict all green.
assignee: steve
priority: medium
task_status: done
---
Migration 0075 (CHECK-swap, 0074 pattern) adds entity types `user`, `identity-group`, `application`, `policy` — NOT `group`, which is taken by ADR 0037 tag-derived groups (EntityDetailPage hard-branches on it). `discover_entities`: member+guest users with minimal `$select` (id, UPN, displayName, accountEnabled, userType, createdDateTime); security groups (`isAssignableToRole` in attrs) → identity-group; service principals → application (registrations without an SP are evidence-only); CA policies (`state` in attrs) → policy. Keys `entra:{tenant}:{object_id}`, bounded. No membership edges and no cross_keys in v1 (group_members evidence covers investigation; UPN↔email joins later). Frontend ENTITY_TYPES mirrors deferred to the surface task. Tests: test_entraid_discovery.py incl. nextLink continuation.