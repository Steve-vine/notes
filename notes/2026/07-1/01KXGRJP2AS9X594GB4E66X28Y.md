---
id: 01KXGRJP2AS9X594GB4E66X28Y
created: 2026-07-14T16:50:18.826430663Z
updated: 2026-07-14T16:50:25.45192318Z
type: task
title: Assessment model + API
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 15
sprint: sz3kacg
---
The assessment heartbeat — per-company control assessment (ADR 0011/0015). Backend-only (UI is <issue id="2d5cda0c-0766-4c72-8dde-5097a9cc6c6c" href="https://linear.app/stevevine/issue/DEV-402/assessment-ui-control-panel-work-queue">DEV-402</issue>). Unblocks <issue id="d4405a69-bde0-4406-9a48-861b062926d4" href="https://linear.app/stevevine/issue/DEV-403/gaps-model-api-and-view">DEV-403</issue> (gaps), <issue id="2d5cda0c-0766-4c72-8dde-5097a9cc6c6c" href="https://linear.app/stevevine/issue/DEV-402/assessment-ui-control-panel-work-queue">DEV-402</issue> (assessment UI), <issue id="49df18ad-8140-4f5b-8332-5a0e3137abd5" href="https://linear.app/stevevine/issue/DEV-404/compliance-and-maturity-dashboard">DEV-404</issue> (dashboard).

**Agreed approach (plan-mode, 2026-06-14):**

**Models** (mixins from db/mixins.py)

* `Assessment` (UUID/Timestamp/Actor/SoftDelete + CompanyScopedMixin): `core_control_id` FK→core_controls RESTRICT, `applicable` bool, `applicability_justification`, `status` enum (not_implemented/partial/implemented/not_applicable), `maturity_level` int 0–5 null, `owner_id` FK→users null, `notes`, `evidence_links` JSONB list[str], `reviewed_at`/`next_review_at`. **Partial unique** (company_id, core_control_id) WHERE deleted_at IS NULL — one current per pair.
* `AssessmentRevision` (append-only): `assessment_id`, `revision` int, snapshot of every field — trend/history.
* Migration 0006 (autogenerate→house-style; alembic check).

**API** (writes admin/editor; reads any authed)

* `PUT /assessments` — upsert by {company_id, core_control_id}: create-or-update the current assessment + append a revision. 404 unknown company/control.
* `GET /assessments?company=<id>` (+ status/owner/maturity/domain/control filters); `GET /assessments/{id}`; `GET /assessments/{id}/revisions`.

**Tests:** upsert create+update (one row/pair, revisions increment), filters, revisions order, maturity 0–5 (422), 404, role gates (viewer 403, unauth 401).

**Resolved forks:** (1) upsert-by-pair (PUT) not classic POST/PATCH; (2) Gap auto-raise deferred to <issue id="d4405a69-bde0-4406-9a48-861b062926d4" href="https://linear.app/stevevine/issue/DEV-403/gaps-model-api-and-view">DEV-403</issue>.

**Soft dep:** maturity rubric (<issue id="4bfec9e6-6476-43ff-9a5c-2d25e4d9d8ec" href="https://linear.app/stevevine/issue/DEV-405/maturity-rubric-editable-reference-data">DEV-405</issue>) — `maturity_level` is a plain int now; definitions come later.

Out of scope: gaps (<issue id="d4405a69-bde0-4406-9a48-861b062926d4" href="https://linear.app/stevevine/issue/DEV-403/gaps-model-api-and-view">DEV-403</issue>), rubric FK (<issue id="4bfec9e6-6476-43ff-9a5c-2d25e4d9d8ec" href="https://linear.app/stevevine/issue/DEV-405/maturity-rubric-editable-reference-data">DEV-405</issue>), assessment UI (<issue id="2d5cda0c-0766-4c72-8dde-5097a9cc6c6c" href="https://linear.app/stevevine/issue/DEV-402/assessment-ui-control-panel-work-queue">DEV-402</issue>), dashboard (<issue id="49df18ad-8140-4f5b-8332-5a0e3137abd5" href="https://linear.app/stevevine/issue/DEV-404/compliance-and-maturity-dashboard">DEV-404</issue>). No chart/frontend changes. Refs: ADR 0011, 0015.

---
*Migrated from Linear [DEV-401](https://linear.app/stevevine/issue/DEV-401/assessment-model-api) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-402, DEV-405, DEV-403, DEV-394*