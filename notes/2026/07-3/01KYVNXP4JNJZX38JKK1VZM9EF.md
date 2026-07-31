---
id: 01KYVNXP4JNJZX38JKK1VZM9EF
created: 2026-07-31T08:51:14.194688Z
updated: 2026-07-31T08:51:14.194688Z
type: task
title: EntraID foundation — GraphClient, credentials, health check, ADR 0063
label: feature
assignee: steve
task_status: backlog
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 387
---
New `connectors/entraid.py` (connector_type `entraid` — `entra` collides with settings.auth_mode for ISE's own login). `GraphClient` modeled on ArmClient (azure.py): client-credentials token at login.microsoftonline.com scope `https://graph.microsoft.com/.default`, `@odata.nextLink` pagination, Cloudflare-style capped 429 retry (Graph throttles aggressively), `_bounded_key`. `credential_spec` tenant_id/client_id/client_secret (read SP only), `validate_credential` shape checks, `health_check` = GET /v1.0/organization, empty action catalogue. Register in connectors/__init__.py. Write **ADR 0063** (entity scope + type names, SP-as-entity, native keys `entra:{tenant_id}:{object_id}`, read-SP minimum Graph permissions, user-volume revisit trigger) + README index. Tests: test_entraid_connector.py, stubbed transport (token, pagination, 429 paths). Zero new deps.