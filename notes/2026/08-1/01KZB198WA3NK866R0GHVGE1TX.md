---
id: 01KZB198WA3NK866R0GHVGE1TX
created: 2026-08-06T07:58:24.650359Z
updated: 2026-08-06T08:53:46.164247Z
type: task
title: Generic threshold config UI on the System page
project: 01KX671DATY39VW6GWK3M2T3DN
number: 579
sprint: syjypmr
blocked_by:
- 01KZB18ZQNJVZGXRYY1ZWTT7S8
assignee: steve
label: null
priority: medium
task_status: todo
---
The user-facing surface for declared thresholds: a generic card on the System detail page, rendered from each connector's `threshold_specs()` — no bespoke per-connector card needed ever again.

**An operator can:**
- See every declared threshold for the System: label/description, unit, current effective value, and whether it's the declared default or a per-System override (ISE-537 lesson — no invisible defaults).
- Edit a value within the spec's declared bounds (validated client- and server-side); clear an override back to default.
- See multi-rung ladders rendered as band → severity rows (e.g. ≤90d low / ≤60d medium / ≤30d high / expired critical), not as opaque numbers.

Renders from the `/api/v1` spec endpoint added by the threshold_specs() task. Only shown for connectors that declare specs. The bespoke `FreshserviceConfigCard.tsx` is replaced by this in the Freshservice migration task, not here.