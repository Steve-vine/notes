---
id: 01KXGSTFDGFP9VMGTECV5P7ZBR
created: 2026-07-14T17:12:02.73604046Z
updated: 2026-07-14T17:12:02.73604046Z
type: task
title: Unify risk band/status colours onto the StatusPill palette
label: follow_up
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 56
---
Follow-up to <issue id="1ca7973f-b0ed-4e2c-9a11-f44c51ecbdbb" href="https://linear.app/stevevine/issue/DEV-471/components-and-tables-refresh">DEV-471</issue> (M7): the Risk pages keep their own `riskBandColor`/`riskStatusColor` (risk/rubric.ts) with a slightly different palette to the shared `StatusPill` (e.g. band `low` green vs teal; risk status `open` gray, `accepted` green, `closed` dark). Unify so risk severity/status colours match the rest of the app.

- [ ] Extract the StatusPill colour map into a non-component module (`statusColors.ts`) exporting `statusColor(value)` (avoids the react-refresh only-export-components rule); `StatusPill` consumes it.
- [ ] `riskBandColor` / `riskStatusColor` delegate to `statusColor` — one source of truth. Risk band badges keep their rubric-driven **names** and composite labels (e.g. "Residual N") + variants; only the colour unifies.
- [ ] Tests: `statusColor` mapping; risk helpers delegate. Suite green.

Refs: ADR 0022. Frontend only; deploy to view.

---
*Migrated from Linear [DEV-473](https://linear.app/stevevine/issue/DEV-473/unify-risk-bandstatus-colours-onto-the-statuspill-palette) · created 2026-06-19 · completed 2026-06-19*  
*Related to (Linear): DEV-471*