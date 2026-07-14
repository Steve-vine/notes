---
id: 01KXGRM8WT8NFPCJ36WP2KXENN
created: 2026-07-14T16:51:10.874917802Z
updated: 2026-07-14T16:51:10.874917802Z
type: task
title: 'Assessment UI: control panel + work-queue'
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 16
---
The assessor's working surfaces (ADR 0011/0017). Frontend-only — consumes the <issue id="22be79b0-66a1-4a2c-aec7-85b7237ae575" href="https://linear.app/stevevine/issue/DEV-401/assessment-model-api">DEV-401</issue> assessment API; deps <issue id="22be79b0-66a1-4a2c-aec7-85b7237ae575" href="https://linear.app/stevevine/issue/DEV-401/assessment-model-api">DEV-401</issue> + <issue id="eba6e737-9bfc-4229-b4aa-8550996f7d30" href="https://linear.app/stevevine/issue/DEV-399/domains-and-controls-browse-ui">DEV-399</issue> done.

**Agreed approach (plan-mode, 2026-06-14):**

* Regenerate `schema.d.ts` for the `/assessments` types; add Assessment/AssessmentUpsert/AssessmentRevision to `client.ts`.
* **AssessmentPanel** on the control detail page (replaces the placeholder): applicable + justification, status, maturity, owner (Assign to me/Clear — no users API yet), evidence links (TagsInput), notes, review dates; + revision history.
* **AssessmentsQueuePage** (`/assessments`): join all controls + the company's assessments client-side ("Not assessed" where none); filter by domain/status/maturity/mine; **inline status + maturity** edit per row.
* Route wired in `App.tsx`.

**Correctness:** the upsert PUT replaces all fields, so every edit (inline + panel) sends the **full current assessment merged** with the change — never just the changed field — to avoid clobbering notes/evidence/justification.

**Resolved forks:** (1) owner = assign-to-me/clear (full picker waits for <issue id="464f27a1-68ff-4504-bd80-eb4a1c927646" href="https://linear.app/stevevine/issue/DEV-406/admin-users-api-tokens-companies">DEV-406</issue>); (2) inline status+maturity in the queue, full edit on the panel.

**Tests:** Vitest — queue join + inline edit fires PUT; panel loads + Save sends merged PUT.

Out of scope: users API/owner picker (<issue id="464f27a1-68ff-4504-bd80-eb4a1c927646" href="https://linear.app/stevevine/issue/DEV-406/admin-users-api-tokens-companies">DEV-406</issue>), Domains/Controls list placeholder columns (dashboard territory, <issue id="49df18ad-8140-4f5b-8332-5a0e3137abd5" href="https://linear.app/stevevine/issue/DEV-404/compliance-and-maturity-dashboard">DEV-404</issue>), gaps (<issue id="d4405a69-bde0-4406-9a48-861b062926d4" href="https://linear.app/stevevine/issue/DEV-403/gaps-model-api-and-view">DEV-403</issue>). No backend/chart changes. Refs: ADR 0011, 0017.

---
*Migrated from Linear [DEV-402](https://linear.app/stevevine/issue/DEV-402/assessment-ui-control-panel-work-queue) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-406, DEV-401*