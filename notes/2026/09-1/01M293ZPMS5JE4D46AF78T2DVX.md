---
id: 01M293ZPMS5JE4D46AF78T2DVX
created: 2026-09-11T20:54:13.401913Z
updated: 2026-09-11T21:07:59.324339Z
type: task
title: Technology asset modal — Production/Non-Production, RTO/RPO units, access-method details
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 676
sprint: skdc1az
blocked_by:
- 01M293Z1H0B3WJCES8PTN449DP
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Smoke findings on the add/edit technology asset modal, 2026-09-11 (Steve). Three changes; the owner picker, review months and row alignment (COM-679 — descriptions stay above the input) are their own tasks.

1. **Environment** becomes two values: **Production** and **Non-Production**. Enum `container_environment` gains `non_production`; migration maps `staging` and `development` → `non_production`; the old values stay in the Postgres enum (cannot be dropped) but the API stops offering them and `ENVIRONMENT_ORDER` lists two. The CSV template and importer accept the two words only.
2. **RTO / RPO with a unit**: keep storing `rto_minutes` / `rpo_minutes`; the form shows a number plus a **Minutes / Hours** unit select per field (default Hours when the stored value divides by 60, else Minutes), converting on save. The detail page renders "4 hours" / "30 minutes" (whole hours where exact, otherwise minutes).
3. **Access methods** gain an optional free-text **Details** field beside the pills (`access_method_details`, Text, nullable) — "SSO via Entra; two local break-glass admins; API keys rotated quarterly". Shown on the detail's Access section and in the CSV template; editable by owners in the portal.

Tests: environment options, RTO conversion both ways, details round-trip. Regenerate `schema.d.ts`.

**Acceptance**: Environment offers exactly Production and Non-Production and existing staging/dev assets read Non-Production; entering RTO 4 hours stores 240 and displays 4 hours; the Details text survives edit and import.