---
id: 01KYCGD343RQ8WCTXBJP7DMZW5
created: 2026-07-25T11:26:11.075507Z
updated: 2026-07-25T11:27:08.472111Z
type: task
title: Estate context push→pull — bounded, hub-summarising, single carrier
project: 01KX671DATY39VW6GWK3M2T3DN
number: 282
sprint: svgrad3
assignee: steve
label:
- improvement
- follow_up
priority: high
task_status: backlog
---
**Sprint 24 tuning, batch 1. Pillar 2.** Merges ISE-264 audit recs 1+3 (catalogue L13+L14). **Decision (2026-07-25): reverses the audit's rec-3 lean** — pull, not push: the model fetches the neighbourhood only when the question needs it, which is both cheaper and smarter.

- Drop the force-fed `_estate_context_block` from the diagnose / propose / analyse prompts (`agents.py:205,296,377`). Replace with a slim always-on header: affected entity + one-hop counts, so orientation stays free.
- `get_affected_entity_context` (`tools.py:239`) becomes the single carrier, with **breadth bounded**: cap related entities (nearest by hops, then name), and summarise a hub's homogeneous fan-out to counts ("131 workloads part-of this node — list on request") — the same say-what-you-truncated contract as `bound_payload`. Depth stays capped at 2 (`estate.py`).
- One carrier, deliberately — ends the double-inclusion (prompt block AND tool).

Touches ADR 0028 (a note, not a supersede). This is the structural fix for cost scaling with estate size instead of incident difficulty.