---
id: 01KXGRF931R1W1H1JT3A1RZX05
created: 2026-07-14T16:48:27.233686665Z
updated: 2026-07-14T16:48:32.572666983Z
type: task
title: Read-only content import (policies)
task_status: done
label:
- brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 12
sprint: sz3kacg
---
Bring the existing policies in as read-only content per ADR 0013 (Phase 2 = read-only; authoring deferred to M5). Depends on Domain model (<issue id="6f8b0cb1-3b79-498a-8347-533231cce7bc" href="https://linear.app/stevevine/issue/DEV-397/domain-and-core-control-models-import-controlscsv">DEV-397</issue>, done). Shared, company-agnostic library (ADR 0017).

**Agreed approach (plan-mode, 2026-06-14):**

**Models** (mirror <issue id="6f8b0cb1-3b79-498a-8347-533231cce7bc" href="https://linear.app/stevevine/issue/DEV-397/domain-and-core-control-models-import-controlscsv">DEV-397</issue>; mixins from db/mixins.py)

- [ ] `ContentItem` (UUID/Timestamp/Actor/SoftDelete): `type` enum (policy|standard|process|procedure|runbook), `domain_id` nullable FK→domains RESTRICT, `title`, `slug` unique, `body` Text, `status` enum (draft|published), `owner_id` nullable, `review_at`/`next_review_at`, `current_version`.
- [ ] `Attachment` (UUID/Timestamp/Actor/SoftDelete): polymorphic `owner_type` enum (content_item|assessment|risk) + `owner_id` UUID (no FK), `filename`, `storage_key`, `content_type`, `size`.
- [ ] Migration 0005 (hand-authored; alembic check). Defer ContentVersion (M5) + ContentControlLink (later).

**Storage (env-driven, ADR 0008/0013)**

- [ ] `core/storage.py`: Storage protocol + LocalStorage; `get_storage()` on `STORAGE_BACKEND` (`local` now; `s3` → NotImplementedError + follow-up).
- [ ] config: `storage_backend=local`, `storage_local_path=/data/storage`.

**Importer**

- [ ] Vendor the 36 policy PDFs into the package; `seed/policies.py::import_policies` upserts a ContentItem per policy (domain by slug; AI policy → domain null), stores the PDF as an Attachment, placeholder body. Idempotent by slug. `cli import-policies`.

**Read API** (authenticated, read-only)

- [ ] `GET /content` (?type, ?domain), `GET /content/{slug}`, `GET /content/{slug}/attachments/{id}/download` (streams from storage). ContentItemOut/AttachmentOut.

**Chart**

- [ ] `pvc-storage.yaml` (local-path), mounted in api Deployment + import hook Job; values + values-k3s; extend job-import to run import-controls **and** import-policies.

**Frontend (minimal Content page)**

- [ ] Regenerate schema; add react-markdown; ContentPage (list) + ContentDetailPage (body via markdown, PDF via download endpoint in <object>); wire routes (Content nav exists).

**Tests:** `tests/test_content.py` (integration) — importer counts + idempotency, AI-policy domain null, list/detail/filter/download, 401/404, LocalStorage round-trip.

**Resolved forks:** (1) pluggable storage, local FS on k3s now / S3 prod = follow-up; (2) attach PDF + minimal body, view PDF in UI (re-author in M5); (3) include minimal Content frontend.

**Note:** 36 policy PDFs → 36 ContentItems; 35 link to domains, the "Artificial Intelligence Policy" has no domain (no controls in controls.csv) → domain_id null.

Refs: ADR 0013, 0015, 0017. Source: `policies/`.

---
*Migrated from Linear [DEV-398](https://linear.app/stevevine/issue/DEV-398/read-only-content-import-policies) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-397, DEV-420*