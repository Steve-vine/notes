---
id: 01KXGS9Z64EZRB79H2HF29BQJH
created: 2026-07-14T17:03:01.828143538Z
updated: 2026-07-14T17:03:07.78075627Z
type: task
title: 'Content authoring: versioned model + API'
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 42
sprint: sd5fyv6
---
The authored-content backbone (ADR 0013) — content as first-class, versioned, native Markdown, becoming the source of truth in place of the M2 read-only import. The foundation the rest of M5 builds on. Backend only; the editor UI is <issue id="bcc55d57-5fea-40ee-8a6f-57e65bda891e" href="https://linear.app/stevevine/issue/DEV-457/content-authoring-ui-markdown-editor-version-history">DEV-457</issue> and the "author from imported PDF" path is <issue id="fdec8752-724d-4b96-b838-12d790f10b31" href="https://linear.app/stevevine/issue/DEV-458/re-author-imported-policies-as-native-content">DEV-458</issue>.

**Agreed approach (planned 2026-06-17).** Builds on the existing M2 `ContentItem` model (migration 0005) + read-only `/content` API; mirrors the `Assessment`↔`AssessmentRevision` upsert/snapshot pattern.

- [ ] **Versioning & lifecycle.** Draft edits mutate `ContentItem.body` in place (no version row). **Publish** appends an immutable `ContentVersion` (1-based `version`, `body` snapshot, `change_note`, author/timestamp), bumps `current_version`, sets `status=published`. Published reads resolve to the latest `ContentVersion.body`, **falling back to** `item.body` so the 34 imported policies (no version rows) keep working. **Revert(v)** copies version *v*'s body into the draft (`status=draft`); history stays append-only.
- [ ] **New models** (registered in `models/__init__.py`): `content_version.py` (`ContentVersion`, append-only — UUID + Timestamp + Actor mixins, no soft-delete) and `content_control_link.py` (`ContentControlLink`: `content_item_id` × `core_control_id` — one table serving both content↔control and control↔implementing-procedure, since procedures are content items). content↔domain stays as the existing `domain_id` (ADR 0015).
- [ ] **Migration** `0014_content_versions_and_links.py` — hand-written, `down_revision = 0013_treatment_plans`; creates both tables.
- [ ] **API** (extend `api/v1/content.py`): `POST /content` (create draft), `PUT /content/{slug}` (update draft), `POST /content/{slug}/publish`, `GET /content/{slug}/versions`, `GET /content/{slug}/versions/diff?from=&to=` (server-side unified diff + both bodies), `POST /content/{slug}/revert`, `POST`/`DELETE /content/{slug}/controls/{control_id}` — all `require_role(admin, editor)`. Extend `GET /content` with `status`/`owner` filters; reads stay any-auth. Existing read paths unchanged.
- [ ] **Schemas**: `ContentCreate`, `ContentUpdate`, `ContentPublish`, `ContentVersionOut`, `ContentDiffOut`, link schemas; extend `ContentItemOut`/`Detail` with `owner_id`, `review_at`, `next_review_at`, linked control ids.
- [ ] **Tests** (`tests/test_content.py`, real-Postgres integration): create→edit→publish→version appears; second publish increments; diff; revert; link/unlink; role enforcement (viewer 403 / editor 200); M2-compat read (imported policy with no versions still serves `body`).

Refs: ADR 0013, 0015, 0017. Relates to: read-only content import (M2).

---
*Migrated from Linear [DEV-456](https://linear.app/stevevine/issue/DEV-456/content-authoring-versioned-model-api) · created 2026-06-17 · completed 2026-06-17*  
*Related to (Linear): DEV-410*