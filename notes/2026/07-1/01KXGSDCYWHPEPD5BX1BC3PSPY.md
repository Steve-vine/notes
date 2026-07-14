---
id: 01KXGSDCYWHPEPD5BX1BC3PSPY
created: 2026-07-14T17:04:54.236907626Z
updated: 2026-07-14T17:04:54.236907626Z
type: task
title: Decision records in-app
task_status: done
label: brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 45
---
Capture decision records (ADRs) inside Compass and migrate the repo's `decisions/` in — closing the "single source of truth" loop (ADR 0013, foreshadowed in ADR 0001). **Backend only**; the browse/author UI + linked-decision surfacing is <issue id="c20a24b7-29e6-4b57-92d2-1709451f1441" href="https://linear.app/stevevine/issue/DEV-463/decision-records-ui-linked-decision-surfacing">DEV-463</issue>.

**Agreed approach (planned 2026-06-17).** Mirrors the <issue id="d3a26549-40dd-4c14-9152-47129d684b16" href="https://linear.app/stevevine/issue/DEV-456/content-authoring-versioned-model-api">DEV-456</issue> entity pattern, the `Attachment` polymorphic-link precedent, and the `seed/controls.py`/`seed/policies.py` vendored-import pattern.

- [ ] `DecisionRecord` **model** (UUID + Timestamp + Actor + SoftDelete): `number` (unique int — the canonical identity, addressed as `/decisions/{number}`), `title`, `status` (`DecisionStatus`: proposed / accepted / superseded), `decided_on: date`, `body_markdown`, `superseded_by` (self-FK, SET NULL). Append-only spirit (ADR 0001): supersede, never rewrite.
- [ ] `DecisionLink` — polymorphic, mirroring `Attachment`: `decision_id` (FK RESTRICT) + `target_type` (core_control / risk / content_item) + `target_id` (no FK), soft-deletable, unique `(decision_id, target_type, target_id)`. One table, not three.
- [ ] **Migration** `0015_decision_records.py` (down_revision `0014`): `decision_records` (+ `decision_status` enum) and `decision_links` (+ `decision_link_target_type` enum).
- [ ] **Seed import**: vendor `decisions/0001–0020.md` into `src/compass_api/data/decisions/`; `seed/decisions.py` parses `# NNNN — Title`, `**Date:**`, `**Status:**` + body; idempotent keyed by `number`; all land `accepted`. New CLI `import-decisions`.
- [ ] **API** `api/v1/decisions.py`: `GET /decisions` (filter status) + `GET /decisions/{number}` any-auth; `POST` (admin/editor; auto-number = max+1 or explicit; optional `supersedes` sets old `status=superseded` + `superseded_by`); `PUT /decisions/{number}` (title/body/status/date); `POST`/`DELETE /decisions/{number}/links` (link/unlink a `{target_type,target_id}`, reactivating soft-deleted links).
- [ ] **Schemas** (`DecisionCreate/Update/Out`, `DecisionLinkCreate/Out`); register router + models.
- [ ] **Tests** (`tests/test_decisions.py`, real-Postgres): import seeds 20 & idempotent; list/get/create (auto-number); supersede sets old status + `superseded_by`; polymorphic link/unlink across control/risk/content; role enforcement; status filter.

Refs: ADR 0013, 0001, 0017. Depends on: <issue id="d3a26549-40dd-4c14-9152-47129d684b16" href="https://linear.app/stevevine/issue/DEV-456/content-authoring-versioned-model-api">DEV-456</issue> (done). Out of scope → <issue id="c20a24b7-29e6-4b57-92d2-1709451f1441" href="https://linear.app/stevevine/issue/DEV-463/decision-records-ui-linked-decision-surfacing">DEV-463</issue> (UI + linked-decision surfacing).

---
*Migrated from Linear [DEV-459](https://linear.app/stevevine/issue/DEV-459/decision-records-in-app) · created 2026-06-17 · completed 2026-06-17*  
*Related to (Linear): DEV-670*