---
id: 01KZTWB16809BB4TRJV0D9ZTA8
created: 2026-08-12T11:39:50.344251Z
updated: 2026-08-12T11:39:50.344251Z
type: task
title: 'Region: a fourth role, and a region on every rule'
assignee: steve
priority: high
task_status: backlog
label: feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 663
---
The model half of ISE-662. Key-agnostic throughout — the Region role's binding is read at resolution time, so which tag key carries region stays configuration.

**Backend**
- `TAG_ROLES` gains `region` (migration: the `tag_role.role` check constraint), plus a seed binding and the Tag Dictionary roles panel slot.
- `Rule` gains `region: str | None`, resolved against the Region role's key exactly as `environment` is against the Environment role's. `rule_members` appends a third predicate when set. NOT an extra free predicate — a rule stays `{role|key} + value + environment + region`.
- `BusinessApplication.region` — nullable String(200). Identity becomes `(app_name, environment, region)`.
- **`display_name(app, env, region)`** → `chinwag-v2.prod.uk`, falling back to `chinwag-v2.prod` when regionless. Every surface reads this, so it is the one place the dotted form is decided.
- `detect_candidates` seeds (app, env, region) triples where all three resolve; the (app, env) pair remains valid where no region is stated.

**The uniqueness trap — do not miss this.** Postgres treats NULLs as DISTINCT in a unique constraint, so `(chinwag-v2, prod, NULL)` twice would both be accepted and the identity would silently fork. Use `NULLS NOT DISTINCT` (PG15+) or a unique index over `coalesce(region, '')`. Cover it with a migration data-path test that inserts the duplicate and expects the failure — zero-to-head proves nothing here.

**Also**
- `existing_identity` (the case-insensitive duplicate guard from ISE-654) must consider region.
- Migration is a widening: existing rows get `region = NULL` and read exactly as they do today.