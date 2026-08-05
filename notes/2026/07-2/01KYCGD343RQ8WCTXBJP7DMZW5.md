---
id: 01KYCGD343RQ8WCTXBJP7DMZW5
created: 2026-07-25T11:26:11.075507Z
updated: 2026-08-05T14:25:16.666682Z
type: task
title: Estate context push→pull — bounded, hub-summarising, single carrier
project: 01KX671DATY39VW6GWK3M2T3DN
number: 282
sprint: svgrad3
comments:
- id: 01KYCJTJJYB550TWG3GHJAS2FA
  author: Steve Vine
  at: 2026-07-25T12:08:30.046145Z
  text: |-
    Done — PR #255 (feature/ise-282-estate-context-pull → main), CI running.

    - Dropped the force-fed _estate_context_block from the diagnose/propose/analyse prompts. Replaced with a slim always-on header: affected entity + one-hop neighbourhood size + a pointer to get_affected_entity_context. Orientation stays free; the neighbourhood is pulled when the question needs it.
    - get_affected_entity_context is now the single carrier (ends the block-AND-tool double inclusion). New pure bound_investigation_context collapses a homogeneous fan-out to a count (HUB_GROUP_CAP=8) and caps the overall list (MAX_RELATED_LISTED=40), nearest-first (hops, then name), truthfully — the bound_payload contract for the graph. Depth stays capped at 2.
    - _entity_names_for_issue (webhook matching) left unbounded on purpose; factored a shared _affected_entity helper.
    - ADR 0028 gets a dated note (refinement, not supersede).
    - Tests: test_bound_investigation_context.py (collapse/cap/ordering); test_directed_investigation.py updated (prompt now carries the header, not the XML block). Backend ruff+mypy(305) green.
assignee: steve
label: null
priority: high
task_status: done
---
**Sprint 24 tuning, batch 1. Pillar 2.** Merges ISE-264 audit recs 1+3 (catalogue L13+L14). **Decision (2026-07-25): reverses the audit's rec-3 lean** — pull, not push: the model fetches the neighbourhood only when the question needs it, which is both cheaper and smarter.

- Drop the force-fed `_estate_context_block` from the diagnose / propose / analyse prompts (`agents.py:205,296,377`). Replace with a slim always-on header: affected entity + one-hop counts, so orientation stays free.
- `get_affected_entity_context` (`tools.py:239`) becomes the single carrier, with **breadth bounded**: cap related entities (nearest by hops, then name), and summarise a hub's homogeneous fan-out to counts ("131 workloads part-of this node — list on request") — the same say-what-you-truncated contract as `bound_payload`. Depth stays capped at 2 (`estate.py`).
- One carrier, deliberately — ends the double-inclusion (prompt block AND tool).

Touches ADR 0028 (a note, not a supersede). This is the structural fix for cost scaling with estate size instead of incident difficulty.