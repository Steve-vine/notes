---
id: 01M0FHD3HY8R5BMC4S4A6K8BH6
created: 2026-08-20T12:12:47.038918Z
updated: 2026-08-20T14:28:04.599504Z
type: task
title: Use Graph $batch for the per-group members/owners crawl
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 315
sprint: s5yxs5a
comments:
- id: 01M0FS4STGFS73XV5GNH50VF1H
  author: Steve Vine
  at: 2026-08-20T14:28:03.535903Z
  text: |-
    Implemented in PR #309 (feature/com-315-batch-crawl, stacked on #308) — CI green.

    core/graph.py gains graph_batch (one POST /$batch, ≤20 sub-requests, id → (status, body); the POST rides the COM-312 retry and COM-313 token handling). The sync batches members + owners for 10 groups per round-trip — the crawl's bulk shrinks to roughly a twentieth. A group whose first page overflows $top=999, or whose sub-request fails, falls back to the individual paged GET. Integration tests: zero individual GETs on the happy path, overflow fallback, throttled-sub-request fallback.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
The members + owners loop is two sequential GETs per group at ~150ms each — the bulk of the ~27-minute pass. Graph's JSON `$batch` endpoint packs 20 requests per round-trip: batch the first page of members/owners for 10 groups at a time (paging the rare group with >999 members individually). Cuts the crawl to roughly a twentieth and shrinks the transient-failure window with it.