---
id: 01KZRTWFR6882VSVZ2RKBGTC5M
created: 2026-08-11T16:35:56.294202Z
updated: 2026-08-11T21:46:47.154683Z
type: task
title: 'Business Application: included entities — direct and inferred'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 655
sprint: sj9fsph
comments:
- id: 01KZSCNNFJXTTMGRW2XGNFS919
  author: Steve Vine
  at: 2026-08-11T21:46:47.154586Z
  text: |-
    Done — PR #607, on main after ISE-654.

    `GET /api/v1/business-applications/{id}/entities` returns both sets with provenance, and the detail page renders each as its own section with type, name, scope, environment, signal state and a link through.

    **Direct** carries the rule ids that claimed each entity, so "why is this included" is answerable per row — and a human-asserted member is visibly claimed by nobody, which is a real distinction the old flat member table blurred.

    **Inferred** is a bounded downstream walk over `runs-on` / `depends-on` / containment `part-of`, never `composes`. Following `composes` would fold the layer into its own dependencies — a Business Application depending on the things it's made of — so there's a test asserting the edge type is absent from the walk list, not just that the result looks right.

    The split does what the brief said it would: the cluster stays out of the membership count while still appearing in the radius. `test_included_entities_splits_members_from_what_they_depend_on` covers containment reaching namespace→cluster **and** the group not coming along — `part-of` filtered by target type, since dropping the key would lose containment with it.

    Three edge cases worth having found:
    - **A dependency shared by two members is listed once**, at its shallowest path. Otherwise a two-workload Business Application on one host lists that host twice.
    - **A member is never its own dependency.** Where a workload runs on a host that's also a member, the host must not appear in both sections — the two would disagree about what it is.
    - **Nothing is stored**, so there's no staleness path to test and no dependency definition to maintain, exactly as designed.

    One small refactor: added `environments.stated_environments` for the list read. `environments_of` reloads the tag dictionary on every call, so a 200-entity blast radius would have been 200 dictionary reads — reaching into the private `_stated` from another module was the alternative and worse.
assignee: steve
label:
- feature
priority: high
task_status: active
---
On the Business Application detail page, show **the full blast radius as a list of entities with details**, in two sections.

**1. Direct** — entities the rules matched (tag matching). Grouped by the rule that matched them, so it is clear *why* each entity is included, and a rule that matched nothing is visible in place.

**2. Inferred** — entities the direct ones depend on. Derived by **downstream** traversal from members (`traverse(direction="downstream")` steps source→target, `estate.py:33,38`) over `runs-on` / `depends-on` / containment `part-of` — excluding group and identity-group targets, never `composes`, bounded depth. Show the edge/path that reached each one so "why is this cluster listed" is answerable.

This is what makes the cluster a **dependency rather than a member**: it stays out of the membership count (keeping "3 of 18 affected" honest) while still appearing in the blast radius.

Each row carries entity details — type, name, scope/containment, environment, current signal state — and links through to the entity.

**Nothing here is stored.** The dependency set is computed on read from whatever membership resolves to now, so it never goes stale as workloads recycle. There is no dependency definition to maintain.

New backend read: `GET /api/v1/business-applications/{id}/entities` returning both sets with their provenance (which rule / which edge path).