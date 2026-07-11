---
id: 01KX8GYQZV0CS4FF5HWF041GH7
created: 2026-07-11T12:03:09.947338828Z
updated: 2026-07-11T17:11:26.536333497Z
type: task
title: UI — System detail
priority: medium
task_status: review
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 28
blocked_by:
- 01KX8GY8VRP7405VR5X6MYFNGV
sprint: sdm5e08
comments:
- id: 01KX92K728A991ZXN1GMS960N3
  author: Steve Vine
  at: 2026-07-11T17:11:26.536251527Z
  text: 'Development complete on feature/ise-028-system-detail. PR #28: https://github.com/Steve-vine/ise/pull/28. System detail page at /systems/:id built on the ISE-25 read endpoints: header (name, health pill, staleness pill, last-sync time), connector/config summary (type, enabled, interval, last sync, description, last-sync error), this system''s open-findings table (severity/title/last-seen), and browsable state slices with per-slice summary+sync time and a lazy JSON payload drill-in via /state/{slice}. Overview cards now click through to it. Backend additive (ADR 0009): POST /systems/{id}/sync (operator-gated) enqueues sync_system.delay to bypass the interval for an immediate refresh — 409 if disabled, 404 if unknown, 403 below operator, audited as sync_requested; the idempotent read means a manual trigger can''t corrupt state. \"Sync now\" button shown only to operator+ (RBAC mirrored client-side; API is the authority). Regenerated openapi.json+types. Tests: backend mypy/ruff clean, 4 new trigger-sync integration tests + 56 systems/sync/state/connector pass; frontend tsc/eslint/prettier clean, 21 tests (3 new — Overview live card, detail renders slices/findings, Sync-button RBAC visibility). PR CI fully green. Merged to staging (6e0155e); staging CI green end-to-end INCLUDING the deploy-staging smoke check this time (confirming ISE-27''s smoke failure was the transient TCP flake). Verified LIVE on g5: ise-api/frontend/worker/beat all freshly rolled (~30s) and 1/1 Running. Awaiting UI smoke test + merge clearance.'
---
Per-system view (ui-brief): browsable synced state slices with per-slice sync times, native findings, open issues for this system, connector health/config summary. Staleness visible. Trigger-sync action (role-gated). Uses the ISE-25 read endpoints and generated types.