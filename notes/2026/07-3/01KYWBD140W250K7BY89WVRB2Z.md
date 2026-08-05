---
id: 01KYWBD140W250K7BY89WVRB2Z
created: 2026-07-31T15:06:37.056512Z
updated: 2026-08-05T14:25:18.593543Z
type: task
title: 'Freshservice foundation: connector, client, credentials, ADR 0068'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 439
order: 1.25
sprint: s5pft6a
comments:
- id: 01KYX4K5NSDV3FBX5GMK2WS5C1
  author: Steve Vine
  at: 2026-07-31T22:26:52.729708Z
  text: |-
    Done — PR #386, CI green (backend, backend-lint, api-types, secret-scan).

    Delivered `connectors/freshservice.py` (connector + `FreshserviceClient`), ADR 0068, the brief row, and 24 contract tests over `httpx.MockTransport`.

    **Two capability omissions worth recording, both deliberate:**
    - **No `entities`** — no CMDB sync in scope, so nothing touches `ENTITY_TYPES` and there is no migration. ADR 0068 §2 argues it positively rather than as an omission: a CMDB is a human-maintained *assertion* about the estate, so importing it would create a second, staler source of truth competing with discovery for the same identities.
    - **No `alerts`** — Freshservice runs no detection layer for ISE to defer to (ADR 0025). Every statement ISE makes about tickets is its own inference, so they are Observations carrying a confidence, and a single ticket raises nothing.

    **Transport notes:** Basic auth is base64 of `api_key:X`. Pagination follows the `Link` header, which httpx parses natively via `response.links` — no page arithmetic to get wrong. The 429 retry is capped at 30s so a hostile `Retry-After` cannot park a worker, and the 50-page runaway guard *logs* when hit rather than silently truncating a detection window. `health_check` reads `/agents/me` because naming the owning agent is what surfaces a read/write key mix-up at verify time.

    `validate_credential` deliberately does **not** reject a non-`freshservice.com` host — structural checks only; whether the host answers is `health_check`'s question.

    `api_key` was already on `REDACTED_KEY_PARTS`, so definition-of-done item 2 needed no change.

    **Also corrected two stale claims in the connectors brief** found while adding the row: the M365 entry still said "Deferred" though it shipped under ADR 0066, and the "the deferred five stay deferred" note had outlived all five.

    Verification: 24 connector tests, 252 connector/registry/capability tests, `ruff`, `ruff format`, `mypy` (461 files) all clean. OpenAPI snapshot verified byte-identical — no endpoints added.
assignee: steve
label: null
priority: medium
task_status: done
---
Foundation for the Freshservice integration (two-way: tickets as a signal source + ticket creation). No CMDB/asset sync — tickets only.

**Connector** — `connectors/freshservice.py`, `connector_type = "freshservice"`. Capabilities `{observations, evidence, actions}` — **no `entities`** (avoids the `ENTITY_TYPES` CHECK constraint entirely, so no migration). `sync_spec(slices=[])`.

**Client** — `FreshserviceClient` over httpx, modelled on `CloudflareClient`: `page`/`per_page` pagination (max 100, `link` header carries next), one bounded `Retry-After` retry on 429 (limits are plan-tiered, 100-500/min with a tighter List-Tickets sub-limit), `build_client` seam for `MockTransport` tests.

**Credentials** — `credential_spec()` = `domain` (not secret, e.g. `acme.freshservice.com`) + `api_key` (secret). Auth is HTTP Basic with Base64 of `api_key:X` (`X` a dummy password). `api_key` is **already in `REDACTED_KEY_PARTS`** — definition-of-done item 2 needs no change; note it in the PR. `validate_credential` for structural checks. `health_check` on `GET /api/v2/agents/me` — cheapest authenticated call, and it names the owning agent so verify surfaces both a domain mismatch and an accidentally-identical read/write key.

**ADR 0068** (`docs/decisions/0068-freshservice-connector.md`; 0066 is the closest template) covering: ticket signals as Observations not Alerts; the events layer as ticket storage; task-layer detection; entity-less signals and what is lost; the feedback-loop cut; the T1 justification. Must explicitly address the `product-vision.md:49` non-goal *"Not a general ITSM"* — that non-goal **stands**: ISE reads Freshservice as a detection source and writes exactly one artefact; queues, SLAs and the service catalogue stay in Freshservice. Brief row in `docs/briefs/integration-connectors.md`.

**Verify live at build time** (docs site is a JS SPA, could not be confirmed): the `updated_since` list param, `/api/v2/tickets/filter?query=` syntax and page cap, and whether `description_text` is returned by the list endpoint or only the single-ticket GET. If list omits it, clustering uses `subject` alone plus a per-ticket fetch for candidates only.

UI: the integration appears in the add-integration picker with a working credential form — both driven from `/api/v1/connectors`, no frontend work.