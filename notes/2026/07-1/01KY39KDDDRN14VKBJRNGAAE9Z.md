---
id: 01KY39KDDDRN14VKBJRNGAAE9Z
created: 2026-07-21T21:34:08.301198Z
updated: 2026-07-24T07:17:36.580854Z
type: task
title: 'Estate list: tags icon per asset, opening a tag viewer'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 207
sprint: sbeam3b
comments:
- id: 01KY4J8MRCWBBRSMKNZ3KF34WE
  author: Steve Vine
  at: 2026-07-22T09:24:46.988594Z
  text: |-
    Done — PR #189 (feature/ise-207-estate-tag-icon), top of the Sprint 19 stack (#186 → #187 → #188 → this); shares `EstatePage.tsx` and the entity list endpoint with ISE-206.

    Built exactly to the shape in the task — `tag_count` on the list row, modal fetching from the existing detail endpoint, `TagBadges` reused, no new endpoint.

    **Backend.** `EntitySummary.tag_count` from a single grouped subquery over `entity_tag`, sitting alongside the existing `alias_count` outerjoin. One refinement on the spec: the count is `COUNT(DISTINCT tag_id)`, not a row count. `env:prod` asserted by both Kubernetes and DataDog is two provenance rows and one badge, so a plain count would promise three tags and then open showing two. Test pins that case specifically.

    **Frontend.** New `components/EntityTagsModal.tsx`: Mantine `Modal` titled with the entity name, rendering through `TagBadges` so provenance tooltips and drilldown links behave identically to the detail page — reuse is the point, since re-rendering badges locally would be two things to keep in step. The query is `enabled: opened`, so viewing one row's tags does not pull the detail of every tagged row in the list. Keyed on the entity id so it remounts per subject rather than flashing the previous row's tags while the next fetch lands.

    Icon renders only when `tag_count > 0`, per the spec — an icon that is sometimes meaningless stops being read at all.

    **One thing the task didn't anticipate:** the estate table row is itself the navigation affordance (`Table.Tr onClick` → `/estate/:id`), so the icon has to `stopPropagation` or the modal opens onto a different page. There's a test for it.

    **Tests** — 1 backend integration (distinct count 2 not 3, untagged row 0), 4 frontend (`EstateTagIcon.test.tsx`): only tagged rows offer the icon; the viewer opens with the name, both tags and a working two-source provenance tooltip; nothing is fetched until the click; clicking does not navigate away.

    Backend 878 passed, ruff + mypy strict clean. Frontend 281 passed, lint/format/build clean. OpenAPI types regenerated (`dump_openapi` + `generate:api`).
assignee: steve
label: null
priority: medium
task_status: done
---
The estate list currently shows no tag presence at all (tags live only on the entity detail page) — an operator can't see which assets are labelled without opening each one. This closes the gap identified 2026-07-21 ("is that a known gap?" — it was).

- Each row in the estate list (`EstatePage.tsx`) whose entity has tags shows a tags icon (Tabler `IconTags`, consistent with the Compass/Mantine iconography).
- Clicking the icon opens a window (Mantine `Modal`) titled with the entity name, displaying all its tags — reuse `TagBadges` (`components/TagBadge.tsx`) so provenance tooltips and the drilldown links behave exactly as on the detail page.
- Backend: the list endpoint (`list_entities`, `entities.py`) doesn't carry tags today and shouldn't carry full tag payloads for every row — add a cheap `tag_count` to the list response (single grouped query over `entity_tag`, no N+1) to drive icon visibility. The modal fetches on open via the existing `GET /api/v1/entities/{entity_id}` (already returns tags) — no new endpoint.
- Icon shows only when `tag_count > 0`; empty state never renders. Regenerate OpenAPI types (`dump_openapi` + `npm run generate:api`).
- Tests: list response carries correct counts; icon renders only for tagged rows; modal shows the tags with provenance.