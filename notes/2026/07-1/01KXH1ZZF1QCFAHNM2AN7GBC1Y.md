---
id: 01KXH1ZZF1QCFAHNM2AN7GBC1Y
created: 2026-07-14T19:34:51.617156832Z
updated: 2026-07-21T15:30:36.066237Z
type: task
title: Global search API
project: 01KX671DATY39VW6GWK3M2T3DN
number: 71
sprint: syz8rn1
blocked_by:
- 01KXH1WFKCER3XHQY1GQMRYRFR
assignee: steve
label: null
priority: medium
task_status: done
---
**There is no search of any kind in ISE today** — no full-text, no trigram, no `ILIKE`, no `q=` param anywhere. Every list endpoint offers exact-match filters only (`status`, `severity`, `system_id`).

ui-brief:46 — *"global search (systems, issues, changes) reachable via keyboard"*.

## `GET /api/v1/search?q=&limit=`

Searches the free-text columns that actually exist:

- `System.name`, `System.description`
- `Issue.title`, `Issue.description`
- `ProposedChange.operation`, `ProposedChange.rationale`
- `Finding.title`

Returns results grouped/tagged by entity type, each with the `(entity_type, entity_id, title, href)` shape — **reuse the `ResolvedCitation` resolver from ISE-64** rather than writing a second entity→link mapping. Two mappings would drift.

## Implementation: `ILIKE`, not an extension

At single-org scale (hundreds to low thousands of rows) `ILIKE '%q%'` with a bounded limit is entirely adequate, and it needs **no new Postgres extension**.

Deliberately **not** `pg_trgm`: it requires `CREATE EXTENSION`, which the CNPG-provisioned application role may well not hold — introducing a migration that fails on the real cluster but passes against the testcontainer. Note trigram (typo tolerance, ranked similarity, GIN index) as the documented upgrade path if and when search gets slow or fuzzy matching is wanted.

Rank simply: exact/prefix matches above substring matches; cap results per type.

**RBAC-filtered** — the API is the authority. A viewer must not see, via search, anything they could not see by navigating.

Blocked by: ISE-64.