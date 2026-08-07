---
id: 01KZDRK4EMNP40HVXZRV63C9VA
created: 2026-08-07T09:24:13.908796Z
updated: 2026-08-07T15:22:40.242454Z
type: task
title: Estate query tool v2 — attribute predicates, date comparisons, counts
project: 01KX671DATY39VW6GWK3M2T3DN
number: 593
sprint: snk16ew
comments:
- id: 01KZE5K9YJQPJRJRWXHX2J5GPK
  author: Steve Vine
  at: 2026-08-07T13:11:31.026423Z
  text: |-
    Built on feature/ise-593-estate-query-v2 — PR #518.

    What landed:

    - **Attribute predicates.** `find_estate_entities(where=[…])` takes a list of {key, op, value}, ANDed. Ops: eq / ne / contains / exists / missing / gt / gte / lt / lte / before / after / within_days. Lives in a new shared module `ISE_api.attribute_filters`, so the Assist tool and the MCP twin cannot drift.
    - **Both NULL traps contained in that module**, with the reasoning in its docstring:
      - `attributes->>k` on a missing key is NULL, not false — `ne` and `missing` use IS DISTINCT FROM / IS NULL, so a row that never had the key counts as "not that value" rather than being silently dropped.
      - A cast of the wrong text is a query-killing ERROR, not a NULL. `attributes` is schemaless (one host's `version` is "1.2.3" next to another's 3), so every numeric and date comparison is regex-guarded inside a CASE — a value of the wrong shape fails to match instead of taking the whole estate query down.
      - Dates compare as instants, not strings. `before: "now"` is the "already expired" question, so the caller never computes a date and cannot get it wrong.
    - **Count mode.** Result shape is now `{count, returned, truncated, entities}` and the count comes from the estate, not the page — this was the real defect behind "how many": fifty rows with no total reads as the set, so "fifty" is what got reported. `count_only=true` returns the number without the rows.
    - **Type list derived from ENTITY_TYPES** — it named six of twenty in prose, which is why the identity estate (user, app-registration, identity-group, secret, network) was invisible to the model. A test asserts the placeholder is substituted and the identity types appear.
    - **Retired entities excluded by default** (ADR 0039 §1) — a count that includes things gone from the world overstates the estate. `include_retired` opts back in.
    - **Filtered attributes travel back with each hit**, for the same reason the tags do: an expiry search that shows no date leaves the model to invent one.
    - A bad filter value returns an in-band error the model can correct, not an empty result it would report as "none expiring".

    Beyond the stated scope, deliberately: the MCP twin `search_estate` got the same predicates, count mode and derived type list, and the `describe_resources` estate blurb now names the identity half. The Role Matrix claims Claude Code has parity on estate reads, and leaving the MCP surface on "six of twenty types, no attribute filter" would have made that claim false while ISE-598 is about to test it. Only registered capability is claimed (Sprint 54 rule).

    No ADR: this is capability inside ADR 0023/0028, not a new decision. No migration, no OpenAPI change (the Assist tool is not an API route — snapshot regenerated, no drift).

    Tests: new `tests/integration/test_estate_attribute_queries.py` (8) covering the motivating question both ways, before-now, ANDing within a type, the missing-key trap, the ragged-cast trap, the bad-value error, count-vs-page, and the derived docstring; plus an MCP-surface test in `test_mcp_reads.py`. Full backend suite green locally: 2547 passed. ruff + mypy strict clean.

    Screen: no new surface — answers land on the existing Assist page, as scoped.
assignee: steve
label: null
priority: medium
task_status: done
---
Upgrade `find_estate_entities` (ai/assist_tools.py) so Assist can answer "which app registrations expire in the next 90 days" / "how many users have passwords expiring in 5 days":

- Attribute predicates on the entities' JSONB `attributes` — equality, substring, and date/number comparisons (mind the `attributes->>k` NULL trap).
- A count/aggregate mode so "how many" returns a number, not 200 truncated rows.
- Generate the type list in the docstring from `ENTITY_TYPES` — it currently hardcodes six types in prose while ~20 exist (user, app-registration, identity-group, secret, network…), so the model doesn't know it can look for identity objects.
- Result shape stays truncation-honest.

Screen: answers surface in the existing Assist page — proven by the ISE question-bank task. Pairs with the EntraID expiry-attributes task, which provides the data these predicates query.