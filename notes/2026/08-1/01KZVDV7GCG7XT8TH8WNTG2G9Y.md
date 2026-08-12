---
id: 01KZVDV7GCG7XT8TH8WNTG2G9Y
created: 2026-08-12T16:45:46.892836Z
updated: 2026-08-12T16:45:46.892836Z
type: task
title: 'Run-report UI: surface engine_error_count (non-fatal engine warnings) on the step row'
task_status: done
priority: low
label: follow_up
assignee: steve
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 201
---
Follow-up from [DEV-582](<https://linear.app/stevevine/issue/DEV-582>) (PR #366).

DEV-582 added `engine_error_count` to the run-report API (`WorkflowRunReportStep`) — the count of non-fatal engine `error` events on a step (e.g. the new `NO_SUPPORTED_INPUTS` guard). The backend field is live but the **frontend run-report does not render it yet**.

### Scope

* Regenerate the frontend OpenAPI types (`npm run gen:api` → `src/lib/api/types.ts`) so `engine_error_count` is typed.
* In `app/frontend/src/features/workflow-runs/workflow-run-detail.tsx`, render a small indicator on a step row when `engine_error_count > 0` (e.g. "⚠ N engine warning(s)"), so an operator sees a non-fatal anomaly instead of an indistinguishable "succeeded / 0 assets".
* Update `workflow-run-detail.test.tsx`.

### Acceptance

* A step with `engine_error_count > 0` shows a visible warning indicator in the run-report UI.

---

Imported from Linear [DEV-596](https://linear.app/stevevine/issue/DEV-596/run-report-ui-surface-engine-error-count-non-fatal-engine-warnings-on)