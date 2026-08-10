---
id: 01KZEPWE659A7HYH9B869W15AX
created: 2026-08-07T18:13:36.069625Z
updated: 2026-08-10T18:27:58.473401Z
type: task
title: 'Reports: definitions, builder and preview'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 615
sprint: sw5yz4n
comments:
- id: 01KZNYBJMA607KDCYBYPFA6KK2
  author: Steve Vine
  at: 2026-08-10T13:38:53.194203Z
  text: |-
    Built and pushed as PR #576 (branch feature/ise-615-reports-definitions).

    Numbers changed from the plan (other sprints landed in between): ADR **0095** (not 0093), migration **0121** (not 0106), ui-brief **§13**.

    What landed:
    - `report` + `report_run` tables (mig 0121). Three JSONB documents on `report`, not one blob — three validators, three consumers. Partial `ix_report_due` so on-demand reports never enter the dispatcher's index.
    - `reports/` package: template registry (2 A4 templates as package data, `get_template` the only lookup seam), `ReportQuerySpec` + `run_query`, `ReportSchedule` + `compute_next_run_at`.
    - `attribute_filters.sort_expression(key, descending=)` — the existing CASE-guarded casts used for ORDER BY, NULLS LAST in both directions.
    - CRUD/templates/preview endpoints (viewer read, operator write, audited); `next_run_at` always derived server-side, never accepted from a client.
    - Frontend: nav entry, `/reports` route, ReportsPage list, ReportModal (template picker → the template's own declared fields → query builder → predicates → columns/sort → schedule → preview).

    Two things found while building:
    1. **The preview cap was written as a replacement for the spec's `limit` rather than a ceiling on it** — a report asking for 2 rows previewed 50, i.e. a preview of something other than what the run would produce. Caught by the truncation test, fixed to `min(spec.limit, limit, MAX_ROWS)`.
    2. `reports/templates.py` beside a `reports/templates/` data directory shadows the module on import (mypy caught it, Python resolved it the wrong way round). The data package is `reports/assets/`.

    Also lifted the twice-copied `apiErrorMessage` into `lib/apiError` — the builder is the screen where "Could not save" instead of "at most 12 columns" costs the most.

    Verification: 16 schedule unit tests (DST gap fires an hour late rather than skipping the day; DST fold fires once on the first reading; day_of_month 31 clamps to 28 Feb, and on 28 Feb the next one is 31 March not 28 March); real-Postgres API tests covering roles, ten validation rejections, and the query traps (a `ne` filter keeping rows that never had the key, a date filter surviving an attribute whose value is the string "whenever", a mixed-type sort, a group scope walking the part-of edge); migration data-path test on a populated DB; 7 frontend tests including the edit round-trip and cadence-switch selector stripping.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
New Reports section in ISE Core: author, preview and save a report in the app. ADR 0093 (deterministic query spec, calendar scheduler, S3 artifacts, server-rendered PDF) and ui-brief §13 land here. Migration 0106 (`report` + `report_run` tables). New `reports/` package: code-declared template registry (2 A4 Jinja2 templates, portrait/landscape, fields title/subtitle), `ReportQuerySpec` + `run_query` (reuses `attribute_filters.AttributeFilter`; adds group-scope EXISTS + public `attribute_filters.sort_expression`), `ReportSchedule` + `compute_next_run_at` (calendar cadence, IANA tz, DST-tested). CRUD/templates/preview endpoints (viewer read / operator write, audited). Frontend: nav entry, route, ReportsPage list, ReportModal (template picker → dynamic fields, query builder, schedule setter, preview table).

Done = a user can create, edit, preview and save a report in the UI. Carries a migration; needs api-types regen.