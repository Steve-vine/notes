---
id: 01KYVNXP4JNJZX38JKK1VZM9EF
created: 2026-07-31T08:51:14.194688Z
updated: 2026-08-05T13:24:50.404944Z
type: task
title: EntraID foundation — GraphClient, credentials, health check, ADR 0063
project: 01KX671DATY39VW6GWK3M2T3DN
number: 387
order: 1.0625
sprint: setdxf2
comments:
- id: 01KYVSH214FJB9X2C2Z3F9FYVR
  author: Steve Vine
  at: 2026-07-31T09:54:14.691975Z
  text: |-
    Built and pushed — PR #364 (feature/ise-387-entraid-foundation → main, base of the stacked chain).

    Delivered: connectors/entraid.py (connector_type entraid, credential spec tenant_id/client_id/client_secret, structural validation, health via GET /organization revealing tenant identity, full capability set {alerts, entities, evidence, actions} with empty catalogue until the handlers land) + shared connectors/msgraph.py GraphClient (client-credentials token with per-scope cache, @odata.nextLink pagination, one bounded 429 Retry-After retry — the M365-shareable module, per the amendment) + ADR 0063.

    Note: the docs/decisions/README.md index stopped being maintained at ADR 0038 (0039-0065 are absent), so no index row was added — matching current practice.

    Tests: 14 new (Type surface, credential validation incl. store-time 422, health paths, token caching, AAD error prose, pagination, throttle). ruff + mypy strict + connector enumeration suites green. Zero new dependencies.
assignee: steve
label: null
priority: medium
task_status: done
---
New `connectors/entraid.py` (connector_type `entraid` — `entra` collides with settings.auth_mode for ISE's own login). `GraphClient` goes in a **shared module `connectors/msgraph.py`** (NOT inside entraid.py — the planned M365 sprint s10ybrs reuses it; decided with Steve 2026-07-31: M365 must work standalone, so reuse is module-level, never a runtime dependency on the EntraID integration). Modeled on ArmClient (azure.py): client-credentials token at login.microsoftonline.com scope `https://graph.microsoft.com/.default`, `@odata.nextLink` pagination, Cloudflare-style capped 429 retry (Graph throttles aggressively), `_bounded_key`. `credential_spec` tenant_id/client_id/client_secret (read SP only), `validate_credential` shape checks, `health_check` = GET /v1.0/organization, empty action catalogue. Register in connectors/__init__.py. Write **ADR 0063** (entity scope + type names, SP-as-entity, native keys `entra:{tenant_id}:{object_id}`, read-SP minimum Graph permissions, user-volume revisit trigger, GraphClient shared-module placement) + README index. Tests: test_entraid_connector.py, stubbed transport (token, pagination, 429 paths). Zero new deps.