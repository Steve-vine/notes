---
id: 01KXK82G1Z8AX0CJQ5JRCHA9PB
created: 2026-07-15T15:59:34.4633198Z
updated: 2026-07-15T16:00:10.333189056Z
type: task
title: Vendor API (/api/v1/vendors)
task_status: backlog
assignee: steve
label:
- brief
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 169
sprint: s1lenxu
---
The Phase-1 vendor REST surface (ADR 0039 §9), mirroring `api/v1/risks.py`/`assessments.py`.

- [ ] Schemas in `api/v1/schemas.py`: `VendorOut`, `VendorCreate`, `VendorUpdate`, `VendorRevisionOut`.
- [ ] `api/v1/vendors.py` (`APIRouter(prefix="/vendors", tags=["vendors"])`), registered in `api/v1/router.py`:
  - `GET /vendors` — company query param + filters state/status/criticality/owner_id/q [require_vendor_read]
  - `POST /vendors` — creates as state=new + first revision [require_vendor_write]
  - `GET /vendors/{id}` [read] · `PATCH /vendors/{id}` — validates state transitions against the model's map, writes a revision [write] · `DELETE /vendors/{id}` — soft delete [write]
  - `GET /vendors/{id}/revisions` [read]
- [ ] Integration tests (`tests/test_vendors.py`, `pytest.mark.integration`, template from `test_assessments.py`): CRUD, illegal transition 4xx, revision append, role gating (manager writes; owner/assessor/viewer read-only; assessor/analyst 403).

Branch `feature/com-<id>-vendor-api`. Ref: ADR 0039 §2, §9.