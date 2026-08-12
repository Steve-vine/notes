---
id: 01KZVG4CJJF3CKGE7M4TJK4FY0
created: 2026-08-12T17:25:44.146947Z
updated: 2026-08-12T17:26:38.833283Z
type: task
title: Wire up Cancel Scan button (API + dispatcher + frontend)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 381
sprint: s5d7bqn
assignee: steve
imported_from: linear
label: null
priority: medium
task_status: done
---
The "Cancel scan" button on the scan detail screen (`app/frontend/src/features/scans/scan-detail.tsx`) is currently a disabled placeholder with aria-label "Cancel scan (coming soon)". Wire it up end-to-end.

## Scope

**Backend**

* New endpoint `POST /api/v1/scans/{scan_id}/cancel` (analyst+, tenant-scoped). 409 if already terminal; 404 cross-tenant.
* For QUEUED / RUNNING ScanJobs: set `status = CANCELLED`, `finished_at = now()`. Re-aggregate …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-173](https://linear.app/stevevine/issue/DEV-173/wire-up-cancel-scan-button-api-dispatcher-frontend)