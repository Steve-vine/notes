---
id: 01KZ3Q7T92WA0KHJAB4VTT2RRC
created: 2026-08-03T11:48:10.146484Z
updated: 2026-08-07T09:40:51.467387Z
type: task
title: Generic connector summary capability
project: 01KX671DATY39VW6GWK3M2T3DN
number: 495
sprint: shk7zaj
comments:
- id: 01KZ9MNYMEK5NTGGJ088MHCKRF
  author: Steve Vine
  at: 2026-08-05T18:58:54.222674Z
  text: |-
    Built — PR #482 (feature/ise-495-generic-summary → main), ADR 0083.

    WHAT LANDED
    - `Connector.summary()` returns a `SystemSummary` (title / identity / description / icon + labelled `SummarySection`s of `SummaryItem`s), served by ONE endpoint `GET /api/v1/systems/{id}/summary` and rendered by ONE component `IntegrationSummaryCard`. Neither knows any connector's name.
    - Cloudflare is served by the generic card end-to-end; its bespoke `CloudflareAccountCard` is deleted.

    THE THREE CONSTRAINTS (the actual decision, ADR 0083)
    1. The connector declares MEANING, not appearance — semantic tones (neutral/good/warn/bad), closed sets for style and icon, validated at declaration time. If a connector could say "red", restyling the app would mean editing every connector module.
    2. `summary()` takes NO ConnectorContext. It is given no credential, so it structurally cannot call the source: the card costs a few indexed counts, renders for a system whose credential has expired, and page traffic can never rate-limit somebody's cloud account (ADR 0059 §5 made structural).
    3. A connector never sees a Session. `SummaryReader` is a narrow read-only view answering a fixed set of questions in plain values — so the estate model stays free to move underneath every connector at once.

    Also: "no card" is `{"summary": null}`, not a 404 that would put a red line in the browser console on every page view of an integration that has none. An unregistered connector_type yields the same rather than a 500.

    SEMANTIC DELTA WORTH KNOWING
    One definition of "firing" now spans every card (new/triggered/recurring). Four of the old cards counted alerts in triggered/recurring only while the Freshservice card included `new` — so "active" quietly meant different things on different pages. Cloudflare's count now includes a signal in its first-seen `new` state, which it previously missed.

    TESTS
    - 13 integration tests against real Postgres, incl. the two things that were silently wrong as copied code: counting aliases instead of DISTINCT entities (ISE-469 cross-key materialisation makes that a real over-count), and reading an identity off a key whose prefix does not match.
    - 5 frontend tests, incl. renders NOTHING (not an empty card) for a null summary, and falls back to a default icon for one the UI has never heard of.

    Full backend suite green locally: 2358 passed. Frontend: 622 passed. ruff/mypy strict/eslint/prettier/build all clean.

    The remaining six connectors and the deletion of the dead `*-summary` endpoints/schemas is ISE-496 — the OpenAPI surface will SHRINK, which is a rare direction for it.

    Note for Steve: `docs/decisions/README.md`'s index was already stale (it stopped at 0076 — 0077, 0078, 0081, 0082 are all missing). I added 0083 but did not backfill the others, since 0079/0080 are the voice sprint's untracked drafts.
assignee: steve
label: null
priority: medium
task_status: done
---
Connectors describe their own System-detail summary (labelled sections of key-value/list data) via a new spec method; one generic `/api/v1/systems/{id}/summary` endpoint and one generic SummaryCard render it. Replaces the pattern behind the ten per-connector `*-summary` endpoints in `api/v1/systems.py` and the bespoke card components in `SystemDetailPage.tsx`. Done = at least one connector (e.g. Cloudflare) served by the generic card end-to-end.