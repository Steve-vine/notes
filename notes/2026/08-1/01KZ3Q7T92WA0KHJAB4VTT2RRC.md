---
id: 01KZ3Q7T92WA0KHJAB4VTT2RRC
created: 2026-08-03T11:48:10.146484Z
updated: 2026-08-05T12:34:53.137976Z
type: task
title: Generic connector summary capability
project: 01KX671DATY39VW6GWK3M2T3DN
number: 495
sprint: shk7zaj
assignee: steve
priority: medium
task_status: backlog
---
Connectors describe their own System-detail summary (labelled sections of key-value/list data) via a new spec method; one generic `/api/v1/systems/{id}/summary` endpoint and one generic SummaryCard render it. Replaces the pattern behind the ten per-connector `*-summary` endpoints in `api/v1/systems.py` and the bespoke card components in `SystemDetailPage.tsx`. Done = at least one connector (e.g. Cloudflare) served by the generic card end-to-end.