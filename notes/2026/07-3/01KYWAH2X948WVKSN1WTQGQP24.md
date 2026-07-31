---
id: 01KYWAH2X948WVKSN1WTQGQP24
created: 2026-07-31T14:51:21.385884Z
updated: 2026-07-31T14:56:06.315042Z
type: task
title: 'Docs: new section — Tags'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 436
order: 0.0001220703125
sprint: sp3en5k
blocked_by:
- 01KYWAGFZMYHV2Y0WHXM8W7N8G
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Write `src/content/docs/using-ise/tags.md`: the unified tag pool — tags ingested from every integration (K8s labels, DataDog tags, cloud resource tags) with per-integration provenance and normalisation; the Tag Cloud page with alert-count heat over a selectable window and per-tag drilldown; admin-defined tag rules (AND-ed predicates, optional integration scope) that materialise real group entities in the estate — e.g. `service:kora` → "Kora"; the tag dictionary and authority; writing tags back to the source (fix-at-source) via the per-integration tag actions.

Ground in ADRs 0037, 0041, 0043. Operator audience, released capability only.

Depends on ISE-433 (sidebar group).