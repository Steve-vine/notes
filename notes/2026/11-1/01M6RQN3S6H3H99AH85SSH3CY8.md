---
id: 01M6RQN3S6H3H99AH85SSH3CY8
created: 2026-11-06T15:29:21.702469Z
updated: 2026-11-06T15:41:31.85589Z
type: task
title: A check's read can say where its items sit in the answer, so services whose list endpoints wrap items differently (GitHub search, /installation/repositories) read every item instead of failing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1622
sprint: s5khbev
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Found by Steve while testing on staging (2026-11-06). Polaris flagged it when defining GitHub: "A few list endpoints (e.g. search, /installation/repositories) put their items inside an object (items, repositories) instead of returning a bare array. The item path depends on the endpoint."

## The problem

Where the items sit in each answer is set once, on the integration's paging. Most GitHub lists return a bare array, but some wrap it (`items`, `repositories`, `workflow_runs`, and so on). A check reading one of those either fails with "The answer has no … where Compass expected the items" or, without paging, takes the wrapper object as a single item. Other services do the same (one key per resource).

## Done when

- A read in a check can name its own item path, which overrides the integration's for that read. Without one, the read uses the integration's, as now.
- When Polaris designs a check it fills in the item path from the sample answer if the integration's doesn't fit. The person sees it with the read and can edit it, the same way as the read's other details.
- The first-capture sample and every collection use it, on every page.
- A test: an integration whose paging items is "" (bare array) reads a wrapped endpoint through a read with `items: "repositories"` over two pages and gets every item.
- On staging, a GitHub check reading /installation/repositories (or a search) collects the right items.

## Where

- `core/collection/client.py`: `_items` and `items_path`, taken from `paging.get("items")` in the paged read.
- `core/collection/polaris_design.py`: the read spec.
- The check's read editor in the frontend.