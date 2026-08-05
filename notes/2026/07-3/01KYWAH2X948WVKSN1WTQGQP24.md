---
id: 01KYWAH2X948WVKSN1WTQGQP24
created: 2026-07-31T14:51:21.385884Z
updated: 2026-08-05T11:55:41.121559Z
type: task
title: 'Docs: new section — Tags'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 436
order: 0.0001220703125
sprint: sp3en5k
blocked_by:
- 01KYWAGFZMYHV2Y0WHXM8W7N8G
comments:
- id: 01KYWBX9W4D5QXM37HZQKJH05A
  author: Steve Vine
  at: 2026-07-31T15:15:30.308002Z
  text: |-
    Done on feature/ise-436-docs-tags — PR #31 (stacked on ISE-435), left OPEN for review.

    Framed as the classification counterpart to the identity-and-relationship estate page. Covers: the unified pool with per-source provenance (two sources agreeing recorded as such; every badge can say who claims it, by what method, when last confirmed) and tags landing on both entities AND signals, which is what makes a tag a bridge between what exists and what's going wrong; the tag cloud with 24h/7d/30d alert heat, the carried-or-via-entity union so one alert counts once, and both honest UI caveats (200-tag cap stated on screen; text narrowing deliberately does NOT re-fetch because re-basing the scale would change colours as you type); drilldown contents with filters travelling; tag rules materialising real group entities with both worked examples and why it matters (an incident can say which SERVICE, and dashboards are built from them); the dictionary as many-names-one-identity with governed keys / key aliases / defined vs open value modes, and the load-bearing "maps, never rewrites — DataDog still says Prod, and that's deliberate"; fix-at-source tag writes through the normal governed pipeline with the ADR 0043 reasoning for treating retagging as a real change (durable configuration other systems key off, feedback path into ISE's own beliefs). 24 pages build. Facts from ADRs 0037/0041/0043.
assignee: steve
priority: medium
task_status: done
---
Write `src/content/docs/using-ise/tags.md`: the unified tag pool — tags ingested from every integration (K8s labels, DataDog tags, cloud resource tags) with per-integration provenance and normalisation; the Tag Cloud page with alert-count heat over a selectable window and per-tag drilldown; admin-defined tag rules (AND-ed predicates, optional integration scope) that materialise real group entities in the estate — e.g. `service:kora` → "Kora"; the tag dictionary and authority; writing tags back to the source (fix-at-source) via the per-integration tag actions.

Ground in ADRs 0037, 0041, 0043. Operator audience, released capability only.

Depends on ISE-433 (sidebar group).