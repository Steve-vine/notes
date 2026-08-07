---
id: 01KZ3Q875ZTTT18Q6DFVDJDXY7
created: 2026-08-03T11:48:23.35968Z
updated: 2026-08-07T12:15:53.101682Z
type: task
title: Frontend entity-type lists generated, not hand-mirrored
project: 01KX671DATY39VW6GWK3M2T3DN
number: 499
sprint: shk7zaj
comments:
- id: 01KZ9SY3ZQRNSDDGTV4XJJE876
  author: Steve Vine
  at: 2026-08-05T20:30:44.727387Z
  text: |-
    Built — PR #487 (feature/ise-499-generated-entity-types → main), ADR 0086. Independent of the other four.

    FOUND A LIVE DRIFT
    The three hand-copied lists had ALREADY diverged: the kind-dictionary editor was missing `secret`, so an operator could not map a Kubernetes Secret CRD to the entity type ISE-517 added for exactly that. Nothing failed — the option was simply not there, which reads as a product decision rather than a bug. That is the characteristic failure of a mirrored vocabulary, and it is why this task was worth doing.

    WHAT LANDED
    `GET /api/v1/meta` (already the endpoint for static facts about the deployment) now carries `entity_types`; one `lib/entityTypes` module consumes it; the three lists are gone.

    THE LOAD-BEARING DETAIL IS *HOW* IT IS DECLARED
    As an ENUM, not a bare `string[]` — `Field(json_schema_extra={"enum": list(ENTITY_TYPES)})` — so the vocabulary rides the OpenAPI snapshot. Three things follow:
    1. `generate:api` moves `schema.d.ts` whenever the vocabulary moves, so a new type reaches every picker through the step the workflow already runs;
    2. CI's api-types check reddens on a stale snapshot — drift becomes a FAILING BUILD rather than a quietly missing option;
    3. the frontend gets a real union type (`EntityType`) for compile-time safety alongside the runtime list.

    Fetched once with `staleTime: Infinity`: the list is static per deployment, and a picker must not flicker or go briefly empty because a window regained focus.

    DELIBERATELY NOT GENERATED
    `EntityGraphView`'s TYPE_ICON map keeps its unknown-glyph fallback. A map from type to ICON cannot be served (there is no icon in the database), and its degradation is honest — a new type draws as "ISE does not know what this is yet" rather than as a wrong answer. The guard distinguishes the two by the ARRAY form (`'kubernetes-service',` as an element) rather than by an exclusion list: a list of options must be served, because an unknown member there is a filter that cannot find the thing it was added for; a map keyed by the vocabulary may be hand-written provided it degrades to a stated fallback.

    TESTS
    - A guard enumerating every page/component source that fails if any re-declares an entity-type array — the check the three "mirrors the backend" comments were standing in for. VERIFIED it fails when a literal list is reintroduced.
    - A backend test asserting the OpenAPI schema carries the vocabulary as an enum, since that is what makes `generate:api` propagate it at all.

    Full backend suite green locally: 2346 passed. Frontend: 620 passed. ruff/mypy strict/eslint/prettier/build clean.

    ADR 0086 also records which other canonical tuples (EDGE_TYPES, RISK_TIERS, SIGNAL_TYPES) would get the same treatment, and why none is served today: a vocabulary is exposed when something consumes it, not pre-emptively.

    FOR THE STAGING SMOKE: the kind-dictionary "Is a" dropdown now offers the full vocabulary including `secret` — the gap that motivated the check.
assignee: steve
label: null
priority: medium
task_status: done
---
`ENTITY_TYPES` is manually copied in three places (`EstatePage.tsx:45`, `TagDictionaryCard.tsx:34`, `SystemDetailPage.tsx:790`). Expose the canonical list via the API/OpenAPI snapshot and consume it in one shared module; the `EntityGraphView` icon map keeps its safe fallback. A new entity type then reaches the frontend via the existing generate:api step alone.