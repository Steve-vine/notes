---
id: 01KXGRWFPPH53D3CZ52B0HWF2R
created: 2026-07-14T16:55:39.99093416Z
updated: 2026-07-18T16:04:34.324536Z
type: task
title: 'Domains & Controls UI: browse the control library'
task_status: cancelled
label:
- follow_up
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 25
sprint: sz3kacg
---
Surfaced during <issue id="6f8b0cb1-3b79-498a-8347-533231cce7bc" href="https://linear.app/stevevine/issue/DEV-397/domain-and-core-control-models-import-controlscsv">DEV-397</issue>/<issue id="750519e8-c2c4-4b5b-b112-e161fa0574f1" href="https://linear.app/stevevine/issue/DEV-420/deploy-pipeline-roll-ghcr-images-on-k3s-auto-seed-control-library">DEV-420</issue>. The control library is live at the API (`/api/v1/domains`, `/api/v1/controls`) and seeded on deploy (35 domains / 269 controls), but there are no frontend screens to browse it yet — the deployed UI shows only the app shell + login.

Build the read-only browse screens per the IA (ADR 0017, brief/information-architecture.md):

* **Domains** nav item → domain list (ordered, with control counts).
* **Domain detail** → the domain's controls table; row → control.
* **Controls** nav item → flat, searchable control index ("jump straight to ACC.4").
* **Control detail** → the canonical control text. (The per-company assessment panel, revision history and linked procedures come with the assessment briefs.)

Consumes only the public `/api/v1` (slug for domains, ref for controls). Company-agnostic shared library — no company scoping. Parent: <issue id="6f8b0cb1-3b79-498a-8347-533231cce7bc" href="https://linear.app/stevevine/issue/DEV-397/domain-and-core-control-models-import-controlscsv">DEV-397</issue>.

---
*Migrated from Linear [DEV-421](https://linear.app/stevevine/issue/DEV-421/domains-and-controls-ui-browse-the-control-library) · created 2026-06-14 · closed 2026-06-14 as duplicate of DEV-399*