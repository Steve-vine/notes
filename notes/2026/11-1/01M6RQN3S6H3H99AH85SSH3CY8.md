---
id: 01M6RQN3S6H3H99AH85SSH3CY8
created: 2026-11-06T15:29:21.702469Z
updated: 2026-11-07T11:12:16.200737Z
type: task
title: A check's read can say where its items sit in the answer, so services whose list endpoints wrap items differently (GitHub search, /installation/repositories) read every item instead of failing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1622
sprint: s5khbev
comments:
- id: 01M6TVB21KM3D3ZBCZFWEGND02
  author: Steve Vine
  at: 2026-11-07T11:12:15.411449Z
  text: |-
    **Done: merged to main in PR #1640. It reaches staging with the rest of sprint 107.**

    **What it does:** each read in a check can now say where that endpoint keeps its list. GitHub's `/installation/repositories` wraps it in `repositories`, and search wraps it in `items`, while most of GitHub's lists are plain arrays. Without its own setting, a read uses the integration's, as before.
    - **It applies everywhere:** on every page, to the first-capture sample and to every collection.
    - **Polaris sets it** when it designs a check and its test read shows a wrapped list.
    - **You can see it** wherever the read is shown, e.g. "GET /installation/repositories (items at repositories)" on the sample, the capture and its evidence page.
    - **You can edit it** in a check's Advanced reads, as `items`.

    **Tested:** an integration set up for plain lists reads a wrapped endpoint across several pages and gets every item. Without the setting it says in words that the answer isn't a list.

    **Couldn't check:** it hasn't been tried against real GitHub. That's for the pre-UAT pass after deploy. If the key can't reach `/installation/repositories`, a search read will do.

    **To look at on staging:** ask Polaris for a check on a control that needs GitHub's repository list.
assignee: steve
label:
- bug
priority: medium
task_status: review
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