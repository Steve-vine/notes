---
id: 01KY2QT0D6FXMHJND0WABBB305
created: 2026-07-21T16:23:09.990508Z
updated: 2026-07-24T12:32:42.023773Z
type: task
title: Child incidents are not nested in the incidents list — implement or amend ADR 0035
project: 01KX671DATY39VW6GWK3M2T3DN
number: 195
sprint: skj7tft
assignee: steve
label: null
priority: medium
task_status: done
---
**Follow-up from ISE-178 (released to main 2026-07-21).** ADR 0035 §6 says children "appear **nested under their master** and via an explicit filter". Only the second half was built, so the accepted ADR currently describes something the code does not do.

## What shipped instead

- Children hidden from the queue by default (`master_id IS NULL`), shown flat via the **Show merged** switch (`include_children=true`).
- Each child row carries a **C** badge whose tooltip names its master and links to it; masters carry **M**.
- The master's detail page has a collapsible **children section** listing every merged incident, with per-child Detach and Promote.

So the relationship is reachable in both directions — it just isn't drawn as a tree.

## Why it stopped there

Nesting rows in a `created_at`-sorted, paginated table degrades badly: a child whose master falls on another page has nothing to nest under, and grouping client-side per page produces orphans that look like a bug. Doing it properly means either master-first server-side ordering with children as a sub-collection, or dropping pagination for the nested view.

## The decision

Two honest resolutions — this task is to pick one, not necessarily to build:

1. **Implement nesting.** Needs a server-side ordering change so a master and its children arrive together regardless of pagination. Non-trivial; only worth it if the flat view actually reads badly in use.
2. **Amend ADR 0035 §6** to describe the flat-plus-indicators view. ADRs are append-only and never rewritten (ADR 0001), so this is a superseding note or a new ADR, not an edit.

Prefer (2) unless the flat view proves confusing once there are real master/child groups on staging — the information is all present, and the ADR was written before the pagination interaction was understood.

## DoD

The accepted decision record and the shipped behaviour agree.