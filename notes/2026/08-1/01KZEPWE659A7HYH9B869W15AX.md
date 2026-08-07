---
id: 01KZEPWE659A7HYH9B869W15AX
created: 2026-08-07T18:13:36.069625Z
updated: 2026-08-07T18:13:36.069625Z
type: task
title: 'Reports: definitions, builder and preview'
label: feature
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 615
---
New Reports section in ISE Core: author, preview and save a report in the app. ADR 0093 (deterministic query spec, calendar scheduler, S3 artifacts, server-rendered PDF) and ui-brief §13 land here. Migration 0106 (`report` + `report_run` tables). New `reports/` package: code-declared template registry (2 A4 Jinja2 templates, portrait/landscape, fields title/subtitle), `ReportQuerySpec` + `run_query` (reuses `attribute_filters.AttributeFilter`; adds group-scope EXISTS + public `attribute_filters.sort_expression`), `ReportSchedule` + `compute_next_run_at` (calendar cadence, IANA tz, DST-tested). CRUD/templates/preview endpoints (viewer read / operator write, audited). Frontend: nav entry, route, ReportsPage list, ReportModal (template picker → dynamic fields, query builder, schedule setter, preview table).

Done = a user can create, edit, preview and save a report in the UI. Carries a migration; needs api-types regen.