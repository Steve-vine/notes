---
id: 01KYQQ9YG6Z30R2E2R43WFPF30
created: 2026-07-29T19:58:26.822264Z
updated: 2026-08-05T12:34:07.097163Z
type: task
title: Azure connector foundation — add an Azure subscription to ISE
project: 01KX671DATY39VW6GWK3M2T3DN
number: 364
sprint: s0d5f5q
comments:
- id: 01KYQZ1CXF9WRS4VDKZQY0Y8B6
  author: Steve Vine
  at: 2026-07-29T22:13:35.279078Z
  text: |-
    Built and in review — PR #337 (feature/ise-364-azure-connector-foundation), merged to staging.

    New `azure` Integration Type (ADR 0059 written), read-only v1 capabilities {alerts, entities, evidence}, empty action catalogue. Service principal + client secret credential with structural validation (GUID shape for tenant/client/subscription ids, mangled-paste detection for the secret value); health check reads the subscription and surfaces display name + id + state.

    Two deliberate deltas from the AWS foundation, recorded in the ADR: (1) NO Azure SDK — a minimal ArmClient (client-credentials token, nextLink pagination) over the already-present httpx, so zero new backend dependencies and no lockfile churn; (2) NO region config tenant — ARM is a global control plane, so there is no azure-config analogue of the aws-config endpoints. client_secret was already covered by the log-redaction list. 9 integration tests; ruff/mypy clean.
assignee: steve
label: null
priority: medium
task_status: done
---
New `azure` integration type, mirroring the AWS foundation (ISE-358, ADR 0058). One integration instance per **subscription**. Auth: service principal + **client secret** — `tenant_id` / `client_id` / `client_secret` / `subscription_id` in the existing credential store (static-credential pattern, as chosen for AWS). Connector skeleton with declared capabilities (ADR 0031); credential validation on add (e.g. read the subscription); instance appears on Systems with graceful degradation. ADR: Azure integration (companion to ADR 0058; number at build time, likely 0059).