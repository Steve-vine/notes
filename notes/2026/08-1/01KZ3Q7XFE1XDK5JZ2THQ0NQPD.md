---
id: 01KZ3Q7XFE1XDK5JZ2THQ0NQPD
created: 2026-08-03T11:48:13.422473Z
updated: 2026-08-05T12:33:47.143463Z
type: task
title: Migrate all connectors to the generic summary; delete bespoke endpoints and cards
project: 01KX671DATY39VW6GWK3M2T3DN
number: 496
sprint: shk7zaj
assignee: steve
label: null
priority: medium
task_status: backlog
---
Move aws/azure/cloudflare/entraid/m365/freshservice/kubernetes summaries onto the generic summary capability; delete the per-connector `*-summary` endpoints + `_require_<type>` guards in `api/v1/systems.py`, the matching schemas in `api/v1/schemas.py`, and the connector-type switch + bespoke card components at `SystemDetailPage.tsx:1894`. Config editors (kind dictionary, cluster link, aws-config, freshservice-config) stay — this task is summaries only. Regenerate the OpenAPI snapshot (surface shrinks).