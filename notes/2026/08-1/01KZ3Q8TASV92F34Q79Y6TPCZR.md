---
id: 01KZ3Q8TASV92F34Q79Y6TPCZR
created: 2026-08-03T11:48:42.969488Z
updated: 2026-08-08T07:16:29.03318Z
type: task
title: Entities from a pack
project: 01KX671DATY39VW6GWK3M2T3DN
number: 503
sprint: s1mg25q
comments:
- id: 01KZF8ZMAM9J6PR34FGP41D80E
  author: Steve Vine
  at: 2026-08-07T23:29:55.028289Z
  text: |-
    Done — PR #538 (branch feature/ise-503-pack-entities, stacked on #537).

    A pack's `entities` mappings now produce `EntityData` — native keys, tags, cross-keys, edges — and `discover_entities` hands them to the same `reconcile_discovered` every connector uses. Nothing downstream knows a pack was involved: identity harvest, tag reconcile, lifecycle, the graph. That's what mapping onto the existing contract rather than beside it buys.

    **`packs/values.py`** — resolves one selector against one item; deliberately dull, and the dullness is the feature. Two behaviours carry weight beyond their size:

    - **An absent value stays absent** — `prefix` is NOT applied to nothing. An entity whose optional `parent_id` is missing produces *no* edge, rather than an edge to a bare `acme:widget:`. That would be a real key pointing at a real entity, and nothing in the estate could tell it was a bug. The same asymmetry makes an optional `entity_key` mean "this alert names no entity" instead of "this alert is about the prefix".
    - **A number resolves as the string a source would have written**, so `map: {1: high}` matches whether or not the source quoted its JSON. Otherwise the mapping would silently depend on a source's serialisation choice.

    Timestamps take ISO 8601 or epoch seconds/millis, auto-detected by *plausibility range* rather than by guessing magnitude. A value parsing as neither is treated as absent — a signal dated to 1970 sorts to the bottom of every view and nobody ever sees it, which is a quieter way of losing it than dropping it would have been.

    **`packs/mapping.py`** — the contract here is that **one bad record costs that record**. Ten thousand widgets with one missing a name produce 9,999 entities and a tally by cause, not an exception that leaves the estate as it was and the integration red. The tally is logged only when non-empty: a silent skip is how "the pack works" and "the pack drops half the estate" come to look identical, and `1,400 skipped: name did not resolve` points an author at the field rather than at the document. Keys over 300 chars are skipped as bad records — the ISE-368 lesson, where one oversized composite key killed a whole sync.

    **Discovery fetches once per DISTINCT endpoint**, not once per mapping. A source whose single list holds both apps and their databases is an ordinary shape, and paying for the same pages twice is a cost the pack author has no way to see or avoid.

    Tests: 11 value-resolver, 9 mapping/connector, and 5 integration tests that drive a pack through the **real** `sync_one` against real Postgres — entities in the estate, aliases under this integration, the `dns:` cross key published for the Cloudflare join, a declared edge becoming a real `EntityEdge`, tags landing in the pool with provenance, a malformed record costing only itself, and a 503 from the source turning the card red with a readable reason while nothing else notices.

    Same order-independence trap as ISE-501: module-shared DB + pytest-randomly means per-test system names *and* per-test entity keys, or assertions pass or fail on ordering.
assignee: steve
label: null
priority: medium
task_status: done
---
Pack-declared endpoint + JSONPath mappings produce `EntityData` (native keys, tags, cross-keys, edges) through the normal `discover_entities` → `reconcile_discovered` path; source-of-record declared in the pack, rung-1 entity types only. Done = a pack-defined integration's entities visible in the Estate list and graph.