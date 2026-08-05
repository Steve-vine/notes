---
id: 01KYVS2P1BAA56XWVPVKPARTDE
created: 2026-07-31T09:46:23.659929Z
updated: 2026-08-05T14:25:12.421332Z
type: task
title: M365 foundation — connector, credentials, health check, ADR 0066
project: 01KX671DATY39VW6GWK3M2T3DN
number: 399
order: 1.5
sprint: s10ybrs
comments:
- id: 01KYW3MEJA5GN7P390W34RSQZB
  author: Steve Vine
  at: 2026-07-31T12:50:51.594639Z
  text: |-
    Built and in review — PR #371 (feature/ise-399-m365-foundation).

    - connectors/m365.py: connector_type m365, display name "Microsoft 365", read-only (Status Page shape — empty action catalogue, no write SP), capabilities {alerts, observations, entities, evidence}
    - Dedicated read SP credential (tenant_id/client_id/client_secret), GUID + mangled-secret structural validation wired into PUT /credentials; health_check = GET /v1.0/organization revealing tenant identity
    - Shared GraphClient from connectors/msgraph.py (module-level reuse only — no runtime dependency on EntraID)
    - ADR 0066 written: third-party service entities (NO migration), licensing as System-card data + Obs detectors, non-goals with revisit triggers (SharePoint/Teams entities, Intune, per-user licence detail), minimum permissions ServiceHealth.Read.All + Organization.Read.All (verify live at first consent)
    - Bonus: ADR README index was stale at 0038 — brought current through 0066
    - Tests: test_m365_connector.py, 9 passing (stubbed transport); ruff + mypy clean. Zero new deps, zero migrations.
assignee: steve
label: null
priority: medium
task_status: done
---
New `connectors/m365.py` (connector_type `m365`), read-only integration — Status Page shape: empty action catalogue, no write SP. Imports the shared `GraphClient` from **`connectors/msgraph.py`** (built by ISE-387; if this sprint runs first, create the shared module here and EntraID inherits it — decided 2026-07-31: module-level reuse only, M365 must work standalone with no runtime dependency on the EntraID integration). `credential_spec` tenant_id/client_id/client_secret — a **dedicated read SP**, never shared with EntraID's (separate consent/revocation is what makes standalone true operationally). `validate_credential` shape checks; `health_check` = GET /v1.0/organization. Register in connectors/__init__.py. Write **ADR 0066**: service-level estate as existing `third-party` entities (ISE-355 precedent, NO migration); licensing as System-card data + Obs detectors, NOT entities; explicit non-goals with revisit triggers — SharePoint sites/Teams as entities (weak signal story, cardinality), Intune devices (own product area); read-SP minimum permissions `ServiceHealth.Read.All` + `Organization.Read.All` (strings from model knowledge — **verify live at build time**, EntraID caveat). + README index. Tests: test_m365_connector.py, stubbed transport. Zero new deps.