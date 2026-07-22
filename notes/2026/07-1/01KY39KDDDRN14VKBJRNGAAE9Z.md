---
id: 01KY39KDDDRN14VKBJRNGAAE9Z
created: 2026-07-21T21:34:08.301198Z
updated: 2026-07-22T08:31:18.088009Z
type: task
title: 'Estate list: tags icon per asset, opening a tag viewer'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 207
sprint: sbeam3b
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
The estate list currently shows no tag presence at all (tags live only on the entity detail page) — an operator can't see which assets are labelled without opening each one. This closes the gap identified 2026-07-21 ("is that a known gap?" — it was).

- Each row in the estate list (`EstatePage.tsx`) whose entity has tags shows a tags icon (Tabler `IconTags`, consistent with the Compass/Mantine iconography).
- Clicking the icon opens a window (Mantine `Modal`) titled with the entity name, displaying all its tags — reuse `TagBadges` (`components/TagBadge.tsx`) so provenance tooltips and the drilldown links behave exactly as on the detail page.
- Backend: the list endpoint (`list_entities`, `entities.py`) doesn't carry tags today and shouldn't carry full tag payloads for every row — add a cheap `tag_count` to the list response (single grouped query over `entity_tag`, no N+1) to drive icon visibility. The modal fetches on open via the existing `GET /api/v1/entities/{entity_id}` (already returns tags) — no new endpoint.
- Icon shows only when `tag_count > 0`; empty state never renders. Regenerate OpenAPI types (`dump_openapi` + `npm run generate:api`).
- Tests: list response carries correct counts; icon renders only for tagged rows; modal shows the tags with provenance.