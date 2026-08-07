---
id: 01KZB198WA3NK866R0GHVGE1TX
created: 2026-08-06T07:58:24.650359Z
updated: 2026-08-07T10:06:59.109006Z
type: task
title: Generic threshold config UI on the System page
project: 01KX671DATY39VW6GWK3M2T3DN
number: 579
sprint: syjypmr
blocked_by:
- 01KZB18ZQNJVZGXRYY1ZWTT7S8
comments:
- id: 01KZB5N2120YSGMQCGMB2AVH1A
  author: Steve Vine
  at: 2026-08-06T09:14:45.154782Z
  text: |-
    Done — PR #493 (feature/ise-579-threshold-config-ui, stacked on #492).

    `ThresholdsCard` is the write-side sibling of the generic summary card (ADR 0083), and follows the same rule: no connector's name in the component, no `connector_type ===` gate on the System page, and a connector that declares nothing gets NO card rather than an empty one.

    All three acceptance points are built:
    - Every row shows label/description, the detector it shapes, the effective value with its unit, and a **Default / Overridden** badge — the ISE-537 lesson, so a defaulted number can never be mistaken for a chosen one. The Overridden badge's tooltip carries what the connector's default actually is.
    - Editing is bounds-validated on the row (the API refuses out-of-bounds too); clearing sends `null`, restoring the default rather than storing a zero. "Reset to defaults" clears a whole spec at once.
    - Ladders render as band -> severity rows. The connector declares a `direction`; the frontend supplies the words, so it reads "within 30 days -> high" rather than "30 -> high". Four bare numbers are not a ladder anyone can read.

    One guard beyond the plan: **ladder inversion is caught on the row**, not just at save. The API refuses it, but an inverted ladder's real failure mode is silence — a rung easier to reach than a milder one simply never fires — so the operator needs to see which row is wrong rather than a message about the save.

    10 component tests; full frontend suite green (636 tests, 105 files); lint, prettier and build clean.

    Worth flagging for smoke: **nothing is visible on this branch alone**, because no connector declares specs until ISE-580/582/581/583 land. That is the dependency order the tasks set — the card lights up on staging once the migrations merge, and M365/Kubernetes/Freshservice/EntraID Systems are where to look.
assignee: steve
priority: medium
task_status: done
---
The user-facing surface for declared thresholds: a generic card on the System detail page, rendered from each connector's `threshold_specs()` — no bespoke per-connector card needed ever again.

**An operator can:**
- See every declared threshold for the System: label/description, unit, current effective value, and whether it's the declared default or a per-System override (ISE-537 lesson — no invisible defaults).
- Edit a value within the spec's declared bounds (validated client- and server-side); clear an override back to default.
- See multi-rung ladders rendered as band → severity rows (e.g. ≤90d low / ≤60d medium / ≤30d high / expired critical), not as opaque numbers.

Renders from the `/api/v1` spec endpoint added by the threshold_specs() task. Only shown for connectors that declare specs. The bespoke `FreshserviceConfigCard.tsx` is replaced by this in the Freshservice migration task, not here.