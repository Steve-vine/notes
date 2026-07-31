---
id: 01KYWBD140W250K7BY89WVRB2Z
created: 2026-07-31T15:06:37.056512Z
updated: 2026-07-31T21:58:16.806703Z
type: task
title: 'Freshservice foundation: connector, client, credentials, ADR 0068'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 439
order: 1.25
sprint: s5pft6a
assignee: steve
priority: medium
task_status: todo
---
Foundation for the Freshservice integration (two-way: tickets as a signal source + ticket creation). No CMDB/asset sync — tickets only.

**Connector** — `connectors/freshservice.py`, `connector_type = "freshservice"`. Capabilities `{observations, evidence, actions}` — **no `entities`** (avoids the `ENTITY_TYPES` CHECK constraint entirely, so no migration). `sync_spec(slices=[])`.

**Client** — `FreshserviceClient` over httpx, modelled on `CloudflareClient`: `page`/`per_page` pagination (max 100, `link` header carries next), one bounded `Retry-After` retry on 429 (limits are plan-tiered, 100-500/min with a tighter List-Tickets sub-limit), `build_client` seam for `MockTransport` tests.

**Credentials** — `credential_spec()` = `domain` (not secret, e.g. `acme.freshservice.com`) + `api_key` (secret). Auth is HTTP Basic with Base64 of `api_key:X` (`X` a dummy password). `api_key` is **already in `REDACTED_KEY_PARTS`** — definition-of-done item 2 needs no change; note it in the PR. `validate_credential` for structural checks. `health_check` on `GET /api/v2/agents/me` — cheapest authenticated call, and it names the owning agent so verify surfaces both a domain mismatch and an accidentally-identical read/write key.

**ADR 0068** (`docs/decisions/0068-freshservice-connector.md`; 0066 is the closest template) covering: ticket signals as Observations not Alerts; the events layer as ticket storage; task-layer detection; entity-less signals and what is lost; the feedback-loop cut; the T1 justification. Must explicitly address the `product-vision.md:49` non-goal *"Not a general ITSM"* — that non-goal **stands**: ISE reads Freshservice as a detection source and writes exactly one artefact; queues, SLAs and the service catalogue stay in Freshservice. Brief row in `docs/briefs/integration-connectors.md`.

**Verify live at build time** (docs site is a JS SPA, could not be confirmed): the `updated_since` list param, `/api/v2/tickets/filter?query=` syntax and page cap, and whether `description_text` is returned by the list endpoint or only the single-ticket GET. If list omits it, clustering uses `subject` alone plus a per-ticket fetch for candidates only.

UI: the integration appears in the add-integration picker with a working credential form — both driven from `/api/v1/connectors`, no frontend work.