---
id: 01M293ZPMS5JE4D46AF78T2DVX
created: 2026-09-11T20:54:13.401913Z
updated: 2026-09-11T20:54:48.783701Z
type: task
title: Technology asset modal — descriptions under fields, Production/Non-Production, RTO/RPO units, access-method details
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
Smoke findings on the add/edit technology asset modal, 2026-09-11 (Steve). Four changes; the owner picker and review months are their own tasks.

1. **Field descriptions sit under the field**, not between label and input. Mantine's `description` renders above the input by default, so a described field (Status: "Whether it is live or still being built.") is taller than its neighbour and the two inputs no longer line up in a row. Use `inputWrapperOrder={['label','input','description','error']}` — set once as a theme default for the inventory modals (or app-wide if the screen-conventions test agrees; check other modals before deciding). Same fix applies to the data asset modal (its task).
2. **Environment** becomes two values: **Production** and **Non-Production**. Enum `container_environment` gains `non_production`; migration maps `staging` and `development` → `non_production`; the old values stay in the Postgres enum (cannot be dropped) but the API stops offering them and `ENVIRONMENT_ORDER` lists two. The CSV template and importer accept the two words only.
3. **RTO / RPO with a unit**: keep storing `rto_minutes` / `rpo_minutes`; the form shows a number plus a **Minutes / Hours** unit select per field (default Hours when the stored value divides by 60, else Minutes), converting on save. The detail page renders "4 hours" / "30 minutes" (whole hours where exact, otherwise minutes).
4. **Access methods** gain an optional free-text **Details** field beside the pills (`access_method_details`, Text, nullable) — "SSO via Entra; two local break-glass admins; API keys rotated quarterly". Shown on the detail's Access section and in the CSV template; editable by owners in the portal.

Tests: modal layout (description after input), environment options, RTO conversion both ways, details round-trip. Regenerate `schema.d.ts`.

**Acceptance**: Status and Environment sit level in their row; Environment offers exactly Production and Non-Production and existing staging/dev assets read Non-Production; entering RTO 4 hours stores 240 and displays 4 hours; the Details text survives edit and import.