---
id: 01KZVCNK4ATSAQHZVS7171N51Q
created: 2026-08-12T16:25:13.610373Z
updated: 2026-08-12T16:26:41.910178Z
type: task
title: Improve the edit Workflows function
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 168
sprint: skesb93
assignee: steve
imported_from: linear
label:
- improvement
priority: null
task_status: done
---
## Brief

Redesign the workflow create/edit experience as a **full-screen, in-place drag-and-drop builder**, replacing the cramped 640px Radix dialog + accordion form.

### Why

The current editor is a small dialog hosting an accordion of step cards reordered with up/down arrows, where each step asks for a "Step kind" (Selector / Scan) then an engine. It's clunky, and the Selector/Scan split is dead weight — the backend dropped `step_kind` from workflow steps (Brief 061/DEV-268); ordering is a plain `position` int and routing keys off engine `accepts_asset_kinds`.

### Target UX (agreed)

* Edit happens **in place** on the workflow detail screen (Edit toggles into the builder; Save/Cancel). No dialog.
* **Create** drops into the same full-screen builder with an empty canvas (new `/workflows/new` route).
* Left rail = **flat searchable palette of all engines**; drag onto the canvas to append or insert between steps; drag to reorder.
* Per-step **params edited via an "Edit" button → modal**.
* Selector/Scan concept removed — just engines.
* Invalid chains: **drop freely + non-blocking inline warnings** (reuse `computeKindWarnings`).
* **Explicit Save/Cancel**.
* v1 **linear chain**; design leaves room for a future DAG (no branching now).

### Scope

* **Frontend only** — no backend/API/migration. Save payload per step is unchanged: `{engine_name, params, position, name, disabled}`.
* New dep: **@dnd-kit** (core/sortable/utilities), headless + accessible; noted in `docs/external-components.md`.
* New components: `workflow-builder`, `engine-palette`, `workflow-canvas`, `workflow-step-node`, `step-params-dialog`, `engine-params-fields`.
* Retire `workflow-form.tsx`, `workflow-step-editor.tsx`, `step-kind-colours.ts` (salvage schema, `computeKindWarnings`, `workflowToFormValues`, server-error mapping, params seeding + bespoke lookup).
* Every drag affordance mirrored by an accessible button (keyboard / mobile tap-to-add / e2e).

### Verification

Unit tests (vitest+RTL) for builder behaviours + `computeKindWarnings`; `npm run build`; rewrite the `workflow-to-asset` e2e smoke (create now navigates to `/workflows/new`, add engine via palette "Add" button, Save); build image + rollout on k3s + containerised Playwright smoke vs [dev.redvektor.net](<http://dev.redvektor.net>).

*Full plan retained in session plan file.*

---

Imported from Linear [DEV-700](https://linear.app/stevevine/issue/DEV-700/improve-the-edit-workflows-function)