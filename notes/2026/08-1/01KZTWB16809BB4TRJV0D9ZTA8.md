---
id: 01KZTWB16809BB4TRJV0D9ZTA8
created: 2026-08-12T11:39:50.344251Z
updated: 2026-08-12T12:59:41.101829Z
type: task
title: 'Region: a fourth role, and a region on every rule'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 663
sprint: sj9fsph
comments:
- id: 01KZV0X7NDK2KGG0BHT57H77C3
  author: Steve Vine
  at: 2026-08-12T12:59:41.101643Z
  text: |-
    Done — PR #613, merged as 1e2afce. Migration 0130.

    `TAG_ROLES` gains `region`, seeded to **`geo`** — deliberately not to `region`, which is a different vocabulary at a different level. `Rule.region` resolves against the binding exactly as environment does; `BusinessApplication.region` is the nullable third component of the identity; `display_name` yields `chinwag-v2.prod.uk` or falls back to `chinwag-v2.prod`.

    **Both traps in the brief were real and are now covered:**

    - **`NULLS NOT DISTINCT`.** Without it two regionless `chinwag-v2.prod` rows both insert and one identity silently becomes two. `existing_identity` coalesces to match, because SQL's three-valued logic would otherwise say neither duplicate equals the other — the guard would have passed and the constraint would have been the only thing standing. The migration test inserts exactly that pair.
    - **`existing_identity` considers region**, so `chinwag-v2.prod.uk` and `.us` coexist while a second `.uk` is refused.

    **Two things I decided beyond the brief:**

    - **A region stated against an unbound Region role reports `unresolvable`, not zero members.** "Nothing is in the UK" and "ISE does not know which tag means region" have different fixes — ADR 0056's rule, which the brief applied to roles generally but not to this new one.
    - **The region joins the proposal fingerprint only when stated.** An estate with no region tagging keeps the fingerprints it already has, so settled rejections stay remembered rather than every candidate being re-asked under a new key.

    **The 0130 downgrade deliberately refuses** where two Business Applications differ only by region: collapsing them back to one identity would have to delete one, and guessing which is not a migration's to do. It fails loudly instead.

    Backward compatibility is pinned by a test: a regionless Business Application reads and behaves exactly as before — `region = NULL`, `app.env` display, unchanged fingerprints.
assignee: steve
label:
- feature
priority: high
task_status: review
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