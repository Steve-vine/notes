---
id: 01KZRTWFR6882VSVZ2RKBGTC5M
created: 2026-08-11T16:35:56.294202Z
updated: 2026-08-11T16:35:56.294202Z
type: task
title: 'Business Application: included entities — direct and inferred'
label: feature
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 655
---
On the Business Application detail page, show **the full blast radius as a list of entities with details**, in two sections.

**1. Direct** — entities the rules matched (tag matching). Grouped by the rule that matched them, so it is clear *why* each entity is included, and a rule that matched nothing is visible in place.

**2. Inferred** — entities the direct ones depend on. Derived by **downstream** traversal from members (`traverse(direction="downstream")` steps source→target, `estate.py:33,38`) over `runs-on` / `depends-on` / containment `part-of` — excluding group and identity-group targets, never `composes`, bounded depth. Show the edge/path that reached each one so "why is this cluster listed" is answerable.

This is what makes the cluster a **dependency rather than a member**: it stays out of the membership count (keeping "3 of 18 affected" honest) while still appearing in the blast radius.

Each row carries entity details — type, name, scope/containment, environment, current signal state — and links through to the entity.

**Nothing here is stored.** The dependency set is computed on read from whatever membership resolves to now, so it never goes stale as workloads recycle. There is no dependency definition to maintain.

New backend read: `GET /api/v1/business-applications/{id}/entities` returning both sets with their provenance (which rule / which edge path).